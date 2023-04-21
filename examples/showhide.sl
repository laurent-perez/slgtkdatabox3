#!/usr/bin/env slsh

require ("gtkdatabox3");
require ("cairo");

define add_remove (button, databox, graph)
{
   gtk_databox_graph_set_hide (graph, gtk_toggle_button_get_active (button));
   gtk_widget_queue_draw (databox);
}

define draw_color (da, cr, color)
{
   gdk_cairo_set_source_rgba (cr, color);
   cairo_paint (cr);

   return TRUE;
}

define slsh_main ()
{
   variable N = 5, box, databox, g, hbox, vbox, txt, i, win, x, y, color = GdkRGBA [N];
   variable graph = GtkWidget_Type [N], buttons = GtkWidget_Type [N], area = GtkWidget_Type [N];

   x = [-PI:PI:PI/20];
   y = sin (x);

   win = gtk_window_new (GTK_WINDOW_TOPLEVEL);
   gtk_widget_set_size_request (win, 500, 500);
   gtk_window_set_title (win, __argv [0]);
   vbox = gtk_box_new (GTK_ORIENTATION_VERTICAL, 5);
   gtk_container_add (win, vbox);
   databox = gtk_databox_new ();
   gtk_box_pack_start (vbox, databox, TRUE, TRUE, 0);
   txt = gtk_label_new ("Press buttons to hide / show graphs.");
   gtk_box_pack_start (vbox, txt, FALSE, FALSE, 0);
   hbox = gtk_box_new (GTK_ORIENTATION_HORIZONTAL, 5);
   gtk_box_pack_start (vbox, hbox, FALSE, FALSE, 0);
   
   _for i (0, N - 1, 1)
     {   
	color [i].red = 1.0 * ((i + 1) mod 2);
	color [i].green = (1.0 / 2) * ((i + 1) mod 3);
	color [i].blue = (1.0 / 3) * ((i + 1) mod 4);
	color [i].alpha = 1;
	graph [i] = gtk_databox_lines_new (x, (i + 1) * y, color [i], 0);
	gtk_databox_graph_add (databox, graph [i]);
	buttons [i] = gtk_toggle_button_new ();	
	gtk_box_pack_start (hbox, buttons [i], TRUE, TRUE, 0);
	() = g_signal_connect (buttons [i], "toggled", &add_remove, databox, graph [i]);
	area [i] = gtk_drawing_area_new ();
	() = g_signal_connect (area [i], "draw", &draw_color, color [i]);
	gtk_container_add (buttons [i], area [i]);
	gtk_widget_show_all (buttons [i]);
     }
   gtk_databox_auto_rescale (databox, .05);
   
   () = g_signal_connect (win, "delete_event", &gtk_main_quit);
   gtk_widget_show_all (win);
   
   gtk_main ();
}
