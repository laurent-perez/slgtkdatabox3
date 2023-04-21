#!/usr/bin/env slsh

% Sometimes, data can be interleaved : for example, data from a DAQ system
% which are available as an array where values are packed one channel
% after another [chan1, chan2, chan3, ... , chan1, chan2, chan3]
% (x/y)start and (x/y)stride qualifiers allow to deal with such a pattern.

require ("gtkdatabox3");

variable gdk_red = gdk_rgba_new (1, 0, 0, 1);
variable gdk_green = gdk_rgba_new (0, 1, 0, 1);
variable gdk_blue = gdk_rgba_new (0, 0, 1, 1);
variable gdk_black = gdk_rgba_new (0, 0, 0, 1);

define slsh_main ()
{   
   variable box, databox, graph, win, x, y, vbox, txt, N, i, j;
      
   N = 100;
   x = [-PI:PI:#N];
   x = typecast (x, Double_Type);
   y = Double_Type [N * 3];

   j = 0;
   for (i = 0 ; i < N ; i ++)
     {
	y [j] = sin (x [i]);
	y [j + 1] = cos (x [i]);
	y [j + 2] = sin (x [i]) * cos (x [i]);
	j += 3;
     }
   
   win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_widget_set_size_request (win, 500, 500);
   gtk_window_set_title (win, __argv [0]);
   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 5);
   gtk_container_add (win, vbox);
   txt = gtk_label_new ("One array with interleaved data");
   gtk_box_pack_start (vbox, txt, FALSE, FALSE, 0);
   databox = gtk_databox_new ();
   graph = gtk_databox_lines_new (x, y, gdk_red, 1 ; ystart = 0, ystride = 3);
   gtk_databox_graph_add (databox, graph);
   graph = gtk_databox_lines_new (x, y, gdk_green, 1 ; ystart = 1, ystride = 3);
   gtk_databox_graph_add (databox, graph);
   graph = gtk_databox_lines_new (x, y, gdk_blue, 1 ; ystart = 2, ystride = 3);
   gtk_databox_graph_add (databox, graph);
   graph = gtk_databox_grid_new (5, 5, gdk_black, 0);
   gtk_databox_graph_add (databox, graph);
   gtk_databox_auto_rescale (databox, .05);
   gtk_box_pack_start (vbox, databox, TRUE, TRUE, 0);
   () = g_signal_connect (win, "delete_event", &gtk_main_quit);
   gtk_widget_show_all (win);
      
   gtk_main ();
}
