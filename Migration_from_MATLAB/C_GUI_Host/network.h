#ifndef NETWORK_H
#define NETWORK_H

#include <gio/gio.h>
#include <stdint.h>
#include "client.h"

// --------------------
// TCP Package types
// --------------------
typedef enum {
    PING_PACKAGE      = 0,
    STOP_PACKAGE      = 1,
    SETTINGS_PACKAGE  = 2,
    DATA_PACKAGE      = 3,
    TIMESTAMP_PACKAGE = 4,
    HANDSHAKE_PACKAGE = 5
} PackageType_e;

typedef uint8_t PackageType8_t; // storage type

// --------------------
// TCP Package struct
// --------------------
typedef struct {
    PackageType8_t package_type; // 1 byte storage
    uint32_t package_size;
    unsigned char *package;
} TcpPackage;

// --------------------
// TCP Helper functions
// --------------------
gboolean read_tcp_package(GSocket *sock, TcpPackage *pkg, guint32 timeout_ms);
void free_tcp_package(TcpPackage *pkg);
gboolean get_next_tcp_package(GSocket *sock, TcpPackage *pkg, guint32 timeout_ms);
static gboolean read_bytes(GSocket *sock, guint8 *buffer, gsize n, guint32 timeout_ms);
void send_settings_to_client(ClientInfo *info);
void disconnect_client(ClientInfo *info);
gboolean monitor_client_connection(gpointer user_data);
void set_status_label(GtkWidget *label, gboolean connected);
void set_tab_label_color_text(GtkWidget *label, const char *text, gboolean connected);
#endif // NETWORK_H
