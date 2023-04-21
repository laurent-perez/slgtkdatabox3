#include <gtk/gtk.h>
#include <gtkdatabox.h>
#include <gtkdatabox_bars.h>
#include <gtkdatabox_cross_simple.h>
#include <gtkdatabox_grid.h>
#include <gtkdatabox_lines.h>
#include <gtkdatabox_markers.h>
#include <gtkdatabox_offset_bars.h>
#include <gtkdatabox_points.h>
#include <gtkdatabox_regions.h>
#include <slang.h>

SLang_CStruct_Field_Type GdkRGBA_Layout [] =
{
   MAKE_CSTRUCT_FIELD(GdkRGBA, red, "red", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkRGBA, green, "green", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkRGBA, blue, "blue", SLANG_DOUBLE_TYPE, 0),
   MAKE_CSTRUCT_FIELD(GdkRGBA, alpha, "alpha", SLANG_DOUBLE_TYPE, 0),
   SLANG_END_CSTRUCT_TABLE
};

int usage_err (int expected_nargs, const char *usage_str)
{
   if (SLang_Num_Function_Args < expected_nargs) 
     {
	int npop = SLstack_depth ();
	if (npop > SLang_Num_Function_Args) npop = SLang_Num_Function_Args;
	SLdo_pop_n (npop);
	SLang_verror (SL_USAGE_ERROR, "Usage : %s", usage_str);
	return -1;
     }
   return 0;
}

#include "gtkdatabox3_glue.c"

static int get_gtype (SLtype data_type, GType *type)
{   
   switch (data_type)
     {
      case SLANG_CHAR_TYPE:
	*type = G_TYPE_CHAR;
	break;
      case SLANG_UCHAR_TYPE:
	*type = G_TYPE_UCHAR;
	break;
	/* not handled by gtkdatabox */
	/* case SLANG_SHORT_TYPE */
      case SLANG_INT_TYPE:
	*type = G_TYPE_INT;
	break;
      case SLANG_UINT_TYPE:
	*type = G_TYPE_UINT;
	break;
      case SLANG_FLOAT_TYPE:
	*type = G_TYPE_FLOAT;
	break;
      case SLANG_DOUBLE_TYPE:
	*type = G_TYPE_DOUBLE;
	break;
      default:
	g_message ("unsupported data type");	
	return -1;
     }
   return 0;
}

static void sl_gtk_databox_bars_new (void)
{
   GtkDataboxGraph *retval;
   GdkRGBA color = {0, 0, 0, 1};
   
   GType xtype, ytype;
   SLang_Array_Type *x, *y;   
   guint default_length, len, maxlen, xstart, xstride, ystart, ystride, size = 0;

   if (usage_err (2, "GtkDataboxGraph = gtk_databox_bars_new (Array, Array [, Struct, UInt] ; qualifiers)"))
     return;

   if (SLang_Num_Function_Args > 3)
     {	
	if (-1 == SLang_pop_uint ((unsigned int*) &size))
	  return;
     }
   if (SLang_Num_Function_Args > 2)
     {	
	if (-1 == SLang_pop_cstruct ((VOID_STAR) &color, GdkRGBA_Layout))
	  return;
     }   
   if (-1 == SLang_pop_array (&y))
     return;
   if (-1 == SLang_pop_array (&x))
     goto free_y;

   if (-1 == get_gtype (x->data_type, &xtype))
     goto cleanup;
   if (-1 == get_gtype (y->data_type, &ytype))
     goto cleanup;
   default_length = (x->dims [0] < y->dims [0]) ? x->dims [0] : y->dims [0];
   
   if (-1 == SLang_get_int_qualifier ("len", &len, default_length))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("maxlen", &maxlen, default_length))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("xstart", &xstart, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("xstride", &xstride, 1))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("ystart", &ystart, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("ystride", &ystride, 1))
     goto cleanup;

   retval = gtk_databox_bars_new_full (maxlen, len, 
				       (void *) x->data, xstart, xstride, xtype,
				       (void *) y->data, ystart, ystride, ytype,
				       &color, size);
   
   (void) SLang_push_opaque (GtkOpaque_Type, (void*) retval, 0);

   return;
   
cleanup:
   SLang_free_array (x);
free_y:
   SLang_free_array (y);      
}

