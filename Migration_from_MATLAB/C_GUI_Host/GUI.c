#include "GUI.h"
#include <ctype.h>
#include <string.h>
#include <stdlib.h>


GQueue *waiting_tabs = NULL;
GMutex queue_lock;


struct PreampData { ClientSettings *s; int i; };

// ----------------- HELPER CALLBACKS -------------------
static gboolean hex_input_filter(GtkWidget *widget, GdkEventKey *event, gpointer data) {
    if (event->keyval == GDK_KEY_BackSpace ||
        event->keyval == GDK_KEY_Delete ||
        event->keyval == GDK_KEY_Left ||
        event->keyval == GDK_KEY_Right ||
        event->keyval == GDK_KEY_Tab)
        return FALSE;
    char c = (char)event->string[0];
    return !isxdigit(c);
}

static void sr_combo_changed(GtkComboBox *c, gpointer user_data) {
    ClientSettings *s = user_data;
    s->sample_rate = atoi(gtk_combo_box_text_get_active_text(GTK_COMBO_BOX_TEXT(c)));
}

static void dur_entry_changed(GtkEditable *e, gpointer user_data) {
    ClientSettings *s = user_data;
    s->duration_seconds = atoi(gtk_entry_get_text(GTK_ENTRY(e)));
}

static void preamp_changed(GtkComboBox *c, gpointer user_data) {
    struct PreampData *d = user_data;
    d->s->preamp[d->i] = atoi(gtk_combo_box_text_get_active_text(GTK_COMBO_BOX_TEXT(c)));
}

static void settings_reg_changed(GtkEditable *e, gpointer user_data) {
    struct PreampData *d = user_data;
    const char *txt = gtk_entry_get_text(GTK_ENTRY(e));
    if (strlen(txt) == 2)
        d->s->settings_reg[d->i] = (unsigned char)strtol(txt, NULL, 16);
}

// ----------------- MEMORY-FRIENDLY REMOVE CLIENT -------------------
void free_client_info(ClientInfo *info)
{
    if (!info) return;

    // Close socket if connected
    if (info->conn) {
        GSocket *sock = g_socket_connection_get_socket(info->conn);
        if (sock) g_socket_close(sock, NULL);
        g_object_unref(info->conn);
    }

    // Free ClientSettings
    if (info->settings)
        g_free(info->settings);

    // Free measurement buffer
    if (info->measurement_data)
        g_free(info->measurement_data);

    // Free TimeSync buffer
    if (info->client_time_sync)
        g_free(info->client_time_sync);

    //remove connection statur monitor and syncronize measurement thread
    info->destroying = 1;
    if (info->monitor_id > 0) {
      g_source_remove(info->monitor_id);
      info->monitor_id = 0;
    }
    if (info->measurement_thread) g_thread_join(info->measurement_thread);

    // Remove notebook page (destroys all children, including widgets holding PreampData)
    if (info->notebook && info->tab_content) {
        gint page_num = gtk_notebook_page_num(GTK_NOTEBOOK(info->notebook),
                                              info->tab_content);
        if (page_num != -1)
            gtk_notebook_remove_page(GTK_NOTEBOOK(info->notebook), page_num);
    }

    // Destroy close button if it’s outside tab_content
    if (info->close_button) {
        gtk_widget_destroy(info->close_button);
        info->close_button = NULL;
    }

    // Free preamp_data array (only the array, not the widgets)
    if (info->preamp_data)
        g_ptr_array_free(info->preamp_data, FALSE);

    // Free ClientInfo itself
    g_free(info);
}


// ----------------- CALLBACKS -------------------
void on_remove_client_clicked(GtkButton *btn, gpointer user_data) {
    ClientInfo *info = user_data;
    free_client_info(info);
}

void on_close_waiting_tab_clicked(GtkButton *btn, gpointer user_data) {
    ClientInfo *info = user_data;

    // Remove from waiting queue
    g_mutex_lock(&queue_lock);
    GList *iter = g_queue_find(waiting_tabs, info);
    if (iter) g_queue_delete_link(waiting_tabs, iter);
    g_mutex_unlock(&queue_lock);

    free_client_info(info);
}

// ----------------- ASSIGN CLIENT -------------------
void assign_client_to_waiting_tab(GSocketConnection *conn, const char* client_name, uint8_t float_count ,GtkWidget *notebook) {
    g_mutex_lock(&queue_lock);
    if (g_queue_is_empty(waiting_tabs)) {
        g_mutex_unlock(&queue_lock);

        g_warning("No waiting tabs available! Creating one automatically...\n");

        // Create new waiting tab
        ClientInfo *new_info = create_waiting_tab(notebook);

        // Put it into the queue so the standard logic works
        g_mutex_lock(&queue_lock);
        g_queue_push_tail(waiting_tabs, new_info);
        g_mutex_unlock(&queue_lock);

        // Now proceed exactly as if a waiting tab already existed
        g_mutex_lock(&queue_lock);
    }

    ClientInfo *info = g_queue_pop_head(waiting_tabs);
    g_mutex_unlock(&queue_lock);

    if (!info) return;

    info -> destroying = 0;

    if (info->close_button) {
        gtk_widget_destroy(info->close_button);
        info->close_button = NULL;
    }

    char text[64];
    snprintf(text, sizeof(text), "%s", client_name);
    gtk_label_set_text(GTK_LABEL(info->tab_label), text);
    set_tab_label_color_text(info->tab_label, text, TRUE);

    info->conn = g_object_ref(conn);
    info->float_count = float_count;

    // Start periodic connection check (once per 5 seconds)
    info->monitor_id = g_timeout_add(5000, monitor_client_connection, info);
    
    GtkWidget *remove_btn = gtk_button_new_with_label("Remove Client");
    gtk_box_pack_start(GTK_BOX(info->tab_content), remove_btn, FALSE, FALSE, 4);
    g_signal_connect(remove_btn, "clicked", G_CALLBACK(on_remove_client_clicked), info);

    if (!info->preamp_data)
        info->preamp_data = g_ptr_array_new_with_free_func(g_free);

    GtkWidget *win = gtk_widget_get_toplevel(notebook);

    build_client_ui(info, win);
    gtk_widget_show_all(info->tab_content);
    g_object_set_data(G_OBJECT(info->tab_content), "client_info", info);
}

