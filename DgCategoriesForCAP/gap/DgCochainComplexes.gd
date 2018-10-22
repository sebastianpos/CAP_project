#############################################################################
##
##  DgCategoriesForCAP: Experimenting with differential graded categories
##
##  Copyright 2018, Sebastian Posur, University of Siegen
##
#! @Chapter Dg cochain complexes
#!
#############################################################################

####################################
##
#! @Section GAP Categories
##
####################################

DeclareCategory( "IsDgBoundedCochainComplex",
                 IsDgCategoryObject );

DeclareCategory( "IsDgBoundedCochainMap",
                 IsDgCategoryMorphism );

DeclareGlobalFunction( "INSTALL_FUNCTIONS_FOR_DG_COCHAIN_COMPLEXES" );

DeclareCategory( "IsDgBoundedCochainComplexCategory",
                 IsDgCategory );

####################################
##
#! @Section Constructors
##
####################################

DeclareAttribute( "DgBoundedCochainComplexCategory",
                  IsCapCategory );

##
## Data structure: [ [ i, differential^i ] ], sorted by ... < i < i + 1 < ..., no duplicates, every non-given differential is interpreted as the zero map, every non-given object is interpreted as the zero object
DeclareOperation( "DgBoundedCochainComplex",
                  [ IsList, IsDgBoundedCochainComplexCategory ] );

## Data structure: [ [ i, f^i: A^i -> B^{i + d} ] ], sorted by ... < i < i + 1 < ..., no duplicates, every non-given map is interpreted as the zero map A^i -0-> B^{i+d}
DeclareOperation( "DgBoundedCochainMap",
                  [ IsDgBoundedCochainComplex, IsList, IsDgBoundedCochainComplex, IsInt ] );

####################################
##
#! @Section Attributes
##
####################################

DeclareAttribute( "UnderlyingCategory",
                  IsDgBoundedCochainComplexCategory );

DeclareAttribute( "DifferentialList",
                  IsDgBoundedCochainComplex );

DeclareAttribute( "IndexList",
                  IsDgBoundedCochainComplex );

DeclareAttribute( "ObjectList",
                  IsDgBoundedCochainComplex );

DeclareAttribute( "ObjectIndexList",
                  IsDgBoundedCochainComplex );

DeclareAttribute( "MorphismList",
                  IsDgBoundedCochainMap );

DeclareAttribute( "IndexList",
                  IsDgBoundedCochainMap );

####################################
##
#! @Section Operators
##
####################################

DeclareOperation( "\[\]",
                  [ IsDgBoundedCochainComplex, IsInt ] );

DeclareOperation( "\^",
                  [ IsDgBoundedCochainComplex, IsInt ] );

DeclareOperation( "\^",
                  [ IsDgBoundedCochainMap, IsInt ] );
