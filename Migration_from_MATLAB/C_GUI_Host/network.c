#include "network.h"
#include <string.h>
#include <stdlib.h>




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










/*
static gboolean socket_is_disconnected(GSocket *sock){

}
*/











//-----------------SEND SETTINGS TO CONNECTED CLIENT AND START MEASUREMENT --------------------

void send_settings_to_client(ClientInfo *info) {
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















//----------DISCONNECT TCP CLIENT ----------------------------
void disconnect_client(ClientInfo *info) {
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















//-----------------HELPER FOR CONNECTION STATUS-------------------
// Returns G_SOURCE_REMOVE if disconnected, G_SOURCE_CONTINUE otherwise
gboolean monitor_client_connection(gpointer user_data) {
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














//--------------HELPER TO SET CONNECTION LABEL-------------------
void set_status_label(GtkWidget *label, gboolean connected){
    if (!label) return;

    if (connected)
        gtk_label_set_markup(GTK_LABEL(label),
            "<span foreground=\"green\" weight=\"bold\">CONNECTED</span>");
    else
        gtk_label_set_markup(GTK_LABEL(label),
            "<span foreground=\"red\" weight=\"bold\">DISCONNECTED</span>");
}













//----------------HELPER TO COLOR IN TAB LABELS------------------------
void set_tab_label_color_text(GtkWidget *label, const char *text, gboolean connected){
    if (!label || !text) return;

    char buf[128];
    snprintf(buf, sizeof(buf),
             "<span foreground=\"%s\" weight=\"bold\">%s</span>",
             connected ? "green" : "red",
             text);

    gtk_label_set_markup(GTK_LABEL(label), buf);
}






