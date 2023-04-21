#!/usr/bin/env slsh

require ("gtkdatabox3");

variable gdk_red = gdk_rgba_new (1, 0, 0, 1);
variable gdk_green = gdk_rgba_new (0, 1, 0, 1);
variable gdk_blue = gdk_rgba_new (0, 0, 1, 1);
variable gdk_black = gdk_rgba_new (0, 0, 0, 1);
variable gdk_grey = gdk_rgba_new (.5, .5, .5, 1);

variable N = 1000;
variable x = Float_Type [N], y = Float_Type [N];

define lissajous (databox, lissajous_frequency, lissajous_counter)
{
   variable freq, k, off, n;

   n = length (x);
   @lissajous_frequency += 0.001;
   off = @lissajous_counter * 4 * PI / n;
   freq = 14 + 10 * sin (@lissajous_frequency);   
   _for k (0, n - 1, 1)
     {	
   	x [k] = sin (k * 4 * PI / n + off);
   	y [k] = cos (k * freq * PI / n + off);
     }   
   gtk_widget_queue_draw (databox);
   @lissajous_counter ++;
   return TRUE;
}

define slsh_main ()
{
   variable databox, graph, win;
   variable lissajous_counter = 0, lissajous_frequency = 3 * PI / 2;

   win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_widget_set_size_request (win, 500, 500);
   gtk_window_set_title (win, __argv [0]);
   databox = gtk_databox_new ();
   graph = gtk_databox_grid_new (10, 10, gdk_grey, 0);
   gtk_databox_graph_add (databox, graph);
   graph = gtk_databox_lines_new (x, y, gdk_green, 2);
   gtk_databox_graph_add (databox, graph);
   gtk_databox_set_total_limits (databox, -1.1, 1.1, 1.1, -1.1);
   gtk_container_add (win, databox);
   () = g_signal_connect (win, "delete_event", &gtk_main_quit);
   () = g_idle_add (&lissajous, databox, &lissajous_frequency, &lissajous_counter);
   gtk_widget_show_all (win);
   gtk_main ();
}
