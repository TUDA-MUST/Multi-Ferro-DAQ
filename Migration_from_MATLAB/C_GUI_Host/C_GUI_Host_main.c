//gcc C_GUI_Host_main.c GUI.c -o app `pkg-config --cflags --libs gtk+-3.0 json-glib-1.0`

#include "GUI.h"
#include <gtk/gtk.h>
#include <gio/gio.h>


GSocketService *global_service = NULL;


// Shutdown handler
static void on_close_clicked(GtkButton *button, gpointer user_data)
{
    g_print("Shutting down Client Monitor...\n");

    // Stop socket service
    if (global_service) {
        g_socket_service_stop(global_service);
        g_object_unref(global_service);
        global_service = NULL;
    }

    // Free queue
    if (waiting_tabs) {
        g_queue_free(waiting_tabs);
        waiting_tabs = NULL;
    }

    // Free mutex
    g_mutex_clear(&queue_lock);

    gtk_main_quit();
}

int main(int argc, char **argv)
{
    gtk_init(&argc, &argv);

    // Init queue + mutex
    waiting_tabs = g_queue_new();
    g_mutex_init(&queue_lock);

    // Main window
    GtkWidget *win = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(win), "Client Monitor");
    gtk_window_set_default_size(GTK_WINDOW(win), 900, 600);

    // Notebook container
    GtkWidget *notebook = gtk_notebook_new();
    gtk_container_add(GTK_CONTAINER(win), notebook);

    //
    // MAIN TAB
    //
    GtkWidget *main_box = gtk_box_new(GTK_ORIENTATION_VERTICAL, 10);
    GtkWidget *main_label = gtk_label_new("Main");

    // Add Client button
    GtkWidget *btn_add = gtk_button_new_with_label("Add Client");
    gtk_box_pack_start(GTK_BOX(main_box), btn_add, FALSE, FALSE, 5);
    g_signal_connect(btn_add, "clicked",
                     G_CALLBACK(on_add_client_clicked), notebook);

    // Close Client Monitor button
    GtkWidget *btn_close = gtk_button_new_with_label("Close Client Monitor");
    gtk_box_pack_start(GTK_BOX(main_box), btn_close, FALSE, FALSE, 5);
    g_signal_connect(btn_close, "clicked",
                     G_CALLBACK(on_close_clicked), NULL);

    // Add main tab to notebook
    gtk_notebook_append_page(GTK_NOTEBOOK(notebook), main_box, main_label);

    // Close window event
    g_signal_connect(win, "destroy", G_CALLBACK(on_close_clicked), NULL);

    //
    // SOCKET SERVICE
    //
    global_service = g_socket_service_new();
    GInetAddress *addr = g_inet_address_new_any(G_SOCKET_FAMILY_IPV4);
    GSocketAddress *sockaddr = g_inet_socket_address_new(addr, 8080);

    gboolean ok = g_socket_listener_add_address(
        G_SOCKET_LISTENER(global_service),
        sockaddr,
        G_SOCKET_TYPE_STREAM,
        G_SOCKET_PROTOCOL_TCP,
        NULL, NULL, NULL
    );

    if (!ok) {
        g_printerr("Failed to bind to port 8080\n");
        return 1;
    }

    g_object_unref(addr);
    g_object_unref(sockaddr);

    // Connect incoming clients
    g_signal_connect(global_service, "incoming",
                     G_CALLBACK(on_client_incoming), notebook);

    g_socket_service_start(global_service);

    // Run GUI
    gtk_widget_show_all(win);
    gtk_main();

    return 0;
}

