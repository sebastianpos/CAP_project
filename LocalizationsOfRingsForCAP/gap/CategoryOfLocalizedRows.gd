#############################################################################
##
##
##  Copyright 2019, Sebastian Posur, University of Siegen
##
#! @Chapter Category of localized rows
#!
#############################################################################

####################################
##
#! @Section GAP Categories
##
####################################

#! @Description
#! The GAP category of objects in the category
#! of rows over a ring $R$.
#! @Arguments object
DeclareCategory( "IsCategoryOfLocalizedRowsObject",
                 IsCapCategoryObject );

DeclareCategory( "IsCategoryOfLocalizedRowsMorphism",
                 IsCapCategoryMorphism );

DeclareGlobalFunction( "INSTALL_FUNCTIONS_FOR_CATEGORY_OF_LOCALIZED_ROWS" );

DeclareCategory( "IsCategoryOfLocalizedRows",
                 IsCapCategory );

####################################
##
#! @Section Constructors
##
####################################

DeclareOperation( "CategoryOfLocalizedRows",
                  [ IsHomalgRing, IsFunction ] );

KeyDependentOperation( "CategoryOfLocalizedRowsObject",
                       IsCategoryOfLocalizedRows, IsInt, ReturnTrue );

DeclareOperation( "AsCategoryOfLocalizedRowsMorphism",
                  [ IsHomalgMatrix, IsCategoryOfLocalizedRows ] );

DeclareOperation( "CategoryOfLocalizedRowsMorphism",
                  [ IsCategoryOfLocalizedRowsObject, IsHomalgMatrix, IsHomalgRingElement, IsCategoryOfLocalizedRowsObject ] );

####################################
##
#! @Section Attributes
##
####################################

DeclareAttribute( "UnderlyingRing",
                  IsCategoryOfLocalizedRows );

DeclareAttribute( "RankOfObject",
                  IsCategoryOfLocalizedRowsObject );

DeclareAttribute( "NumeratorOfLocalizedRowsMorphism",
                  IsCategoryOfLocalizedRowsMorphism );

DeclareAttribute( "DenominatorOfLocalizedRowsMorphism",
                  IsCategoryOfLocalizedRowsMorphism );

