#ifndef CLIENT_H
#define CLIENT_H

#include <gtk/gtk.h>
#include <gio/gio.h>
#include <stdint.h>


// --------------------
// Client settings
// --------------------
typedef struct {
    uint32_t sample_rate;
    int duration_seconds;
    uint8_t preamp[8];
    uint16_t settings_reg[8];
    uint64_t sample_number;
} ClientSettings;

// --------------------
// Time synchronization
// --------------------
typedef struct {
    struct timespec sent;
    struct timespec received;
    float local_time;
} ClientTime;

// --------------------
// Main client info
// --------------------
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
    GThread *measurement_thread;    // background thread for measurement
} ClientInfo;

// --------------------
// Client tab management
// --------------------
ClientInfo* create_waiting_tab(GtkWidget *notebook);        //creates waiting tab and allocates space for client
void free_client_info(ClientInfo *info);                    //cleanly frees ClientInfo

#endif // CLIENT_H