static void sl_gtk_databox_grid_new (void)
{
   GtkDataboxGraph *retval;
   GdkRGBA color = {0, 0, 0, 1};   
   gint hlines, vlines;
   guint size;
   
   if (usage_err (2, "GtkDataboxGraph = gtk_databox_grid_new (Int, Int [, Struct, UInt])"))
     return;

   if (SLang_Num_Function_Args > 3)
     {	
	if (-1 == SLang_pop_uint ((unsigned int*) &size))
	  return;
     }
   if (SLang_Num_Function_Args > 2)
     {	
	if (-1 == SLang_pop_cstruct ((VOID_STAR) &color, GdkRGBA_Layout))
	  return;
     }   
   if (-1 == SLang_pop_int ((int*) &vlines))
     return;
   if (-1 == SLang_pop_int ((int*) &hlines))
     return;

   retval = gtk_databox_grid_new (hlines, vlines, &color, size);
   
   (void) SLang_push_opaque (GtkOpaque_Type, (void*) retval, 0);
}

static void sl_gtk_databox_grid_array_new (void)
{
   GtkDataboxGraph *retval;
   GdkRGBA color = {0, 0, 0, 1};   
   SLang_Array_Type *x, *y;   
   guint size = 0;

   if (usage_err (2, "GtkDataboxGraph = gtk_databox_grid_array_new (Array, Array [, Struct, UInt])"))
     return;

   if (SLang_Num_Function_Args > 3)
     {	
	if (-1 == SLang_pop_uint ((unsigned int*) &size))
	  return;
     }
   if (SLang_Num_Function_Args > 2)
     {	
	if (-1 == SLang_pop_cstruct ((VOID_STAR) &color, GdkRGBA_Layout))
	  return;
     }   
   if (-1 == SLang_pop_array_of_type (&y, SLANG_FLOAT_TYPE))
     return;
   if (-1 == SLang_pop_array_of_type (&x, SLANG_FLOAT_TYPE))
     goto free_y;

   retval = gtk_databox_grid_array_new (x->dims [0], y->dims [0],
					(void *) x->data, (void *) y->data,
					&color, size);
   
   (void) SLang_push_opaque (GtkOpaque_Type, (void*) retval, 0);

   return;
   
free_y:
   SLang_free_array (y);      
}

static void sl_gtk_databox_lines_new (void)
{
   GtkDataboxGraph *retval;
   GdkRGBA color = {0, 1, 0, 1};
   
   GType xtype, ytype;
   SLang_Array_Type *x, *y;   
   guint default_length, len, maxlen, xstart, xstride, ystart, ystride, size = 0;

   if (usage_err (2, "GtkDataboxGraph = gtk_databox_lines_new (Array, Array [Struct, UInt] ; qualifiers)"))
     return;

   if (SLang_Num_Function_Args > 3)
     {	
   	if (-1 == SLang_pop_uint ((unsigned int*) &size))
   	  return;
     }
   if (SLang_Num_Function_Args > 2)
     {	
   	if (-1 == SLang_pop_cstruct ((VOID_STAR) &color, GdkRGBA_Layout))
   	  return;
     }   
   if (-1 == SLang_pop_array (&y))
     return;
   if (-1 == SLang_pop_array (&x))
     goto free_y;

   if (-1 == get_gtype (x->data_type, &xtype))
     goto cleanup;
   if (-1 == get_gtype (y->data_type, &ytype))
     goto cleanup;
   default_length = (x->dims [0] < y->dims [0]) ? x->dims [0] : y->dims [0];
   
   if (-1 == SLang_get_int_qualifier ("len", &len, default_length))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("maxlen", &maxlen, default_length))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("xstart", &xstart, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("xstride", &xstride, 1))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("ystart", &ystart, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("ystride", &ystride, 1))
     goto cleanup;
   
   retval = gtk_databox_lines_new_full (maxlen, len, 
					(void *) x->data, xstart, xstride, xtype,
					(void *) y->data, ystart, ystride, ytype,
					&color, size);
   
   (void) SLang_push_opaque (GtkOpaque_Type, (void*) retval, 0);

   return;
   
cleanup:
   SLang_free_array (x);
free_y:
   SLang_free_array (y);
}