// ----------------- SOCKET CALLBACK -------------------
gboolean on_client_incoming(GSocketService *service,
                            GSocketConnection *conn,
                            GObject *src,
                            gpointer user_data)
{
    GtkWidget *notebook = GTK_WIDGET(user_data);

    GSocket *sock = g_socket_connection_get_socket(conn);
    if (!sock) return FALSE;

    //Read the first package ---
    TcpPackage pkg;
    gboolean ok = get_next_tcp_package(sock, &pkg, 150); // 150 ms timeout
    if (!ok) return FALSE;

    char tab_label_text[64] = "Unknown Client";
    uint8_t float_count = 0;

    //Handle handshake package ---
    if (pkg.package_type == HANDSHAKE_PACKAGE && pkg.package_size > 0) {
        float_count = pkg.package[0];
        char *client_name = (char *)(pkg.package + 1);

        g_snprintf(tab_label_text, sizeof(tab_label_text), "%s", client_name);

        // g_print("Received HANDSHAKE_PACKAGE: float_count=%d, client_name=\"%s\"\n", float_count, client_name);
    }

    //Send zero byte as ACK ---
    GOutputStream *out = g_io_stream_get_output_stream(G_IO_STREAM(conn));
    uint8_t ack = 0;
    g_output_stream_write(out, &ack, 1, NULL, NULL);

    //Assign client to waiting tab ---
    assign_client_to_waiting_tab(conn, tab_label_text, float_count,notebook);  

    //Update ClientInfo ---
    //ClientInfo *info = g_object_get_data(G_OBJECT(tab_content), "client_info");
    //if (info) info->float_count = float_count;
    //else printf("info is null\n");
    //printf("float_count is: %d", info->float_count);

    free_tcp_package(&pkg);
    return TRUE;
}







// ----------------- BUILD CLIENT UI -------------------
void build_client_ui(ClientInfo *info, GtkWidget *win)
{
    if (!info || !win) return;

    GtkWidget *tab_box = info->tab_content;

    // Allocate settings once
    info->settings = g_new0(ClientSettings, 1);

    // Initialize preamp_data array
    if (!info->preamp_data)
        info->preamp_data = g_ptr_array_new(); // no free_func now

  // Main horizontal box inside the tab
  GtkWidget *hbox = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 10);
  gtk_box_pack_start(GTK_BOX(tab_box), hbox, TRUE, TRUE, 0);

  /* --- LEFT SCROLLABLE PANEL --- */
  GtkWidget *left_scrolled = gtk_scrolled_window_new(NULL, NULL);
  gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(left_scrolled),
                                 GTK_POLICY_NEVER,
                                 GTK_POLICY_AUTOMATIC);
  gtk_widget_set_size_request(left_scrolled, 300, -1);  // fixed width

  gtk_box_pack_start(GTK_BOX(hbox), left_scrolled, FALSE, FALSE, 10);

  GtkWidget *left_box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
  gtk_container_add(GTK_CONTAINER(left_scrolled), left_box);

  
  // MIDDLE PANEL (LIVE PLOT)
  GtkWidget *middle_box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
  gtk_box_pack_start(GTK_BOX(hbox), middle_box, TRUE, TRUE, 0);
  
  // Create drawing area
  GtkWidget *plot_area = gtk_drawing_area_new();
  gtk_widget_set_size_request(plot_area, 800, 400);
  gtk_box_pack_start(GTK_BOX(middle_box), plot_area, TRUE, TRUE, 0);
  gtk_widget_show(plot_area);
  
  // Store in tab_content for later access
  g_object_set_data(G_OBJECT(info->tab_content), "plot_area", plot_area);
  
  // Connect draw handler
  g_signal_connect(plot_area, "draw", G_CALLBACK(on_plot_draw), info);
  

  /* --- RIGHT SCROLLABLE PANEL --- */
  GtkWidget *right_scrolled = gtk_scrolled_window_new(NULL, NULL);
  gtk_scrolled_window_set_policy(GTK_SCROLLED_WINDOW(right_scrolled),
                                 GTK_POLICY_AUTOMATIC,
                                 GTK_POLICY_AUTOMATIC);
  gtk_widget_set_size_request(right_scrolled, 300, -1);  // fixed width

  //Pack on the right
  gtk_box_pack_end(GTK_BOX(hbox), right_scrolled, TRUE, FALSE, 10);

  GtkWidget *right_box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
  gtk_container_add(GTK_CONTAINER(right_scrolled), right_box);

    
    

  // Sample Rate
  GtkWidget *sr_label = gtk_label_new("Sample Rate");
  GtkWidget *sr_combo = gtk_combo_box_text_new();
  //const char *sr_vals[] = {"1000","2000","4000","8000","16000","32000","64000"};
  const char *sr_vals[] = {"1000","2000"};  // only enable fully supported speeds
  for (int i = 0; i < 2; i++)
      gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(sr_combo), sr_vals[i]);
  gtk_combo_box_set_active(GTK_COMBO_BOX(sr_combo), 0);
  g_signal_connect(sr_combo, "changed",
                   G_CALLBACK(sr_combo_changed), info->settings);
  g_object_set_data(G_OBJECT(info->tab_content), "sr_combo", sr_combo);
  gtk_box_pack_start(GTK_BOX(left_box), sr_label, FALSE, FALSE, 3);
  gtk_box_pack_start(GTK_BOX(left_box), sr_combo, FALSE, FALSE, 3);
  
  // Duration
  // Retrieve global duration entry from the main window
  GtkWidget *global_dur_entry =
      g_object_get_data(G_OBJECT(win), "global_dur_entry");  
  // Fallback value
  const char *global_val = "300";  
  if (global_dur_entry != NULL) {
      global_val = gtk_entry_get_text(GTK_ENTRY(global_dur_entry));
  }
  
  // Duration (read-only)
  GtkWidget *dur_label = gtk_label_new("Global Duration (seconds)");
  GtkWidget *dur_entry = gtk_entry_new();
  gtk_entry_set_text(GTK_ENTRY(dur_entry), global_val);
  
  // Make read-only
  gtk_editable_set_editable(GTK_EDITABLE(dur_entry), FALSE);
  gtk_widget_set_sensitive(dur_entry, FALSE);
  
  // Store for global update handler
  g_object_set_data(G_OBJECT(info->tab_content), "dur_entry", dur_entry);
  
  gtk_box_pack_start(GTK_BOX(left_box), dur_label, FALSE, FALSE, 3);
  gtk_box_pack_start(GTK_BOX(left_box), dur_entry, FALSE, FALSE, 3);

  

  // 8x Preamp + Settings Register
  for (int i = 0; i < 8; i++) {
      char lbltxt[64];
      snprintf(lbltxt, sizeof(lbltxt), "CHAN %d - Preamp", i+1);
      GtkWidget *pre_label = gtk_label_new(lbltxt);
      GtkWidget *pre_combo = gtk_combo_box_text_new();
      // --- Preamp combo ---
      for (int v = 0; v <= 12; v++) {
          if (!(v == 1 || v == 2 || v == 4 || v == 8 || v == 12)) continue;
          char buf[16]; snprintf(buf, sizeof(buf), "%d", v);
          gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(pre_combo), buf);
      }
      gtk_combo_box_set_active(GTK_COMBO_BOX(pre_combo), 0);
      struct PreampData *pdata = g_new(struct PreampData, 1);
      pdata->s = info->settings;
      pdata->i = i;
      // Let GTK own pdata, it will free automatically when pre_combo is destroyed
      g_object_set_data_full(G_OBJECT(pre_combo), "preamp_data", pdata, g_free);
      g_signal_connect(pre_combo, "changed", G_CALLBACK(preamp_changed), pdata);
      gtk_box_pack_start(GTK_BOX(left_box), pre_label, FALSE, FALSE, 3);
      gtk_box_pack_start(GTK_BOX(left_box), pre_combo, FALSE, FALSE, 3);
      // --- Settings register ---
      snprintf(lbltxt, sizeof(lbltxt), "CHAN %d - Settings Register (hex byte)", i+1);
      GtkWidget *reg_label = gtk_label_new(lbltxt);
      GtkWidget *reg_entry = gtk_entry_new();
      gtk_entry_set_max_length(GTK_ENTRY(reg_entry), 2);
      gtk_entry_set_text(GTK_ENTRY(reg_entry), "10");
      g_signal_connect(reg_entry, "key-press-event", G_CALLBACK(hex_input_filter), NULL);
      struct PreampData *pdata2 = g_new(struct PreampData, 1);
      pdata2->s = info->settings;
      pdata2->i = i;
      g_object_set_data_full(G_OBJECT(reg_entry), "preamp_data", pdata2, g_free);
      g_signal_connect(reg_entry, "changed", G_CALLBACK(settings_reg_changed), pdata2);
      gtk_box_pack_start(GTK_BOX(left_box), reg_label, FALSE, FALSE, 3);
      gtk_box_pack_start(GTK_BOX(left_box), reg_entry, FALSE, FALSE, 3);
      
      //Store widgets in tab_content so we can access later
      char preamp_key[32], reg_key[32];
      snprintf(preamp_key, sizeof(preamp_key), "preamp_combo_%d", i);
      snprintf(reg_key, sizeof(reg_key), "reg_entry_%d", i);
      g_object_set_data(G_OBJECT(tab_box), preamp_key, pre_combo);
      g_object_set_data(G_OBJECT(tab_box), reg_key, reg_entry);

      // Optional: track widgets in preamp_data array if needed
      g_ptr_array_add(info->preamp_data, pre_combo);
      g_ptr_array_add(info->preamp_data, reg_entry);
  }
  GtkWidget *load_btn = gtk_button_new_with_label("Load JSON Settings...");
  gtk_box_pack_start(GTK_BOX(right_box), load_btn, FALSE, FALSE, 5);
  g_signal_connect(load_btn, "clicked", G_CALLBACK(on_load_json_clicked), info);
  
  //Sample number to zero
  info->settings->sample_number = 0;

  //send settings & start measurement button
  GtkWidget *start_btn = gtk_button_new_with_label("Start Measurement");
  gtk_box_pack_start(GTK_BOX(right_box), start_btn, FALSE, FALSE, 5);
  g_signal_connect(start_btn, "clicked", G_CALLBACK(on_send_btn_clicked), info);
  
  //Stop Measurement button
  GtkWidget *stop_btn = gtk_button_new_with_label("Stop Measurement");
  gtk_widget_set_sensitive(stop_btn, FALSE); // initially inactive
  gtk_box_pack_start(GTK_BOX(right_box), stop_btn, FALSE, FALSE, 5);
  g_object_set_data(G_OBJECT(info->tab_content), "stop_btn", stop_btn);
  g_signal_connect(stop_btn, "clicked", G_CALLBACK(on_stop_btn_clicked), info);

  //Export Measurement data button
  GtkWidget *export_btn = gtk_button_new_with_label("Export to CSV");
  gtk_widget_set_sensitive(export_btn, FALSE); // initially inactive
  gtk_box_pack_start(GTK_BOX(right_box), export_btn, FALSE, FALSE, 5);
  g_signal_connect(export_btn, "clicked", G_CALLBACK(on_export_csv_clicked), info);
  g_object_set_data(G_OBJECT(info->tab_content), "export_btn", export_btn);
  

  //connection status label
  GtkWidget *status_label = gtk_label_new("DISCONNECTED");
  gtk_box_pack_end(GTK_BOX(right_box), status_label, FALSE, FALSE, 5);
  info->status_label = status_label;

}








