#ifndef GUI_H
#define GUI_H

#include <gtk/gtk.h>
#include <gio/gio.h>
#include <json-glib/json-glib.h>
#ifdef _WIN32
    #include <winsock2.h>
    #include <ws2tcpip.h>
#else
    #include <arpa/inet.h>
#endif

#define PLOT_HISTORY 5   // last N seconds displayed in live plot
#define Y_MIN   (-2500.0)   //plotting range
#define Y_MAX   ( 2500.0)


// Forward structs
typedef struct {
    uint32_t sample_rate;
    int duration_seconds;
    uint8_t preamp[8];
    uint16_t settings_reg[8];
    uint64_t sample_number;
} ClientSettings;


// Timesync struct
typedef struct {
    struct timespec sent;
    struct timespec recieved;
    float local_time;
}ClientTime;

typedef struct {
    GSocketConnection *conn;
    GtkWidget *tab_label;
    GtkWidget *tab_content;
    uint8_t float_count;   // store handshake float count
    GtkWidget *notebook;
    GtkWidget *close_button;
    GtkWidget *status_label;
    ClientSettings *settings;
    GPtrArray *preamp_data;
    guint monitor_id;
    char destroying;
    /* ---- Measurement Buffer Fields ---- */
    ClientTime *client_time_sync;   // Buffer of collected client time synchronisation data
    uint64_t allocated_client_times;// numer of allocated ClientTime structs
    uint64_t time_write_index;      // For client_time_sync entries
    float *measurement_data;        // Contiguous buffer: rows of 9 floats
    uint64_t allocated_samples;     // Allocated number of rows
    uint64_t write_index;           // Current row index
    gboolean measurement_active;    // TRUE after Start, FALSE after stop/end
    GThread *measurement_thread;    // New: background thread for measurement
    } ClientInfo;


typedef enum {
    PING_PACKAGE      = 0,
    STOP_PACKAGE      = 1,
    SETTINGS_PACKAGE  = 2,
    DATA_PACKAGE      = 3,
    TIMESTAMP_PACKAGE = 4,
    HANDSHAKE_PACKAGE = 5
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
void build_client_ui(ClientInfo *info, GtkWidget *win);
void assign_client_to_waiting_tab(GSocketConnection *conn, const char* client_name, uint8_t float_count ,GtkWidget *notebook);
void on_add_client_clicked(GtkButton *btn, gpointer user_data);
gboolean on_client_incoming(GSocketService *service, GSocketConnection *conn, GObject *src, gpointer user_data);
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
static void set_tab_label_color_text(GtkWidget *label, const char *text, gboolean connected);
static gboolean read_bytes(GSocket *sock, guint8 *buffer, gsize n, guint32 timeout_ms);
gboolean read_tcp_package(GSocket *sock, TcpPackage *pkg, guint32 timeout_ms);
void free_tcp_package(TcpPackage *pkg);
gboolean get_next_tcp_package(GSocket *sock, TcpPackage *pkg, guint32 timeout_ms);
//static gboolean read_measurement_data(gpointer user_data);
static gpointer measurement_thread_func(gpointer user_data);
static void on_export_csv_clicked(GtkButton *button, gpointer user_data);
static gboolean on_plot_draw(GtkWidget *widget, cairo_t *cr, gpointer user_data);
static void draw_text(cairo_t *cr, double x, double y, const char *txt);
void on_start_all_clicked(GtkButton *btn, gpointer user_data);
void on_stop_all_clicked(GtkButton *btn, gpointer user_data);
void on_global_duration_changed(GtkEditable *editable, gpointer user_data);
#endif // GUI_H
