#!/usr/bin/env slsh

require ("gtkdatabox3");

variable gdk_red = gdk_rgba_new (1, 0, 0, 1);
variable gdk_green = gdk_rgba_new (0, 1, 0, 1);
variable gdk_blue = gdk_rgba_new (0, 0, 1, 1);
variable gdk_yellow = gdk_rgba_new (0, 1, 1, 1);
variable gdk_black = gdk_rgba_new (0, 0, 0, 1);

variable x, y, px = Float_Type [1], py = Float_Type [1];
variable pixel_x, pixel_y, value_x, value_y, index = 0, markers1, markers2;

define mouse (obj, event, databox)
{
   variable x_win, y_win;
   
   gtk_widget_show (databox);
   (x_win, y_win) = gdk_event_get_coords (event);
   gtk_label_set_text (pixel_x, string (int (x_win)));
   gtk_label_set_text (pixel_y, string (int (y_win)));
   gtk_label_set_text (value_x, string (gtk_databox_pixel_to_value_x (databox, int (x_win))));
   gtk_label_set_text (value_y, string (gtk_databox_pixel_to_value_y (databox, int (y_win))));
   return TRUE;
}

define keyboard (obj, event, databox)
{
   switch (gdk_event_get_keyval (event))
     { case GDK_Right : index += 1;
	if (index > length (x) - 1)
	  index = length (x) - 1; }
     { case GDK_Left : index -= 1;
	if (index < 0)
	  index = 0; }
     { return TRUE; }	
   gtk_databox_markers_set_label (markers1, 0, GTK_DATABOX_MARKERS_TEXT_N,
				  sprintf ("%.3f ; %.3f", x [index], y [index]), TRUE);
   gtk_databox_markers_set_label (markers2, 0, GTK_DATABOX_MARKERS_TEXT_S,
				  sprintf ("%d ; %d",
					   gtk_databox_value_to_pixel_x (databox, x [index]),
					   gtk_databox_value_to_pixel_y (databox, y [index])),
				  TRUE);   
   px [0] = x [index];
   py [0] = y [index];
   gtk_widget_queue_draw (databox);
   return TRUE;
}

define slsh_main ()
{
   variable databox, graph, win, hbox1, hbox2, vbox, label1, label2, txt;
   
   x = [-PI:PI:PI/100];
   y = sin (x);
   px [0] = x [index];
   py [0] = y [index];
   
   win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_widget_set_size_request (win, 500, 500);
   gtk_window_set_title (win, __argv [0]);
   databox = gtk_databox_new ();
   graph = gtk_databox_grid_new (9, 9, gdk_black, 0);
   gtk_databox_graph_add (databox, graph);
   graph = gtk_databox_lines_new (x, y, gdk_green, 0);
   gtk_databox_graph_add (databox, graph);
   graph = gtk_databox_points_new (px, py, gdk_yellow, 5);
   gtk_databox_graph_add (databox, graph);
   markers1 = gtk_databox_markers_new (px, py, gdk_blue, 10, GTK_DATABOX_MARKERS_TRIANGLE);
   gtk_databox_markers_set_position (markers1, 0, GTK_DATABOX_MARKERS_N);
   gtk_databox_graph_add (databox, markers1);
   markers2 = gtk_databox_markers_new (px, py, gdk_red, 10, GTK_DATABOX_MARKERS_TRIANGLE);
   gtk_databox_markers_set_position (markers2, 0, GTK_DATABOX_MARKERS_S);
   gtk_databox_graph_add (databox, markers2);
   gtk_databox_auto_rescale (databox, .1);
   
   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 5);
   gtk_container_add (win, vbox);
   txt = gtk_label_new ("Move mouse or press left / right keys.");
   gtk_box_pack_start (vbox, txt, FALSE, FALSE, 0);
   gtk_box_pack_start (vbox, databox, TRUE, TRUE, 0);
   hbox1 = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 5);
   gtk_box_pack_start (vbox, hbox1, FALSE, FALSE, 0);
   label1 = gtk_label_new ("Coords (x, y)");
   gtk_box_pack_start (hbox1, label1, TRUE, FALSE, 0);
   label2 = gtk_label_new ("Values (x, y)");
   gtk_box_pack_start (hbox1, label2, TRUE, FALSE, 0);
   hbox2 = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 5);
   gtk_box_pack_start (vbox, hbox2, FALSE, FALSE, 0);
   pixel_x = gtk_label_new ("");
   gtk_box_pack_start (hbox2, pixel_x, TRUE, FALSE, 0);
   pixel_y = gtk_label_new ("");
   gtk_box_pack_start (hbox2, pixel_y, TRUE, FALSE, 0);
   value_x = gtk_label_new ("");
   gtk_box_pack_start (hbox2, value_x, TRUE, FALSE, 0);
   value_y = gtk_label_new ("");
   gtk_box_pack_start (hbox2, value_y, TRUE, FALSE, 0);
   
   () = g_signal_connect (win, "delete_event", &gtk_main_quit);
   () = g_signal_connect (win, "motion_notify_event", &mouse, databox);
   () = g_signal_connect (win, "key_press_event", &keyboard, databox);
   gtk_widget_show_all (win);
   
   gtk_main ();
}
