# slgtkdatabox3

[GtkDatabox](http://sourceforge.net/projects/gtkdatabox/)
bindings for the [S-Lang](https://www.jedsoft.org/slang/) interpreter.

GtkDatabox is a GTK widget for plotting large amounts of data.

This module is aimed to be linked against the GTK3 version of GtkDatabox
library and used together with
[slgtk3](https://github.com/laurent-perez/slgtk3) module.

## Installation

There is no configure script yet.

You need the modified version of [SLIRP](https://github.com/laurent-perez/slirp),
the S-Lang bindings package. Run the included ./gencode script in order
to create the generated code.

You may have to modify the makefile according to your system. After
issuing a make command, copy gtkdatabox-module.so where other S-Lang
modules are installed (/usr/lib/slang/v2/modules) and gtkdatabox.sl to
local packages directory (/usr/share/slsh/local-packages).

## Documentation

As S-Lang language is syntactically very close to C language,
documenting every C function wrapped doesn’t worth the effort. So,
please, refer to GtkDatabox documentation.

Adaptations have been made to reflect the S-Lang specific syntax,
though.

GtkDatabox functions called from the interpreter take advantage of
S-Lang arrays :

    x = [-PI:PI:PI/20];
    y = sin (x);
    [...]
    graph = gtk_databox_lines_new (x, y);

"Full" version of some GtkDatabox functions
(`gtk_databox_lines_new_full`) have not been wrapped. Features provided
by these "full" forms are available through qualifiers :

    graph = gtk_databox_lines_new (x, y, gdk_red, 1 ; ystart = 0, ystride = 3);

Functions that expect one or more pointer(s) for returning value(s) in
their C form return one or more value(s) :

    (left, right, top, bottom) = gtk_databox_get_total_limits (databox);
    
Functions that return a GList return a S-Lang ListType :

    lst = gtk_databox_get_graphs (databox);

There are several demo files in examples directory that may also help
you.

** Caution ** : there is a bug in last GtkDatabox version which make
data no being displayed correctly when running `interleaved.sl`
example. It will be corrected soon.