// ----------------- ADD CLIENT BUTTON -------------------
void on_add_client_clicked(GtkButton *btn, gpointer user_data) {
    GtkWidget *notebook = GTK_WIDGET(user_data);

    ClientInfo *info = create_waiting_tab(notebook);

    g_mutex_lock(&queue_lock);
    g_queue_push_tail(waiting_tabs, info);
    g_mutex_unlock(&queue_lock);

    gtk_widget_show_all(notebook);
}






//-------------HELPER SET PREAMP SETTINGS FILE-----------------
static void set_preamp_combo(GtkWidget *combo, int value) {
    if (!GTK_IS_COMBO_BOX_TEXT(combo)) return;

    GtkTreeModel *model = gtk_combo_box_get_model(GTK_COMBO_BOX(combo));
    GtkTreeIter iter;
    gboolean valid;
    int index = 0;

    valid = gtk_tree_model_get_iter_first(model, &iter);
    while (valid) {
        gchar *txt = NULL;
        gtk_tree_model_get(model, &iter, 0, &txt, -1);  // 0 = text column
        if (txt) {
            if (atoi(txt) == value) {
                gtk_combo_box_set_active(GTK_COMBO_BOX(combo), index);
                g_free(txt);
                return;
            }
            g_free(txt);
        }
        valid = gtk_tree_model_iter_next(model, &iter);
        index++;
    }
}







//-----------------LOAD SETTINGS FROM JSON----------------------