static void sl_gtk_databox_markers_new (void)
{
   GtkDataboxGraph *retval;
   GdkRGBA color = {0, 0, 0, 1};
   GtkDataboxMarkersType marker_type = GTK_DATABOX_MARKERS_NONE;
   GType xtype, ytype;
   SLang_Array_Type *x, *y;   
   guint default_length, len, maxlen, xstart, xstride, ystart, ystride, size = 0;

   if (usage_err (2, "GtkDataboxGraph = gtk_databox_markers_new (Array, Array [Struct, UInt, Int] ; qualifiers)"))
     return;

   if (SLang_Num_Function_Args > 4)
     {	
	if (-1 == SLang_pop_int ((int*) &marker_type))
	  return;
     }
   if (SLang_Num_Function_Args > 3)
     {	
	if (-1 == SLang_pop_uint ((unsigned int*) &size))
	  return;
     }
   if (SLang_Num_Function_Args > 2)
     {	
	if (-1 == SLang_pop_cstruct ((VOID_STAR) &color, GdkRGBA_Layout))
	  return;
     }   
   if (-1 == SLang_pop_array (&y))
     return;
   if (-1 == SLang_pop_array (&x))
     goto free_y;

   if (-1 == get_gtype (x->data_type, &xtype))
     goto cleanup;
   if (-1 == get_gtype (y->data_type, &ytype))
     goto cleanup;
   default_length = (x->dims [0] < y->dims [0]) ? x->dims [0] : y->dims [0];
   
   if (-1 == SLang_get_int_qualifier ("len", &len, default_length))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("maxlen", &maxlen, default_length))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("xstart", &xstart, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("xstride", &xstride, 1))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("ystart", &ystart, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("ystride", &ystride, 1))
     goto cleanup;

   retval = gtk_databox_markers_new_full (maxlen, len, 
					  (void *) x->data, xstart, xstride, xtype,
					  (void *) y->data, ystart, ystride, ytype,
					  &color, size, marker_type);
   
   (void) SLang_push_opaque (GtkOpaque_Type, (void*) retval, 0);
   
   return;
   
cleanup:
   SLang_free_array (x);
free_y:
   SLang_free_array (y);      
}

static void sl_gtk_databox_offset_bars_new (void)
{
   GtkDataboxGraph *retval;
   GdkRGBA color = {0, 0, 0, 1};   
   GType xtype, y1type, y2type;
   SLang_Array_Type *x, *y1, *y2;   
   guint default_length, len, maxlen, xstart, xstride, y1start, y1stride, y2start, y2stride, size = 0;

   if (usage_err (2, "GtkDataboxGraph = gtk_databox_offset_bars_new (Array, Array, Array [, Struct, UInt] ; qualifiers)"))
     return;

   if (SLang_Num_Function_Args > 4)
     {	
	if (-1 == SLang_pop_uint ((unsigned int*) &size))
	  return;
     }
   if (SLang_Num_Function_Args > 3)
     {	
	if (-1 == SLang_pop_cstruct ((VOID_STAR) &color, GdkRGBA_Layout))
	  return;
     }   
   if (-1 == SLang_pop_array (&y2))
     return;
   if (-1 == SLang_pop_array (&y1))
     goto free_y2;
   if (-1 == SLang_pop_array (&x))
     goto free_y1;

   if (-1 == get_gtype (x->data_type, &xtype))
     goto cleanup;
   if (-1 == get_gtype (y1->data_type, &y1type))
     goto cleanup;
   if (-1 == get_gtype (y2->data_type, &y2type))
     goto cleanup;
   if (y1type != y2type)
     {
	g_message ("");
	
     }  
   if (y1->dims [0] != y2->dims [0])
     {
	g_message ("");
	
     }   
   default_length = (x->dims [0] < y1->dims [0]) ? x->dims [0] : y1->dims [0];
   
   if (-1 == SLang_get_int_qualifier ("len", &len, default_length))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("maxlen", &maxlen, default_length))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("xstart", &xstart, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("xstride", &xstride, 1))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("y1start", &y1start, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("y1stride", &y1stride, 1))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("y2start", &y2start, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("y2stride", &y2stride, 1))
     goto cleanup;

   retval = gtk_databox_offset_bars_new_full (maxlen, len, 
					      (void *) x->data, xstart, xstride, xtype,
					      (void *) y1->data, y1start, y1stride,
					      (void *) y2->data, y2start, y2stride, y2type,
					      &color, size);
   
   (void) SLang_push_opaque (GtkOpaque_Type, (void*) retval, 0);

   return;
   
cleanup:
   SLang_free_array (x);
free_y1:
   SLang_free_array (y1);      
free_y2:
   SLang_free_array (y2);      
}

