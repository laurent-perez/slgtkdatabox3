#!/usr/bin/env slsh

require ("gtkdatabox3");

variable gdk_red = gdk_rgba_new (1, 0, 0, 1);
variable gdk_green = gdk_rgba_new (0, 1, 0, 1);
variable gdk_blue = gdk_rgba_new (0, 0, 1, 1);
variable gdk_black = gdk_rgba_new (0, 0, 0, 1);
variable gdk_grey = gdk_rgba_new (.5, .5, .5, 1);

variable N = 200, VIS = 50;
variable x = Float_Type [N], y = Float_Type [N];

define add_point (databox, i)
{
   x [@i] = @i;
   y [@i] = typecast (g_random_double_range (-10, 10), Float_Type);

   @i ++;

   if (@i > VIS)
     {
	gtk_databox_set_visible_limits (databox, @i - VIS, @i, 10, -10);
     }
   gtk_widget_queue_draw (databox);
   
   if (@i > (N - 1))
     return FALSE;
   
   return TRUE;
}

define slsh_main ()
{
   variable databox, graph, grid, win, i = 0;

   x = [0:N];
   y [*] = 0;
   
   win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_widget_set_size_request (win, 500, 700);
   gtk_window_set_title (win, __argv [0]);
   (databox, grid) = gtk_databox_create_box_with_scrollbars_and_rulers (1, 1, 1, 1);
   graph = gtk_databox_grid_new (10, VIS, gdk_grey, 0);
   gtk_databox_graph_add (databox, graph);
   graph = gtk_databox_lines_new (x, y, gdk_green, 2);
   gtk_databox_graph_add (databox, graph);
   gtk_databox_set_total_limits (databox, 0, N, 10, -10);
   gtk_databox_set_visible_limits (databox, 0, VIS, 10, -10);
   gtk_container_add (win, grid);
   () = g_signal_connect (win, "delete_event", &gtk_main_quit);
   () = g_timeout_add (50, &add_point, databox, &i);
   gtk_widget_show_all (win);
   gtk_main ();
}