static void on_load_json_clicked(GtkButton *btn, ClientInfo *info)
{
    GtkWidget *dlg = gtk_file_chooser_dialog_new(
        "Load Settings JSON",
        NULL,
        GTK_FILE_CHOOSER_ACTION_OPEN,
        "_Cancel", GTK_RESPONSE_CANCEL,
        "_Open", GTK_RESPONSE_ACCEPT,
        NULL);

    if (gtk_dialog_run(GTK_DIALOG(dlg)) != GTK_RESPONSE_ACCEPT) {
        gtk_widget_destroy(dlg);
        return;
    }

    char *filename = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(dlg));
    gtk_widget_destroy(dlg);

    JsonParser *parser = json_parser_new();
    if (!json_parser_load_from_file(parser, filename, NULL)) {
        g_warning("Failed to parse JSON.");
        g_free(filename);
        g_object_unref(parser);
        return;
    }
    g_free(filename);

    JsonObject *obj = json_node_get_object(json_parser_get_root(parser));

    /* ---- Load into settings struct ---- */
    info->settings->sample_rate = json_object_get_int_member(obj, "sample_rate");
    info->settings->duration_seconds = json_object_get_int_member(obj, "duration_sec");

    JsonArray *channels = json_object_get_array_member(obj, "channels");
    for (int i = 0; i < 8; i++) {
        JsonObject *ch = json_array_get_object_element(channels, i);
        info->settings->preamp[i] = json_object_get_int_member(ch, "preamp");

        const char *hex = json_object_get_string_member(ch, "settings_reg_hex");
        info->settings->settings_reg[i] = (uint8_t) strtol(hex, NULL, 16);
    }

    /* ---- Now update UI widgets ---- */

    /* Sample Rate combo */
    GtkWidget *sr_combo = g_object_get_data(G_OBJECT(info->tab_content), "sr_combo");
    if (sr_combo) {
        char buf[16];
        snprintf(buf, sizeof(buf), "%d", info->settings->sample_rate);

        // GTK3-compatible iteration over GtkComboBoxText
        GtkTreeModel *model = gtk_combo_box_get_model(GTK_COMBO_BOX(sr_combo));
        GtkTreeIter iter;
        gboolean valid = gtk_tree_model_get_iter_first(model, &iter);
        int index = 0;

        while (valid) {
            gchar *txt = NULL;
            gtk_tree_model_get(model, &iter, 0, &txt, -1);  // column 0 = text
            if (txt) {
                if (strcmp(txt, buf) == 0) {
                    gtk_combo_box_set_active(GTK_COMBO_BOX(sr_combo), index);
                    g_free(txt);
                    break;
                }
                g_free(txt);
            }
            valid = gtk_tree_model_iter_next(model, &iter);
            index++;
        }
    }

    /* Duration entry */
    GtkWidget *dur_entry = g_object_get_data(G_OBJECT(info->tab_content), "dur_entry");
    if (dur_entry) {
        char buf[16];
        snprintf(buf, sizeof(buf), "%d", info->settings->duration_seconds);
        gtk_entry_set_text(GTK_ENTRY(dur_entry), buf);
    }

    /* Update 8× preamp + register widgets */
    for (int i = 0; i < 8; i++) {
        GtkWidget *pre_combo = g_ptr_array_index(info->preamp_data, 2*i);
        GtkWidget *reg_entry = g_ptr_array_index(info->preamp_data, 2*i + 1);

        set_preamp_combo(pre_combo, info->settings->preamp[i]);

        char hexbuf[4];
        snprintf(hexbuf, sizeof(hexbuf), "%02X", (uint8_t)info->settings->settings_reg[i]);
        gtk_entry_set_text(GTK_ENTRY(reg_entry), hexbuf);
    }

    g_object_unref(parser);
}






//-----------------SEND SETTINGS TO CONNECTED CLIENT AND START MEASUREMENT --------------------

static void send_settings_to_client(ClientInfo *info) {
    if (!info || !info->conn || !info->settings) return;

    ClientSettings *s = info->settings;
    GtkWidget *tab = info->tab_content;

    // --- Read UI values and update settings struct ---
    GtkWidget *sr_combo = g_object_get_data(G_OBJECT(tab), "sr_combo");
    if (sr_combo) {
        const gchar *sr_text = gtk_combo_box_text_get_active_text(GTK_COMBO_BOX_TEXT(sr_combo));
        if (sr_text) s->sample_rate = (uint32_t)atoi(sr_text);
    }

    GtkWidget *dur_entry = g_object_get_data(G_OBJECT(tab), "dur_entry");
    if (dur_entry) {
        const gchar *dur_text = gtk_entry_get_text(GTK_ENTRY(dur_entry));
        if (dur_text) s->duration_seconds = atoi(dur_text);
    }

    // Read Preamp and Settings Registers from widgets
    for (int i = 0; i < 8; i++) {
        char preamp_key[32], reg_key[32];
        snprintf(preamp_key, sizeof(preamp_key), "preamp_combo_%d", i);
        snprintf(reg_key, sizeof(reg_key), "reg_entry_%d", i);

        GtkWidget *pre_combo = g_object_get_data(G_OBJECT(tab), preamp_key);
        GtkWidget *reg_entry = g_object_get_data(G_OBJECT(tab), reg_key);

        if (pre_combo) {
            const gchar *txt = gtk_combo_box_text_get_active_text(GTK_COMBO_BOX_TEXT(pre_combo));
            if (txt) s->preamp[i] = (uint8_t)atoi(txt);
        }
        if (reg_entry) {
            const gchar *txt = gtk_entry_get_text(GTK_ENTRY(reg_entry));
            if (txt) s->settings_reg[i] = (uint16_t)strtol(txt, NULL, 16);
        }
    }

    // Compute sample_number for measurement
    s->sample_number = (uint64_t)s->sample_rate * (s->duration_seconds);   

    // --- Pack data into TcpPackage ---
    TcpPackage pkg;
    pkg.package_type = SETTINGS_PACKAGE; 
    pkg.package_size = sizeof(uint64_t) + sizeof(uint32_t) + 8*sizeof(uint16_t) + 8*sizeof(uint8_t);
    pkg.package = g_malloc(pkg.package_size); // Allocate memory for data

    unsigned char *p = pkg.package;
    memcpy(p, &s->sample_number, sizeof(s->sample_number)); p += sizeof(s->sample_number);
    memcpy(p, &s->sample_rate, sizeof(s->sample_rate));     p += sizeof(s->sample_rate);
    memcpy(p, s->settings_reg, 8*sizeof(uint16_t));         p += 8*sizeof(uint16_t);
    memcpy(p, s->preamp, 8*sizeof(uint8_t));                p += 8;

    // --- Send package over TCP ---
    GSocket *sock = g_socket_connection_get_socket(info->conn);
    if (!sock || !G_IS_SOCKET(sock)) {
        g_warning("Client socket invalid. Aborting send.");
        g_free(pkg.package);
        return;
    }

    // --- Send 5-byte header (type + size) ---
    uint8_t header[5];
    header[0] = pkg.package_type;
    uint32_t size_net = g_htonl(pkg.package_size);  // Convert to network byte order
    memcpy(header+1, &size_net, 4);

    GError *err = NULL;
    gssize bytes_sent = g_socket_send(sock, header, sizeof(header), NULL, &err);
    if (bytes_sent != sizeof(header)) {
        g_warning("Failed to send package header: %s", err ? err->message : "unknown");
        if (err) g_error_free(err);
        g_free(pkg.package);
        free_client_info(info);  // Disconnect client safely
        return;
    }

    // --- Send actual package data ---
    bytes_sent = g_socket_send(sock, pkg.package, pkg.package_size, NULL, &err);
    if (bytes_sent != pkg.package_size) {
        g_warning("Failed to send full settings package: %s",
                  err ? err->message : "partial send");
        if (err) g_error_free(err);
        g_free(pkg.package);
        free_client_info(info);  // Disconnect client
        return;
    }

    // --- Clean up memory ---
    g_free(pkg.package);
}



