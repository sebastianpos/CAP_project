#############################################################################
##
##  DgCategoriesForCAP: Experimenting with differential graded categories
##
##  Copyright 2018, Sebastian Posur, University of Siegen
##
#! @Chapter Dg categories
#!
#############################################################################

DeclareGlobalVariable( "DG_CATEGORIES_METHOD_NAME_RECORD" );

####################################
##
#! @Section GAP Categories
##
####################################

DeclareCategory( "IsDgCategoryObject",
                 IsCapCategoryObject );

DeclareCategory( "IsDgCategoryMorphism",
                 IsCapCategoryMorphism );

DeclareCategory( "IsDgCategory",
                 IsCapCategory );

####################################
##
#! @Section Attributes
##
####################################

DeclareAttribute( "DgDegree",
                  IsDgCategoryMorphism );

####################################
##
#! @Section Basic operations
##
####################################

DeclareAttribute( "DgDifferential",
                  IsDgCategoryMorphism );

DeclareOperation( "AddDgDifferential",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgDifferential",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgDifferential",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgDifferential",
                  [ IsCapCategory, IsList ] );