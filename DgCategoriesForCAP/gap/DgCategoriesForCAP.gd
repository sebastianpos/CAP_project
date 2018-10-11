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

##
DeclareAttribute( "DgDegree",
                  IsDgCategoryMorphism );

##
DeclareAttribute( "CommutativeRingOfDgCategory",
                  IsDgCategory );

####################################
##
#! @Section Basic operations
##
####################################

## The differential acting on morphisms of a dg category

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


## Scalars acting on morphisms of a dg category
DeclareOperation( "DgScalarMultiplication",
                  [ IsRingElement, IsDgCategoryMorphism ] );

DeclareOperation( "AddDgScalarMultiplication",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgScalarMultiplication",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgScalarMultiplication",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgScalarMultiplication",
                  [ IsCapCategory, IsList ] );

####################################
##
#! @Section Convenience methods
##
####################################

DeclareOperation( "DgPreCompose",
                  [ IsDgCategoryMorphism, IsDgCategoryMorphism ] );
