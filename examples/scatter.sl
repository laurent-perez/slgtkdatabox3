#!/usr/bin/env slsh

require ("gtkdatabox3");
require ("rand");

variable gdk_red = gdk_rgba_new (1, 0, 0, 1);
variable gdk_green = gdk_rgba_new (0, 1, 0, 1);
variable gdk_blue = gdk_rgba_new (0, 0, 1, 1);
variable gdk_black = gdk_rgba_new (0, 0, 0, 1);

define slsh_main () 
{
   variable databox, graph, win, x, y, grid;

   x = rand_gauss (1, 1000);
   y = rand_gauss (1, 1000);

   win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_widget_set_size_request (win, 500, 500);
   gtk_window_set_title (win, __argv [0]);
   (databox, grid) = gtk_databox_create_box_with_scrollbars_and_rulers (1, 1, 1, 1);
   graph = gtk_databox_grid_new (10, 10);
   gtk_databox_graph_add (databox, graph);
   graph = gtk_databox_points_new (x, y, gdk_green, 5);
   gtk_databox_graph_add (databox, graph);
   gtk_databox_auto_rescale (databox, .05);
   gtk_container_add (win, grid);
   () = g_signal_connect (win, "delete_event", &gtk_main_quit);
   gtk_widget_show_all (win);
   
   gtk_main ();
}