static void sl_gtk_databox_points_new (void)
{
   GtkDataboxGraph *retval;
   GdkRGBA color = {0, 0, 0, 1};
   
   GType xtype, ytype;
   SLang_Array_Type *x, *y;   
   guint default_length, len, maxlen, xstart, xstride, ystart, ystride, size = 0;

   if (usage_err (2, "GtkDataboxGraph = gtk_databox_points_new (Array, Array [, Struct, UInt] ; qualifiers)"))
     return;

   if (SLang_Num_Function_Args > 3)
     {	
	if (-1 == SLang_pop_uint ((unsigned int*) &size))
	  return;
     }
   if (SLang_Num_Function_Args > 2)
     {	
	if (-1 == SLang_pop_cstruct ((VOID_STAR) &color, GdkRGBA_Layout))
	  return;
     }   
   if (-1 == SLang_pop_array (&y))
     return;
   if (-1 == SLang_pop_array (&x))
     goto free_y;

   if (-1 == get_gtype (x->data_type, &xtype))
     goto cleanup;
   if (-1 == get_gtype (y->data_type, &ytype))
     goto cleanup;
   default_length = (x->dims [0] < y->dims [0]) ? x->dims [0] : y->dims [0];
   
   if (-1 == SLang_get_int_qualifier ("len", &len, default_length))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("maxlen", &maxlen, default_length))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("xstart", &xstart, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("xstride", &xstride, 1))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("ystart", &ystart, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("ystride", &ystride, 1))
     goto cleanup;

   retval = gtk_databox_points_new_full (maxlen, len, 
					x->data, xstart, xstride, xtype,
					y->data, ystart, ystride, ytype,
					&color, size);
   
   (void) SLang_push_opaque (GtkOpaque_Type, (void*) retval, 0);

   return;
   
cleanup:
   SLang_free_array (x);
free_y:
   SLang_free_array (y);      
}

static void sl_gtk_databox_regions_new (void)
{
   GtkDataboxGraph *retval;
   GdkRGBA color = {0, 0, 0, 1};   
   GType xtype, y1type, y2type;
   SLang_Array_Type *x, *y1, *y2;   
   guint default_length, len, maxlen, xstart, xstride, y1start, y1stride, y2start, y2stride;

   if (usage_err (2, "GtkDataboxGraph = gtk_databox_regions_new (Array, Array, Array [, Struct]; qualifiers)"))
     return;

   if (SLang_Num_Function_Args > 3)
     {	
	if (-1 == SLang_pop_cstruct ((VOID_STAR) &color, GdkRGBA_Layout))
	  return;
     }   
   if (-1 == SLang_pop_array (&y2))
     return;
   if (-1 == SLang_pop_array (&y1))
     goto free_y2;
   if (-1 == SLang_pop_array (&x))
     goto free_y1;

   if (-1 == get_gtype (x->data_type, &xtype))
     goto cleanup;
   if (-1 == get_gtype (y1->data_type, &y1type))
     goto cleanup;
   if (-1 == get_gtype (y2->data_type, &y2type))
     goto cleanup;
   if (y1type != y2type)
     {
	g_message ("y1 and y2 data must be of the same type");	
     }  
   if (y1->dims [0] != y2->dims [0])
     {
	g_message ("y1 and y2 arrays must have the same dimension");	
     }   
   default_length = (x->dims [0] < y1->dims [0]) ? x->dims [0] : y1->dims [0];
   
   if (-1 == SLang_get_int_qualifier ("len", &len, default_length))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("maxlen", &maxlen, default_length))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("xstart", &xstart, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("xstride", &xstride, 1))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("y1start", &y1start, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("y1stride", &y1stride, 1))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("y2start", &y2start, 0))
     goto cleanup;
   if (-1 == SLang_get_int_qualifier ("y2stride", &y2stride, 1))
     goto cleanup;

   retval = gtk_databox_regions_new_full (maxlen, len, 
					  x->data, xstart, xstride, xtype,
					  y1->data, y1start, y1stride,
					  y2->data, y2start, y2stride, y2type,
					  &color);
   
   (void) SLang_push_opaque (GtkOpaque_Type, (void*) retval, 0);

   return;
   
cleanup:
   SLang_free_array (x);
free_y1:
   SLang_free_array (y1);      
free_y2:
   SLang_free_array (y2);      
}