//----------HANDLER FOR SEND SETTINGS AND START BUTTON @CLIENT------------------
static void on_send_btn_clicked(GtkButton *button, gpointer user_data) {
    ClientInfo *info = (ClientInfo *)user_data;
    send_settings_to_client(info);
    //Don't start again if measurement is in RAM
    if(info->write_index > 0) return;
    // Activate Stop button
    GtkWidget *stop_btn = g_object_get_data(G_OBJECT(info->tab_content), "stop_btn");
    if (stop_btn) gtk_widget_set_sensitive(stop_btn, TRUE);
    // Activate CSV export button
    GtkWidget *export_btn = g_object_get_data(G_OBJECT(info->tab_content), "export_btn");
    if (export_btn) gtk_widget_set_sensitive(export_btn, TRUE);
    
    /* ---- Allocate Measurement Buffer ---- */
    uint64_t n = info->settings->sample_number;
    uint64_t alloc_n = n + 4000;

    if (info->measurement_data)
        g_free(info->measurement_data);
    if (info->client_time_sync)
        g_free(info->client_time_sync);

    info->measurement_data = g_malloc0(sizeof(float) * info->float_count * alloc_n);
    info->allocated_samples = alloc_n - 1000;
    info->write_index = 0;
    info->allocated_client_times = info->settings->duration_seconds / 10 + 10;
    info->client_time_sync = g_malloc0((info-> allocated_client_times) * sizeof(ClientTime));
    info->measurement_active = TRUE;
    // Start reading measurement data on new thread
    info->measurement_thread = g_thread_new("measurement-reader", measurement_thread_func, info);

}





//----------HANDLER FOR STOP BUTTON @CLIENT------------------
static void on_stop_btn_clicked(GtkButton *button, gpointer user_data) {
    ClientInfo *info = (ClientInfo *)user_data;
    if (!info || !info->conn) return;

    info->measurement_active = FALSE;
    // Remove the GSource polling
    if (info->measurement_thread) {
        g_thread_join(info->measurement_thread);
        info->measurement_thread = NULL;
    }

    // --- Send empty STOP_PACKAGE ---
    TcpPackage pkg;
    pkg.package_type = STOP_PACKAGE;
    pkg.package_size = 0;
    pkg.package = NULL;

    GSocket *sock = g_socket_connection_get_socket(info->conn);
    if (!sock) return;

    // Send 5-byte header (type + size)
    uint8_t header[5];
    header[0] = pkg.package_type;
    uint32_t size_net = g_htonl(pkg.package_size);
    memcpy(header + 1, &size_net, 4);

    GError *err = NULL;
    g_socket_send(sock, header, sizeof(header), NULL, &err);
    if (err) {
        g_warning("Failed to send STOP_PACKAGE: %s", err->message);
        g_error_free(err);
    }

     // If button is NULL (Stop All), fetch the stored one and then disable it
    GtkWidget *stop_btn = GTK_WIDGET(button);
    if (!stop_btn) {
        stop_btn = g_object_get_data(G_OBJECT(info->tab_content), "stop_btn");
    }

    if (GTK_IS_WIDGET(stop_btn)) {
        gtk_widget_set_sensitive(stop_btn, FALSE);
    } else {
        g_warning("Stop button widget not found for this tab");
    }
    

    g_message("Measurement stopped by user.");
}







//---------------CREATE A WAITING TAB TO BE ASSIGNED-----------------------
// button depreacated, but funcion used to assign clients
ClientInfo* create_waiting_tab(GtkWidget *notebook) {
    GtkWidget *label = gtk_label_new("Waiting...");
    GtkWidget *box = gtk_box_new(GTK_ORIENTATION_VERTICAL,10);
    gtk_notebook_append_page(GTK_NOTEBOOK(notebook), box, label);

    ClientInfo *info = g_new0(ClientInfo,1);
    info->tab_label = label;
    info->tab_content = box;
    info->notebook = notebook;

    GtkWidget *btn_close = gtk_button_new_with_label("Close Tab");
    gtk_box_pack_start(GTK_BOX(box), btn_close, FALSE, FALSE, 4);
    info->close_button = btn_close;
    g_signal_connect(btn_close, "clicked", G_CALLBACK(on_close_waiting_tab_clicked), info);

    gtk_widget_show_all(box);
    return info;
}






//--------------HELPER TO SET CONNECTION LABEL-------------------
static void set_status_label(GtkWidget *label, gboolean connected)
{
    if (!label) return;

    if (connected)
        gtk_label_set_markup(GTK_LABEL(label),
            "<span foreground=\"green\" weight=\"bold\">CONNECTED</span>");
    else
        gtk_label_set_markup(GTK_LABEL(label),
            "<span foreground=\"red\" weight=\"bold\">DISCONNECTED</span>");
}



//-----------------HELPER FOR CONNECTION STATUS-------------------
// Returns G_SOURCE_REMOVE if disconnected, G_SOURCE_CONTINUE otherwise
static gboolean monitor_client_connection(gpointer user_data) {
    ClientInfo *info = user_data;
    if (!info || info->destroying) return FALSE;   // stop immediately

    // If client is already disconnected, stop monitoring
    if (!info || !info->conn) {
        set_status_label(info ? info->status_label : NULL, FALSE);
        return G_SOURCE_REMOVE;
    }

    GSocket *sock = g_socket_connection_get_socket(info->conn);
    if (!sock) {
        set_status_label(info->status_label, FALSE);
        return G_SOURCE_REMOVE;
    }

    // --- Build a ping package ---
    TcpPackage pkg;
    pkg.package_type = PING_PACKAGE;
    pkg.package_size = 16;
    pkg.package = g_malloc0(pkg.package_size); // Zeroed 16-byte ping

    // --- Send 5-byte header ---
    uint8_t header[5];
    header[0] = pkg.package_type;
    uint32_t size_net = g_htonl(pkg.package_size);
    memcpy(header+1, &size_net, 4);

    GError *err = NULL;
    gssize bytes_sent = g_socket_send(sock, header, sizeof(header), NULL, &err);
    if (bytes_sent != sizeof(header)) {
        g_warning("Ping header send failed: %s", err ? err->message : "unknown");
        if (err) g_error_free(err);
        g_free(pkg.package);
        disconnect_client(info); // Disconnect client safely
        return G_SOURCE_REMOVE;
    }

    // --- Send ping data ---
    bytes_sent = g_socket_send(sock, pkg.package, pkg.package_size, NULL, &err);
    g_free(pkg.package);

    // If ping fails, disconnect client
    if (bytes_sent != pkg.package_size) {
        g_warning("Ping failed: sent %zd of %u bytes, %s",
                  bytes_sent, pkg.package_size, err ? err->message : "unknown");
        if (err) g_error_free(err);
        disconnect_client(info); // Disconnect client
        return G_SOURCE_REMOVE;
    }

    // Ping successful, mark client as connected
    set_status_label(info->status_label, TRUE);
    set_tab_label_color_text(info->tab_label, gtk_label_get_text(GTK_LABEL(info->tab_label)), TRUE);
    return G_SOURCE_CONTINUE; // Continue monitoring
}






