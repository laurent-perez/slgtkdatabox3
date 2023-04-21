#!/usr/bin/env slsh

require ("gtkdatabox3");

variable gdk_red = gdk_rgba_new (1, 0, 0, 1);
variable gdk_green = gdk_rgba_new (0, 1, 0, 1);
variable gdk_blue = gdk_rgba_new (0, 0, 1, 1);
variable gdk_black = gdk_rgba_new (0, 0, 0, 1);

define slsh_main ()
{   
   variable graph, win, x, y, hbox, i, ruler, scrollbar;
   % variable databox = GtkWidget_Type [4], grid = GtkWidget_Type [4];
   variable databox, grid;

   x = [1:1e4:10];
   y = log10 (x);
   
   win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_widget_set_size_request (win, 500, 500);
   gtk_window_set_title (win, __argv [0]);

   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 5);
   gtk_container_add (win, hbox);
   graph = gtk_databox_lines_new (x, y, gdk_green, 0);

   (databox, grid) = gtk_databox_create_box_with_scrollbars_and_rulers_positioned (1, 1, 1, 1, 0, 0);
   gtk_box_pack_start (hbox, grid, 1, 1, 0);
   gtk_databox_graph_add (databox, graph);
   gtk_databox_auto_rescale (databox, 0.05);

   (databox, grid) = gtk_databox_create_box_with_scrollbars_and_rulers (1, 1, 1, 1);
   gtk_box_pack_start (hbox, grid, 1, 1, 0);
   gtk_databox_graph_add (databox, graph);
   gtk_databox_auto_rescale (databox, 0.05);
   ruler = gtk_databox_get_ruler_y (databox);
   gtk_databox_ruler_set_text_orientation (ruler, GTK_ORIENTATION_HORIZONTAL);
   gtk_databox_ruler_set_box_shadow (ruler, GTK_SHADOW_ETCHED_OUT);
   gtk_databox_ruler_set_text_alignment (ruler, PANGO_ALIGN_RIGHT);
   gtk_databox_ruler_set_text_hoffset (ruler, -10);
   ruler = gtk_databox_get_ruler_x (databox);
   gtk_databox_ruler_set_manual_ticks (ruler, [0, 2500, 5000, 7500]);
   ($1, $2, $3) = gtk_databox_ruler_get_range (ruler);
   vmessage ("lower = %f ; upper = %f ; position = %f", $1, $2, $3);
   
   (databox, grid) = gtk_databox_create_box_with_scrollbars_and_rulers (1, 1, 1, 1);
   gtk_box_pack_start (hbox, grid, 1, 1, 0);
   gtk_databox_graph_add (databox, graph);
   gtk_databox_auto_rescale (databox, 0.05);
   ruler = gtk_databox_get_ruler_x (databox);
   gtk_databox_ruler_set_draw_subticks (ruler, FALSE);
   gtk_databox_ruler_set_manual_ticks (ruler, [0, 2500, 5000, 7500], ["these are", "manual", "ticks", "labels"]);
   ruler = gtk_databox_get_ruler_x (databox);
   gtk_databox_ruler_set_log_label_format (ruler, "%%-%dg");
   
   (databox, grid) = gtk_databox_create_box_with_scrollbars_and_rulers_positioned (1, 1, 1, 1, 0, 0);
   gtk_box_pack_start (hbox, grid, 1, 1, 0);
   gtk_databox_graph_add (databox, graph);
   gtk_databox_auto_rescale (databox, 0.05);
   
   () = g_signal_connect (win, "delete_event", &gtk_main_quit);
   gtk_widget_show_all (win);
   
   gtk_main ();
}
