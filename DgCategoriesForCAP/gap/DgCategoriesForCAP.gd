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

## Deciding whether an object is dg-isomorphic to the zero object.
## In the particular case of a zero object, this is the same as being isomorphic to the zero object,
## i.e., regardless of the morphism being closed and of degree 0.
DeclareProperty( "IsDgZeroForObjects",
                 IsDgCategoryObject );

DeclareOperation( "AddIsDgZeroForObjects",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddIsDgZeroForObjects",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddIsDgZeroForObjects",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddIsDgZeroForObjects",
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

## DgZeroObject
DeclareAttribute( "DgZeroObject",
                  IsDgCategory );

DeclareOperation( "AddDgZeroObject",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgZeroObject",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgZeroObject",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgZeroObject",
                  [ IsCapCategory, IsList ] );

## DgUniversalMorphismFromZeroObject with specified degree
DeclareOperation( "DgUniversalMorphismFromZeroObject",
                  [ IsDgCategoryObject, IsInt ] );

DeclareOperation( "AddDgUniversalMorphismFromZeroObject",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgUniversalMorphismFromZeroObject",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgUniversalMorphismFromZeroObject",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgUniversalMorphismFromZeroObject",
                  [ IsCapCategory, IsList ] );


## DgUniversalMorphismIntoZeroObject with specified degree
DeclareOperation( "DgUniversalMorphismIntoZeroObject",
                  [ IsDgCategoryObject, IsInt ] );

DeclareOperation( "AddDgUniversalMorphismIntoZeroObject",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgUniversalMorphismIntoZeroObject",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgUniversalMorphismIntoZeroObject",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgUniversalMorphismIntoZeroObject",
                  [ IsCapCategory, IsList ] );

## DgDirectSum with specified degree
DeclareOperation( "DgDirectSum",
                  [ IsList ] );

DeclareOperation( "DgDirectSum",
                  [ IsList, IsDgCategory ] );

DeclareOperation( "DgDirectSumOp",
                  [ IsList, IsDgCategoryObject ] );

DeclareOperation( "AddDgDirectSum",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgDirectSum",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgDirectSum",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgDirectSum",
                  [ IsCapCategory, IsList ] );

## DgProjectionInFactorOfDirectSum (of degree 0 and closed)
DeclareOperation( "DgProjectionInFactorOfDirectSum",
                  [ IsList, IsInt ] );

DeclareOperation( "DgProjectionInFactorOfDirectSumOp",
                  [ IsList, IsInt, IsDgCategoryObject ] );

DeclareOperation( "AddDgProjectionInFactorOfDirectSum",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgProjectionInFactorOfDirectSum",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgProjectionInFactorOfDirectSum",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgProjectionInFactorOfDirectSum",
                  [ IsCapCategory, IsList ] );

## DgInjectionOfCofactorOfDirectSum (of degree 0 and closed)
DeclareOperation( "DgInjectionOfCofactorOfDirectSum",
                  [ IsList, IsInt ] );

DeclareOperation( "DgInjectionOfCofactorOfDirectSumOp",
                  [ IsList, IsInt, IsDgCategoryObject ] );

DeclareOperation( "AddDgInjectionOfCofactorOfDirectSum",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgInjectionOfCofactorOfDirectSum",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgInjectionOfCofactorOfDirectSum",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgInjectionOfCofactorOfDirectSum",
                  [ IsCapCategory, IsList ] );

## DgUniversalMorphismFromDirectSum
DeclareOperation( "DgUniversalMorphismFromDirectSum",
                  [ IsList, IsList ] );

DeclareOperation( "DgUniversalMorphismFromDirectSumOp",
                  [ IsList, IsList, IsDgCategoryObject ] );

DeclareOperation( "AddDgUniversalMorphismFromDirectSum",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgUniversalMorphismFromDirectSum",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgUniversalMorphismFromDirectSum",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgUniversalMorphismFromDirectSum",
                  [ IsCapCategory, IsList ] );

## DgUniversalMorphismIntoDirectSum
DeclareOperation( "DgUniversalMorphismIntoDirectSum",
                  [ IsList, IsList ] );

DeclareOperation( "DgUniversalMorphismIntoDirectSumOp",
                  [ IsList, IsList, IsDgCategoryObject ] );

DeclareOperation( "AddDgUniversalMorphismIntoDirectSum",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgUniversalMorphismIntoDirectSum",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgUniversalMorphismIntoDirectSum",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgUniversalMorphismIntoDirectSum",
                  [ IsCapCategory, IsList ] );

## DgMorphismBetweenDirectSums
DeclareOperation( "DgMorphismBetweenDirectSums",
                  [ IsList ] );

DeclareOperation( "DgMorphismBetweenDirectSums",
                  [ IsCapCategoryObject, IsList, IsCapCategoryObject, IsInt ] );

DeclareOperation( "AddDgMorphismBetweenDirectSums",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDgMorphismBetweenDirectSums",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDgMorphismBetweenDirectSums",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDgMorphismBetweenDirectSums",
                  [ IsCapCategory, IsList ] );

####################################
##
#! @Section Convenience methods
##
####################################

DeclareOperation( "DgPreCompose",
                  [ IsDgCategoryMorphism, IsDgCategoryMorphism ] );