//----------DISCONNECT TCP CLIENT ----------------------------
static void disconnect_client(ClientInfo *info) {
    if (!info) return;

    info->measurement_active = FALSE;

    // Stop future pings
    if (info->monitor_id > 0) {
        g_source_remove(info->monitor_id);
        info->monitor_id = 0;
    }

    // Close connection, but DO NOT free the GUI
    if (info->conn) {
        GSocket *sock = g_socket_connection_get_socket(info->conn);
        if (sock) g_socket_close(sock, NULL);
        g_object_unref(info->conn);
        info->conn = NULL;
    }

    // Update the status label
    set_status_label(info->status_label, FALSE);
    set_tab_label_color_text(info->tab_label, gtk_label_get_text(GTK_LABEL(info->tab_label)), FALSE);
}



//----------------HELPER TO COLOR IN TAB LABELS------------------------
static void set_tab_label_color_text(GtkWidget *label, const char *text, gboolean connected){
    if (!label || !text) return;

    char buf[128];
    snprintf(buf, sizeof(buf),
             "<span foreground=\"%s\" weight=\"bold\">%s</span>",
             connected ? "green" : "red",
             text);

    gtk_label_set_markup(GTK_LABEL(label), buf);
}






// ---------------- Helper: read exactly n bytes from GSocket ----------------
static gboolean read_bytes(GSocket *sock, guint8 *buffer, gsize n, guint32 timeout_ms) {
    if (!sock || !buffer || n == 0) return FALSE;

    gsize read_so_far = 0;
    GError *err = NULL;
    gint64 start_time = g_get_real_time();

    while (read_so_far < n) {
        gssize bytes = g_socket_receive(sock, buffer + read_so_far, n - read_so_far, NULL, &err);
        if (bytes > 0) {
            read_so_far += bytes;
        } else if (bytes == 0) {
            // Peer closed connection
            return FALSE;
        } else {
            // bytes < 0, error
            if (err) {
                g_warning("Socket read error: %s", err->message);
                g_error_free(err);
            }
            return FALSE;
        }

        // Timeout check
        gint64 now = g_get_real_time();
        gint64 elapsed_us = now - start_time;
        if (elapsed_us > timeout_ms*1000) return FALSE;
    }

    return TRUE;
}





// ----------------Read TcpPackage from socket ----------------
gboolean read_tcp_package(GSocket *sock, TcpPackage *pkg, guint32 timeout_ms) {
    if (!sock || !pkg) return FALSE;

    guint8 header[5]; // 1 byte type + 4 bytes size
    if (!read_bytes(sock, header, sizeof(header), timeout_ms)) return FALSE;

    pkg->package_type = header[0];
    pkg->package_size = (uint32_t)header[1] << 24 |
                        (uint32_t)header[2] << 16 |
                        (uint32_t)header[3] << 8 |
                        (uint32_t)header[4];

    if (pkg->package_size > 0) {
        pkg->package = g_malloc(pkg->package_size);
        if (!pkg->package) return FALSE;

        if (!read_bytes(sock, pkg->package, pkg->package_size, timeout_ms)) {
            g_free(pkg->package);
            pkg->package = NULL;
            return FALSE;
        }
    } else {
        pkg->package = NULL;
    }

    return TRUE;
}






// ---------------- Helper: free TcpPackage ----------------
void free_tcp_package(TcpPackage *pkg) {
    if (!pkg) return;
    if (pkg->package) g_free(pkg->package);
    pkg->package = NULL;
}








// ---------------- Getter: next TCP package ----------------
gboolean get_next_tcp_package(GSocket *sock, TcpPackage *pkg, guint32 timeout_ms) {
    if (!sock || !pkg) return FALSE;
    return read_tcp_package(sock, pkg, timeout_ms);
}







// ------------------ Measurement Thread ------------------
static gpointer measurement_thread_func(gpointer user_data) {
    ClientInfo *info = (ClientInfo *)user_data;
    if (!info || !info->conn) return NULL;

    GSocket *sock = g_socket_connection_get_socket(info->conn);
    if (!sock) return NULL;

    time_t last_timestamp_sent = 0;

    while (info->measurement_active && !info->destroying) {
        time_t now = time(NULL);

        // --- 1. Send TIMESTAMP_PACKAGE every ~10s ---
        if (difftime(now, last_timestamp_sent) >= 10) {
            last_timestamp_sent = now;
        
            // Prepare the timestamp and float data
            struct timespec ts;
            clock_gettime(CLOCK_REALTIME, &ts);     // or CLOCK_MONOTONIC, depending on meaning
        
            // --- 2. Create the TcpPackage structure ---
            TcpPackage ts_pkg;
            ts_pkg.package_type = TIMESTAMP_PACKAGE;
            ts_pkg.package_size = sizeof(struct timespec);
            ts_pkg.package = malloc(ts_pkg.package_size);
            if (ts_pkg.package) {
                // --- Copy the timestamp into the package ---
                memcpy(ts_pkg.package, &ts, sizeof(struct timespec));
            
                // --- 3. Create a buffer large enough to hold both header and data ---
                uint8_t *buffer = malloc(5 + ts_pkg.package_size); // 5 bytes for header + package size
                if (!buffer) {
                    g_warning("Memory allocation for buffer failed.");
                    free(ts_pkg.package);
                    return G_SOURCE_REMOVE;
                }
            
                // --- 4. Fill the buffer with header and data ---
                // Fill in the header
                buffer[0] = ts_pkg.package_type;
                uint32_t size_net = htonl(ts_pkg.package_size);  // Convert size to network byte order
                memcpy(buffer + 1, &size_net, 4);  // Copy size into the buffer
            
                // Fill in the data (timestamp and float)
                memcpy(buffer + 5, ts_pkg.package, ts_pkg.package_size);
            
                // --- 5. Send the entire buffer in one call ---
                GError *err = NULL;
                gssize bytes_sent = g_socket_send(sock, buffer, 5 + ts_pkg.package_size, NULL, &err);
                if (bytes_sent != (5 + ts_pkg.package_size)) {
                    g_warning("Timestamp package send failed: %s", err ? err->message : "unknown");
                    if (err) g_error_free(err);
                    free(buffer);
                    free(ts_pkg.package);
                    disconnect_client(info); // Disconnect client safely
                    return G_SOURCE_REMOVE;
                }
            
                // Clean up
                free(buffer);
                free(ts_pkg.package);
            }
        }


        // --- 2. Receive incoming packages ---
        TcpPackage pkg;
        gboolean ok = get_next_tcp_package(sock, &pkg, 150); // 150ms timeout
        if (!ok) {
            g_usleep(2000); // avoid busy loop
            continue;
        }

        if (pkg.package_type == DATA_PACKAGE && pkg.package_size > 0) {
            // Handle measurement data
            size_t row_size = info->float_count * sizeof(float);
            size_t n_rows = pkg.package_size / row_size;

            if (info->write_index + n_rows > info->settings->sample_number) {
                g_warning("Measurement buffer full. Stopping measurement.");
                info->measurement_active = FALSE;

                GtkWidget *stop_btn = g_object_get_data(G_OBJECT(info->tab_content), "stop_btn");
                if (stop_btn)
                    g_idle_add((GSourceFunc)on_stop_btn_clicked, stop_btn);

                free_tcp_package(&pkg);
                break;
            }

            memcpy(&info->measurement_data[info->write_index * info->float_count],
                   pkg.package,
                   n_rows * row_size);

            info->write_index += n_rows;

            GtkWidget *plot_area = g_object_get_data(G_OBJECT(info->tab_content), "plot_area");
            if (plot_area) g_idle_add((GSourceFunc)gtk_widget_queue_draw, plot_area);
        }
        else if (pkg.package_type == TIMESTAMP_PACKAGE &&
                 pkg.package_size >= sizeof(struct timespec) + sizeof(float)) {
            // Handle incoming echoed timestamp
            if (info->time_write_index < info->allocated_client_times) {
                ClientTime *ct = &info->client_time_sync[info->time_write_index];

                // Copy echoed sent timestamp
                memcpy(&ct->sent, pkg.package, sizeof(struct timespec));

                // Record server receive time
                clock_gettime(CLOCK_REALTIME, &ct->recieved);

                // Copy appended client float
                float client_time;
                memcpy(&client_time, pkg.package + sizeof(struct timespec), sizeof(float));
                ct->local_time = client_time;

                info->time_write_index++;
            } else {
                g_warning("ClientTime buffer full, cannot store more timestamps.");
            }
        }

        free_tcp_package(&pkg);
    }

    return NULL;
}










