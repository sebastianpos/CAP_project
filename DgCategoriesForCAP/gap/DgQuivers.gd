#############################################################################
##
##  DgCategoriesForCAP: Experimenting with differential graded categories
##
##  Copyright 2018, Sebastian Posur, University of Siegen
##
#! @Chapter Dg quivers
#!
#############################################################################

####################################
##
#! @Section GAP Categories
##
####################################

DeclareCategory( "IsDgQuiverObject",
                 IsDgCategoryObject );

DeclareCategory( "IsDgQuiverMorphism",
                 IsDgCategoryMorphism );

DeclareGlobalFunction( "INSTALL_FUNCTIONS_FOR_DG_QUIVERS" );

DeclareCategory( "IsDgQuiver",
                 IsDgCategory );

####################################
##
#! @Section Constructors
##
####################################

DeclareOperation( "DgQuiver",
                  [ IsQuiverAlgebra, IsList, IsList ] );

DeclareOperation( "DgQuiverObject",
                  [ IsVertex, IsDgQuiver ] );

DeclareOperation( "DgQuiverMorphism",
                  [ IsDgQuiverObject, IsQuiverAlgebraElement, IsDgQuiverObject, IsInt ] );

####################################
##
#! @Section Attributes
##
####################################

DeclareAttribute( "UnderlyingVertex",
                  IsDgQuiverObject );

DeclareAttribute( "UnderlyingQuiverAlgebraElement",
                  IsDgQuiverMorphism );

DeclareAttribute( "ObjectsOfDgQuiver",
                  IsDgQuiver );

DeclareAttribute( "ArrowsOfDgQuiver",
                  IsDgQuiver );

DeclareAttribute( "UnderlyingQuiverAlgebra",
                  IsDgQuiver );

DeclareAttribute( "UnderlyingLinearCategory",
                  IsDgQuiver );
