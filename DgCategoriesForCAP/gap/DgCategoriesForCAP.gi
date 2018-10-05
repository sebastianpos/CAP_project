#############################################################################
##
##  DgCategoriesForCAP: Experimenting with differential graded categories
##
##  Copyright 2018, Sebastian Posur, University of Siegen
##
#############################################################################

InstallValue( DG_CATEGORIES_METHOD_NAME_RECORD, rec(

## Basic operations for dg categories

DgDifferential := rec(
  installation_name := "DgDifferential",
  filter_list := [ "morphism" ],
  return_type := "morphism",
  io_type := [ [ "a" ], [ "a_source", "a_range" ] ] ),
) );

CAP_INTERNAL_INSTALL_ADDS_FROM_RECORD( DG_CATEGORIES_METHOD_NAME_RECORD );