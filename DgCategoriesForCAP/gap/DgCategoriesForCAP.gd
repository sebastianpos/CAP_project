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


## Deciding whether a dg morphism equals the zero in any degree
DeclareProperty( "IsDgZeroForMorphisms",
                 IsDgCategoryMorphism );

DeclareOperation( "AddIsDgZeroForMorphisms",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddIsDgZeroForMorphisms",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddIsDgZeroForMorphisms",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddIsDgZeroForMorphisms",
                  [ IsCapCategory, IsList ] );


## Deciding whether a dg morphism is closed
DeclareProperty( "IsDgClosedMorphism",
                 IsDgCategoryMorphism );

DeclareOperation( "AddIsDgClosedMorphism",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddIsDgClosedMorphism",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddIsDgClosedMorphism",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddIsDgClosedMorphism",
                  [ IsCapCategory, IsList ] );

## Deciding whether a dg morphism is exact and if yes, construct a witness
DeclareAttribute( "DgWitnessForExactnessOfMorphism",
                 IsDgCategoryMorphism );

DeclareOperation( "AddDgWitnessForExactnessOfMorphism",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgWitnessForExactnessOfMorphism",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgWitnessForExactnessOfMorphism",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgWitnessForExactnessOfMorphism",
                  [ IsCapCategory, IsList ] );

## Adding two dg morphisms having the same degree
DeclareOperation( "DgAdditionForMorphisms",
                  [ IsDgCategoryMorphism, IsDgCategoryMorphism ] );

DeclareOperation( "AddDgAdditionForMorphisms",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgAdditionForMorphisms",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgAdditionForMorphisms",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgAdditionForMorphisms",
                  [ IsCapCategory, IsList ] );

## Subtracting two dg morphisms having the same degree
DeclareOperation( "DgSubtractionForMorphisms",
                  [ IsDgCategoryMorphism, IsDgCategoryMorphism ] );

DeclareOperation( "AddDgSubtractionForMorphisms",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgSubtractionForMorphisms",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgSubtractionForMorphisms",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgSubtractionForMorphisms",
                  [ IsCapCategory, IsList ] );

## Taking the additive inverse of a dg morphism
DeclareAttribute( "DgAdditiveInverseForMorphisms",
                  IsDgCategoryMorphism );

DeclareOperation( "AddDgAdditiveInverseForMorphisms",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgAdditiveInverseForMorphisms",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgAdditiveInverseForMorphisms",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgAdditiveInverseForMorphisms",
                  [ IsCapCategory, IsList ] );

## DgZeroMorphism of degree to be specified
DeclareOperation( "DgZeroMorphism",
                  [ IsDgCategoryObject, IsCapCategoryObject, IsInt ] );

DeclareOperation( "AddDgZeroMorphism",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgZeroMorphism",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgZeroMorphism",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgZeroMorphism",
                  [ IsCapCategory, IsList ] );

####################################
##
#! @Section Convenience methods
##
####################################

DeclareOperation( "DgPreCompose",
                  [ IsDgCategoryMorphism, IsDgCategoryMorphism ] );