//---------------EXPORT MEASUREMENT TO CSV--------------------
static void on_export_csv_clicked(GtkButton *button, gpointer user_data) {
    ClientInfo *client = (ClientInfo *)user_data;

    printf("allocated_samples: %ld, write_index: %ld\n", 
           client->allocated_samples, client->write_index);

    if (!client->measurement_data || client->write_index == 0) {
        g_print("No measurement data available.\n");
        return;
    }

    GtkWidget *dialog = gtk_file_chooser_dialog_new(
        "Save CSV",
        GTK_WINDOW(gtk_widget_get_toplevel(GTK_WIDGET(button))),
        GTK_FILE_CHOOSER_ACTION_SAVE,
        "_Cancel", GTK_RESPONSE_CANCEL,
        "_Save", GTK_RESPONSE_ACCEPT,
        NULL
    );

    gtk_file_chooser_set_do_overwrite_confirmation(GTK_FILE_CHOOSER(dialog), TRUE);
    gtk_file_chooser_set_current_name(GTK_FILE_CHOOSER(dialog), "measurement.csv");

    if (gtk_dialog_run(GTK_DIALOG(dialog)) == GTK_RESPONSE_ACCEPT) {

        char *filename = gtk_file_chooser_get_filename(GTK_FILE_CHOOSER(dialog));
        FILE *fp = fopen(filename, "w");
        if (!fp) {
            g_printerr("Failed to open file %s\n", filename);
            g_free(filename);
            gtk_widget_destroy(dialog);
            return;
        }

        /* ------------------ CREATE HEADER ------------------ */

        // First line: the tab label + UTC timestamp
        const char *label_text = gtk_label_get_text(GTK_LABEL(client->tab_label));

        time_t now = time(NULL);
        struct tm *utc = gmtime(&now);
        char timestamp[64];
        strftime(timestamp, sizeof(timestamp), "%Y-%m-%d %H:%M:%S UTC", utc);

        fprintf(fp, "%s - %s\n", label_text, timestamp);

        /* ------------------ WRITE TIME SYNC ENTRIES ------------------ */
        if (client->client_time_sync && client->time_write_index > 0) {
            for (uint64_t i = 0; i < client->time_write_index; i++) {
                ClientTime *ct = &client->client_time_sync[i];

                char sent_str[80], recv_str[80];
                struct tm sent_tm, recv_tm;

                // Convert to UTC broken-down time
                #if defined(_WIN32)
                    gmtime_s(&sent_tm, &ct->sent.tv_sec);
                    gmtime_s(&recv_tm, &ct->recieved.tv_sec);
                #else
                    gmtime_r(&ct->sent.tv_sec, &sent_tm);
                    gmtime_r(&ct->recieved.tv_sec, &recv_tm);
                #endif

                // Format (without milliseconds)
                strftime(sent_str, sizeof(sent_str), "%Y-%m-%d %H:%M:%S", &sent_tm);
                strftime(recv_str, sizeof(recv_str), "%Y-%m-%d %H:%M:%S", &recv_tm);

                // Milliseconds
                long sent_ms = ct->sent.tv_nsec / 1000000;
                long recv_ms = ct->recieved.tv_nsec / 1000000;

                // Single-line output
                fprintf(fp,
                    "Sent Timesync request at %s.%03ld UTC, received echo at %s.%03ld UTC, local time %.1f\n",
                    sent_str, sent_ms,
                    recv_str, recv_ms,
                    ct->local_time);
            }
        }



        // Second line: CHAN1;CHAN2;...;CHANN;TIME
        for (int i = 0; i < client->float_count - 1; i++) {
            fprintf(fp, "CHAN%d;", i + 1);
        }
        fprintf(fp, "TIME\n");

        

        /* ------------------ WRITE DATA ------------------ */

        for (uint64_t i = 0; i < client->write_index; i++) {
            for (int j = 0; j < client->float_count; j++) {
                fprintf(fp, "%.6f", client->measurement_data[
                    i * client->float_count + j
                ]);
                if (j < client->float_count - 1) fprintf(fp, ";");
            }
            fprintf(fp, "\n");
        }

        fclose(fp);
        g_print("Data exported to %s\n", filename);
        g_free(filename);
    }

    gtk_widget_destroy(dialog);
}











