#!/usr/bin/env slsh

require ("gtkdatabox3");

variable gdk_red = gdk_rgba_new (1, 0, 0, 1);
variable gdk_green = gdk_rgba_new (0, 1, 0, 1);
variable gdk_blue = gdk_rgba_new (0, 0, 1, 1);
variable gdk_yellow = gdk_rgba_new (0, 1, 1, 1);
variable gdk_black = gdk_rgba_new (0, 0, 0, 1);

define slsh_main ()
{   
   variable databox, graph, i, win, x, y;

   x = sin ([0:2*PI:#9]);
   y = cos ([0:2*PI:#9]);

   win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_widget_set_size_request (win, 500, 500);
   gtk_window_set_title (win, __argv [0]);
   databox = gtk_databox_new ();
   graph = gtk_databox_points_new (x, y, gdk_red, 3);
   gtk_databox_graph_add (databox, graph);
   graph = gtk_databox_markers_new (x, y, gdk_blue, 10, GTK_DATABOX_MARKERS_NONE);
   gtk_databox_graph_add (databox, graph);
   gtk_databox_markers_set_label (graph, 0, GTK_DATABOX_MARKERS_TEXT_N, "N", TRUE);
   gtk_databox_markers_set_label (graph, 1, GTK_DATABOX_MARKERS_TEXT_NE, "NE", FALSE);
   gtk_databox_markers_set_label (graph, 2, GTK_DATABOX_MARKERS_TEXT_E, "E", TRUE);
   gtk_databox_markers_set_label (graph, 3, GTK_DATABOX_MARKERS_TEXT_SE, "SE", FALSE);
   gtk_databox_markers_set_label (graph, 4, GTK_DATABOX_MARKERS_TEXT_S, "S", TRUE);
   gtk_databox_markers_set_label (graph, 5, GTK_DATABOX_MARKERS_TEXT_SW, "SW", FALSE);
   gtk_databox_markers_set_label (graph, 6, GTK_DATABOX_MARKERS_TEXT_W, "W", TRUE);
   gtk_databox_markers_set_label (graph, 7, GTK_DATABOX_MARKERS_TEXT_NW, "NW", FALSE);

   graph = gtk_databox_markers_new ([0], [0], gdk_yellow, 1, GTK_DATABOX_MARKERS_DASHED_LINE);
   gtk_databox_markers_set_position (graph, 0, GTK_DATABOX_MARKERS_W);
   gtk_databox_graph_add (databox, graph);
   
   graph = gtk_databox_markers_new ([0, 0], [-.5, .5], gdk_yellow, 20, GTK_DATABOX_MARKERS_TRIANGLE);
   gtk_databox_markers_set_position (graph, 0, GTK_DATABOX_MARKERS_N);
   gtk_databox_markers_set_position (graph, 1, GTK_DATABOX_MARKERS_S);
   gtk_databox_graph_add (databox, graph);

   graph = gtk_databox_markers_new ([-1.5, 1.5], [0, 0], gdk_green, 5, GTK_DATABOX_MARKERS_SOLID_LINE);
   gtk_databox_markers_set_position (graph, 0, GTK_DATABOX_MARKERS_N);
   gtk_databox_markers_set_position (graph, 1, GTK_DATABOX_MARKERS_N);
   gtk_databox_graph_add (databox, graph);

   gtk_databox_auto_rescale (databox, .3);
   gtk_container_add (win, databox);
   () = g_signal_connect (win, "delete_event", &gtk_main_quit);
   gtk_widget_show_all (win);
   
   gtk_main ();
}
