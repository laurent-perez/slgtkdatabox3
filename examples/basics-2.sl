#!/usr/bin/env slsh

require ("gtkdatabox3");

variable gdk_red = gdk_rgba_new (1, 0, 0, 1);
variable gdk_green = gdk_rgba_new (0, 1, 0, 1);
variable gdk_blue = gdk_rgba_new (0, 0, 1, 1);
variable gdk_black = gdk_rgba_new (0, 0, 0, 1);

define slsh_main ()
{
   variable box, databox, graph, win, x, y1, y2, vbox, txt;

   x = [-2*PI:2*PI:PI/20];
   y1 = sin (x) + 5;
   y2 = cos (x) - 5;

   win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_widget_set_size_request (win, 500, 500);
   gtk_window_set_title (win, __argv [0]);
   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 5);
   gtk_container_add (win, vbox);
   txt = gtk_label_new ("Region and offset bars plots");
   gtk_box_pack_start (vbox, txt, FALSE, FALSE, 0);
   databox = gtk_databox_new ();
   graph = gtk_databox_regions_new (x, y1, y2, gdk_green);
   gtk_databox_graph_add (databox, graph);
   graph = gtk_databox_offset_bars_new (x, y1, y2, gdk_blue, 1);
   gtk_databox_graph_add_front (databox, graph);
   graph = gtk_databox_cross_simple_new (gdk_black, 0);
   gtk_databox_graph_add_front (databox, graph);
   gtk_databox_auto_rescale (databox, .05);
   gtk_box_pack_start (vbox, databox, TRUE, TRUE, 0);
   () = g_signal_connect (win, "delete_event", &gtk_main_quit);
   gtk_widget_show_all (win);
   
   gtk_main ();
}