static void sl_gtk_databox_ruler_set_manual_ticks (void)
{
   SLang_Array_Type *ticks, *labels = NULL;
   guint len;
   GtkDataboxRuler *ruler;
   Slirp_Opaque* ruler_o = NULL;
   
   if (usage_err (2, "gtk_databox_ruler_set_manual_ticks (GtkWidget, Array [, Array])"))
     return;

   if (SLang_Num_Function_Args > 2)
     {	
	if (-1 == SLang_pop_array_of_type (&labels, SLANG_STRING_TYPE))
	  return;
     }   
   if (-1 == SLang_pop_array_of_type (&ticks, SLANG_FLOAT_TYPE))
     goto cleanup;
   if (-1 == SLang_pop_opaque (GtkWidget_Type, (void**) &ruler, &ruler_o))
     goto cleanup;
   
   if (labels != NULL)
     len = (ticks->dims [0] < labels->dims [0]) ? ticks->dims [0] : labels->dims [0];
   else
     len = ticks->dims [0];
   
   gtk_databox_ruler_set_manual_tick_cnt (ruler, len);
   gtk_databox_ruler_set_manual_ticks (ruler, ticks->data);
   if (labels != NULL)
     gtk_databox_ruler_set_manual_tick_labels (ruler, labels->data);

   SLang_free_opaque (ruler_o);
   
   return;
   
cleanup:
   SLang_free_array (ticks);
   SLang_free_array (labels);
}

static void sl_gtk_databox_values_to_xpixels (void)
{
}
					      
static SLang_Intrin_Fun_Type GtkDatabox3_Funcs [] =
{      
   MAKE_INTRINSIC_0 ("gtk_databox_bars_new", sl_gtk_databox_bars_new, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0 ("gtk_databox_grid_new", sl_gtk_databox_grid_new, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0 ("gtk_databox_grid_array_new", sl_gtk_databox_grid_array_new, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0 ("gtk_databox_lines_new", sl_gtk_databox_lines_new, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0 ("gtk_databox_markers_new", sl_gtk_databox_markers_new, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0 ("gtk_databox_offset_bars_new", sl_gtk_databox_offset_bars_new, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0 ("gtk_databox_points_new", sl_gtk_databox_points_new, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0 ("gtk_databox_regions_new", sl_gtk_databox_regions_new, SLANG_VOID_TYPE),
   MAKE_INTRINSIC_0 ("gtk_databox_ruler_set_manual_ticks", sl_gtk_databox_ruler_set_manual_ticks, SLANG_VOID_TYPE),
   /* MAKE_INTRINSIC_0 ("", sl_, SLANG_VOID_TYPE), */
   SLANG_END_INTRIN_FUN_TABLE
};

#define SLIRP_VERSION_STRING pre2.0.0-34
#define SLIRP_VERSION_NUMBER 20000

/* static SLang_Intrin_Var_Type GtkDatabox3_Vars[] = */
/* { */
   /* MAKE_VARIABLE("", &, SLANG_UINT_TYPE, 1), */
   /* SLANG_END_INTRIN_VAR_TABLE */
/* }; */

SLANG_MODULE (gtkdatabox3);

int init_gtkdatabox3_module_ns (char *ns_name)	/* {{{ */
{
   SLang_NameSpace_Type *ns = NULL;

   if (slang_abi_mismatch()) return -1;
   if (ns_name != NULL) {
	ns = SLns_create_namespace (ns_name);
       if (ns == NULL ||
          (slns = SLmalloc(strlen(ns_name)+1)) == NULL)
          return -1;
       strcpy(slns, ns_name);
   }
   
   /* avoid compile warn if unused */
   /* (void) &ref_get_size;  */

   if (allocate_reserved_opaque_types() == -1)
     return -1;

#ifdef HAVE_OPAQUE_IVARS
   if (-1 == set_opaque_ivar_types(gtkdatabox3_Opaque_IVars) ||
       -1 == SLns_add_intrin_var_table(ns,gtkdatabox3_Opaque_IVars,NULL))
	return -1;
#endif

   if ( -1 == SLns_add_iconstant_table(ns,gtkdatabox3_IConsts,NULL) ||
	-1 == SLns_add_intrin_fun_table (ns,gtkdatabox3_Funcs,NULL) ||
	-1 == SLns_add_intrin_fun_table (ns,GtkDatabox3_Funcs,(char*)"__gtkdatabox3__"))
	return -1;

   return 0;
} /* }}} */
