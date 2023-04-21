#!/usr/bin/env slsh

require ("gtkdatabox3");

variable gdk_red = gdk_rgba_new (1, 0, 0, 1);
variable gdk_green = gdk_rgba_new (0, 1, 0, 1);
variable gdk_blue = gdk_rgba_new (0, 0, 1, 1);
variable gdk_black = gdk_rgba_new (0, 0, 0, 1);

define slsh_main ()
{   
   variable databox, graph, win, x, y, grid, ruler, hticks, labels;

   x = [-PI:PI:PI/100];
   y = sin (x);
   hticks = [-PI:PI:#9];
   labels = ["-PI", "-3PI/4", "PI/2", "PI/4", "0", "PI/4", "PI/2", "3PI/4", "PI"];
   
   win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_widget_set_size_request (win, 500, 500);
   gtk_window_set_title (win, __argv [0]);
   (databox, grid) = gtk_databox_create_box_with_scrollbars_and_rulers (1, 1, 1, 1);
   graph = gtk_databox_grid_array_new ([-1:1:#5], hticks);
   gtk_databox_graph_add (databox, graph);
   graph = gtk_databox_lines_new (x, y, gdk_green, 1);
   gtk_databox_graph_add (databox, graph);
   ruler = gtk_databox_get_ruler_x (databox);
   gtk_databox_ruler_set_draw_subticks (ruler, FALSE);
   gtk_databox_ruler_set_manual_ticks (ruler, hticks, labels);
   gtk_databox_auto_rescale (databox, .05);
   gtk_container_add (win, grid);
   () = g_signal_connect (win, "delete_event", &gtk_main_quit, NULL);
   gtk_widget_show_all (win);
   
   gtk_main ();
}
