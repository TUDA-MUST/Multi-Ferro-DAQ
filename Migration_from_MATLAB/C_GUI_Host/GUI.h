#ifndef GUI_H
#define GUI_H

#include <gtk/gtk.h>
#include <gio/gio.h>
#include <json-glib/json-glib.h>

// Forward structs
typedef struct {
    __uint32_t sample_rate;
    int duration_seconds;
    __uint8_t preamp[8];
    __uint16_t settings_reg[8];
    __uint64_t sample_number;
} ClientSettings;

typedef struct {
    GSocketConnection *conn;
    GtkWidget *tab_label;
    GtkWidget *tab_content;
    GtkWidget *notebook;
    GtkWidget *close_button;
    GtkWidget *status_label;
    ClientSettings *settings;
    GPtrArray *preamp_data;
    guint monitor_id;
    char destroying;
    /* ---- Measurement Buffer Fields ---- */
    float *measurement_data;        // Contiguous buffer: rows of 9 floats
    uint64_t allocated_samples;     // Allocated number of rows
    uint64_t write_index;           // Current row index
    gboolean measurement_active;    // TRUE after Start, FALSE after stop/end
} ClientInfo;


typedef enum {
    PING_PACKAGE      = 0,
    STOP_PACKAGE      = 1,
    SETTINGS_PACKAGE  = 2,
    DATA_PACKAGE      = 3,
    TIMESTAMP_PACKAGE = 4
} PackageType_e;

typedef uint8_t PackageType8_t; // storage type

typedef struct {
    PackageType8_t package_type; // 1 byte storage
    uint32_t package_size;
    unsigned char *package;
} TcpPackage;


// Preamp helper
struct PreampData;

// Globals
extern GQueue *waiting_tabs;
extern GMutex queue_lock;

// Functions
void build_client_ui(ClientInfo *info);
void assign_client_to_waiting_tab(GSocketConnection *conn, unsigned char id, GtkWidget *notebook);
void on_add_client_clicked(GtkButton *btn, gpointer user_data);
gboolean on_client_incoming(GSocketService *service,
                            GSocketConnection *conn,
                            GObject *src,
                            gpointer user_data);
void on_remove_client_clicked(GtkButton *btn, gpointer user_data);
void on_close_waiting_tab_clicked(GtkButton *btn, gpointer user_data);
static void set_preamp_combo(GtkWidget *combo, int value);
static void on_load_json_clicked(GtkButton *btn, ClientInfo *info);
static void send_settings_to_client(ClientInfo *info);
static void on_send_btn_clicked(GtkButton *button, gpointer user_data);
static void on_stop_btn_clicked(GtkButton *button, gpointer user_data);
ClientInfo* create_waiting_tab(GtkWidget *notebook);
static gboolean socket_is_disconnected(GSocket *sock);
static void set_status_label(GtkWidget *label, gboolean connected);
static gboolean monitor_client_connection(gpointer user_data);
static void disconnect_client(ClientInfo *info);
#endif // GUI_H

