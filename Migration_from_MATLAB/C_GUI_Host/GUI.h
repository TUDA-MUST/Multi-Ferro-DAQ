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
    __uint8_t settings_reg[8];
} ClientSettings;

typedef struct {
    GSocketConnection *conn;
    GtkWidget *tab_label;
    GtkWidget *tab_content;
    GtkWidget *notebook;
    GtkWidget *close_button;
    ClientSettings *settings;
    GPtrArray *preamp_data;
} ClientInfo;

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
#endif // GUI_H

