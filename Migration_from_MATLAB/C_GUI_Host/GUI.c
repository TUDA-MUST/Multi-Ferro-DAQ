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
void assign_client_to_waiting_tab(GSocketConnection *conn, unsigned char id, GtkWidget *notebook) {
    g_mutex_lock(&queue_lock);
    if (g_queue_is_empty(waiting_tabs)) {
        g_mutex_unlock(&queue_lock);
        g_warning("No waiting tabs available!\n");
        return;
    }

    ClientInfo *info = g_queue_pop_head(waiting_tabs);
    g_mutex_unlock(&queue_lock);

    if (!info) return;

    if (info->close_button) {
        gtk_widget_destroy(info->close_button);
        info->close_button = NULL;
    }

    char text[64];
    snprintf(text, sizeof(text), "Client %u", id);
    gtk_label_set_text(GTK_LABEL(info->tab_label), text);

    info->conn = g_object_ref(conn);

    GtkWidget *remove_btn = gtk_button_new_with_label("Remove Client");
    gtk_box_pack_start(GTK_BOX(info->tab_content), remove_btn, FALSE, FALSE, 4);
    g_signal_connect(remove_btn, "clicked", G_CALLBACK(on_remove_client_clicked), info);

    if (!info->preamp_data)
        info->preamp_data = g_ptr_array_new_with_free_func(g_free);

    build_client_ui(info);
    gtk_widget_show_all(info->tab_content);
}

// ----------------- SOCKET CALLBACK -------------------
gboolean on_client_incoming(GSocketService *service,
                            GSocketConnection *conn,
                            GObject *src,
                            gpointer user_data)
{
    GtkWidget *notebook = GTK_WIDGET(user_data);
    unsigned char id = 0;
    GInputStream *in = g_io_stream_get_input_stream(G_IO_STREAM(conn));
    gssize n = g_input_stream_read(in, &id, 1, NULL, NULL);
    if (n <= 0) return FALSE;
    assign_client_to_waiting_tab(conn, id, notebook);
    return TRUE;
}

// ----------------- BUILD CLIENT UI -------------------
void build_client_ui(ClientInfo *info)
{
    if (!info) return;

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

  // middle panel (empty)
  GtkWidget *middle_box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
  gtk_box_pack_start(GTK_BOX(hbox), middle_box, TRUE, TRUE, 0);
  
  // Load a JPG into a GtkImage
  GtkWidget *image = gtk_image_new_from_file("./hqdefault-2535131512.jpg");
  gtk_box_pack_start(GTK_BOX(middle_box), image, FALSE, FALSE, 0);
  gtk_widget_show(image);

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
  GtkWidget *dur_label = gtk_label_new("Duration (seconds)");
  GtkWidget *dur_entry = gtk_entry_new();
  gtk_entry_set_text(GTK_ENTRY(dur_entry), "300");
  g_signal_connect(dur_entry, "changed",
                   G_CALLBACK(dur_entry_changed), info->settings);
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
      // Optional: track widgets in preamp_data array if needed
      g_ptr_array_add(info->preamp_data, pre_combo);
      g_ptr_array_add(info->preamp_data, reg_entry);
  }
  GtkWidget *load_btn = gtk_button_new_with_label("Load JSON Settings...");
  gtk_box_pack_start(GTK_BOX(right_box), load_btn, FALSE, FALSE, 5);
  g_signal_connect(load_btn, "clicked", G_CALLBACK(on_load_json_clicked), info);
  
}

// ----------------- ADD CLIENT BUTTON -------------------
void on_add_client_clicked(GtkButton *btn, gpointer user_data) {
    GtkWidget *notebook = GTK_WIDGET(user_data);
    GtkWidget *label = gtk_label_new("Waiting...");
    GtkWidget *box = gtk_box_new(GTK_ORIENTATION_VERTICAL,10);
    gtk_notebook_append_page(GTK_NOTEBOOK(notebook),box,label);

    ClientInfo *info = g_new0(ClientInfo,1);
    info->tab_label = label;
    info->tab_content = box;
    info->notebook = notebook;

    GtkWidget *btn_close = gtk_button_new_with_label("Close Tab");
    gtk_box_pack_start(GTK_BOX(box),btn_close,FALSE,FALSE,4);
    info->close_button = btn_close;
    g_signal_connect(btn_close,"clicked",G_CALLBACK(on_close_waiting_tab_clicked),info);

    g_mutex_lock(&queue_lock);
    g_queue_push_tail(waiting_tabs,info);
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
        snprintf(hexbuf, sizeof(hexbuf), "%02X", info->settings->settings_reg[i]);
        gtk_entry_set_text(GTK_ENTRY(reg_entry), hexbuf);
    }

    g_object_unref(parser);
}