//function to draw a live plot of measurements
static gboolean on_plot_draw(GtkWidget *widget, cairo_t *cr, gpointer user_data)
{
    ClientInfo *info = (ClientInfo *)user_data;
    if (!info || !info->measurement_data) return FALSE;

    uint64_t total = info->write_index;
    if (total == 0) return FALSE;

    uint64_t start = (total > PLOT_HISTORY * info->settings->sample_rate) ? (total - PLOT_HISTORY * info->settings->sample_rate) : 0;
    uint64_t count = total - start;

    GtkAllocation alloc;
    gtk_widget_get_allocation(widget, &alloc);
    double W = alloc.width;
    double H = alloc.height;

    float *buf = info->measurement_data;

    /* === BACKGROUND === */
    cairo_set_source_rgb(cr, 0, 0, 0);
    cairo_paint(cr);

    /* === DRAW AXES === */
    cairo_set_source_rgb(cr, 1, 1, 1);
    cairo_set_line_width(cr, 1.0);

    // X-axis (bottom)
    double x_axis_y = H - 30;   // leave space for labels
    cairo_move_to(cr, 40, x_axis_y);
    cairo_line_to(cr, W - 10, x_axis_y);
    cairo_stroke(cr);

    // Y-axis (left)
    double y_axis_x = 40;
    cairo_move_to(cr, y_axis_x, 10);
    cairo_line_to(cr, y_axis_x, H - 30);
    cairo_stroke(cr);

    cairo_select_font_face(cr, "Sans", CAIRO_FONT_SLANT_NORMAL, CAIRO_FONT_WEIGHT_NORMAL);
    cairo_set_font_size(cr, 12);

    /* === TIME RANGE === */
    double t_start = buf[start * info->float_count + info->float_count-1] / 1e6;
    double t_end   = buf[(total - 1) * info->float_count + info->float_count-1] / 1e6;
    double t_range = t_end - t_start;

    if (t_range <= 0) t_range = 1e-9;

    /* === DRAW X TICKS === */
    int num_xticks = 10;
    for (int i = 0; i <= num_xticks; i++) {
        double t = t_start + (i * t_range / num_xticks);
        double x = y_axis_x + (i * (W - y_axis_x - 10) / num_xticks);

        cairo_move_to(cr, x, x_axis_y);
        cairo_line_to(cr, x, x_axis_y + 5);
        cairo_stroke(cr);

        char label[32];
        snprintf(label, sizeof(label), "%.2f", t);
        draw_text(cr, x, x_axis_y + 10, label);
    }

    /* === DRAW Y TICKS === */
    int num_yticks = 10;
    double y_range = Y_MAX - Y_MIN;
    for (int i = 0; i <= num_yticks; i++) {
        double mv = Y_MIN + (i * y_range / num_yticks);
        double y = x_axis_y - ( (mv - Y_MIN) * (x_axis_y - 10) / y_range );

        cairo_move_to(cr, y_axis_x - 5, y);
        cairo_line_to(cr, y_axis_x, y);
        cairo_stroke(cr);

        char label[32];
        snprintf(label, sizeof(label), "%.0f", mv);
        cairo_move_to(cr, 5, y + 4);
        cairo_show_text(cr, label);
    }

    /* === COLORS FOR CHANNELS === */
    const double colors[8][3] = {
        {1, 0, 0}, {0, 1, 0}, {0, 0, 1}, {1, 1, 0},
        {1, 0, 1}, {0, 1, 1}, {1, 0.5, 0}, {0.5, 1, 0.5}
    };

    /* === DRAW CHANNELS === */
    for (int ch = 0; ch < info->float_count-1; ch++) {
        uint8_t ch_clr = ch%8;
        cairo_set_source_rgb(cr, colors[ch_clr][0], colors[ch_clr][1], colors[ch_clr][2]);
        cairo_set_line_width(cr, 1.2);

        gboolean first = TRUE;

        for (uint64_t i = 0; i < count; i++) {
            uint64_t idx = (start + i) * info->float_count;

            float v_mV = buf[idx + ch];
            double t_sec = buf[idx + info->float_count-1] / 1e6;

            // convert to plot coords
            double x = y_axis_x + ( (t_sec - t_start) / t_range ) * (W - y_axis_x - 10 );
            double y = x_axis_y - ( (v_mV - Y_MIN) / y_range ) * (x_axis_y - 10);

            if (first) {
                cairo_move_to(cr, x, y);
                first = FALSE;
            } else {
                cairo_line_to(cr, x, y);
            }
        }

        cairo_stroke(cr);
    }

    return FALSE;
}






// utility: draw text centered at position
static void draw_text(cairo_t *cr, double x, double y, const char *txt){
    cairo_text_extents_t ext;
    cairo_text_extents(cr, txt, &ext);
    cairo_move_to(cr, x - ext.width/2, y + ext.height);
    cairo_show_text(cr, txt);
}














//handler for button to start measurement on all clients
void on_start_all_clicked(GtkButton *btn, gpointer user_data){
    GtkNotebook *notebook = GTK_NOTEBOOK(user_data);
    int n_pages = gtk_notebook_get_n_pages(notebook);

    for (int i = 1; i < n_pages; i++) {  // skip Main tab
        GtkWidget *tab = gtk_notebook_get_nth_page(notebook, i);
        ClientInfo *info = g_object_get_data(G_OBJECT(tab), "client_info");
        if (!info) continue;

        //g_print("Starting client on tab %d...\n", i);

        // Virtual press of the per-client Start button
        on_send_btn_clicked(NULL, info);
    }
}







//handler for button to stop measurement on all clients
void on_stop_all_clicked(GtkButton *btn, gpointer user_data){
    GtkNotebook *notebook = GTK_NOTEBOOK(user_data);
    int n_pages = gtk_notebook_get_n_pages(notebook);

    for (int i = 1; i < n_pages; i++) {  // skip Main tab
        GtkWidget *tab = gtk_notebook_get_nth_page(notebook, i);
        ClientInfo *info = g_object_get_data(G_OBJECT(tab), "client_info");
        if (!info) continue;

        g_print("Stopping client on tab %d...\n", i);

        on_stop_btn_clicked(NULL, info);
    }
}














//hanlder for global duration change
void on_global_duration_changed(GtkEditable *editable, gpointer user_data){
    GtkNotebook *notebook = GTK_NOTEBOOK(user_data);
    const char *val = gtk_entry_get_text(GTK_ENTRY(editable));
    int duration = atoi(val);

    int pages = gtk_notebook_get_n_pages(notebook);

    for (int i = 0; i < pages; i++) {

        GtkWidget *page = gtk_notebook_get_nth_page(notebook, i);
        if (!page) continue;

        // Retrieve ClientInfo attached to this page
        ClientInfo *info =
            g_object_get_data(G_OBJECT(page), "client_info");

        // Skip MAIN tab (no client_info stored)
        if (!info) continue;

        // Update internal settings
        info->settings->duration_seconds = duration;

        // Update GUI element
        GtkWidget *dur_entry =
            g_object_get_data(G_OBJECT(page), "dur_entry");

        if (dur_entry)
            gtk_entry_set_text(GTK_ENTRY(dur_entry), val);
    }
}



