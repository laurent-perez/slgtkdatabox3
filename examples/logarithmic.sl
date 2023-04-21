#!/usr/bin/env slsh

require ("gtkdatabox3");

variable gdk_red = gdk_rgba_new (1, 0, 0, 1);
variable gdk_green = gdk_rgba_new (0, 1, 0, 1);
variable gdk_blue = gdk_rgba_new (0, 0, 1, 1);
variable gdk_black = gdk_rgba_new (0, 0, 0, 1);

define slsh_main ()
{   
   variable box, databox, graph, win, x, y, vbox, txt, grid, t, l, b, r;

   x = [10:100000];
   y = log10 (x);

   win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_widget_set_size_request (win, 500, 500);
   gtk_window_set_title (win, __argv [0]);
   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 5);
   gtk_container_add (win, vbox);
   txt = gtk_label_new ("y = log10 (x)");
   gtk_box_pack_start (vbox, txt, FALSE, FALSE, 0);
   (databox, grid) = gtk_databox_create_box_with_scrollbars_and_rulers (1, 1, 1, 1);
   gtk_box_pack_start (vbox, grid, TRUE, TRUE, 0);
   graph = gtk_databox_lines_new (x, y, gdk_green, 0);
   gtk_databox_graph_add (databox, graph);
   
   gtk_databox_set_scale_type_x (databox, GTK_DATABOX_SCALE_LOG);
   
   % gtk_databox_auto_rescale (databox, 0);
   gtk_databox_set_total_limits (databox, 10, 100000, 5, 1);
   gtk_databox_set_visible_limits (databox, 100, 10000, 4, 2);
   
   (l, r, t, b) = gtk_databox_get_total_limits (databox);
   message ("Total limits :");
   vmessage ("X min = %f ; X max = %f", l, r);
   vmessage ("Y min = %f ; Y max = %f", b, t);
   (l, r, t, b) = gtk_databox_get_visible_limits (databox);
   message ("Visible limits :");
   vmessage ("X min = %f ; X max = %f", l, r);
   vmessage ("Y min = %f ; Y max = %f", b, t);
   
   () = g_signal_connect (win, "delete_event", &gtk_main_quit);
   
   gtk_widget_show_all (win);
   
   gtk_main ();
}
