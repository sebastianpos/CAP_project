#############################################################################
##
##  DgCategoriesForCAP: Experimenting with differential graded categories
##
##  Copyright 2018, Sebastian Posur, University of Siegen
##
#! @Chapter Dg direct sum completion
#!
#############################################################################

####################################
##
#! @Section GAP Categories
##
####################################

DeclareCategory( "IsDgDirectSumCompletionObject",
                 IsDgCategoryObject );

DeclareCategory( "IsDgDirectSumCompletionMorphism",
                 IsDgCategoryMorphism );

DeclareCategory( "IsDgDirectSumCompletionCategory",
                 IsDgCategory );

DeclareGlobalFunction( "INSTALL_FUNCTIONS_FOR_DG_DIRECT_SUM_COMPLETION" );

####################################
##
#! @Section Constructors
##
####################################

DeclareAttribute( "DgDirectSumCompletion",
                  IsDgCategory );

DeclareOperation( "DgDirectSumCompletionObject",
                  [ IsList, IsDgDirectSumCompletionCategory ] );

DeclareAttribute( "AsDgDirectSumCompletionObject",
                  IsDgCategoryObject );

DeclareOperation( "DgDirectSumCompletionMorphism",
                  [ IsDgDirectSumCompletionObject, IsList, IsList, IsDgDirectSumCompletionObject, IsInt ] );

DeclareOperation( "AsDgDirectSumCompletionMorphism",
                  [ IsDgCategoryMorphism, IsInt ] );

####################################
##
#! @Section Attributes
##
####################################

DeclareAttribute( "UnderlyingCategory",
                  IsDgDirectSumCompletionCategory );

DeclareAttribute( "ObjectList",
                  IsDgDirectSumCompletionObject );

DeclareAttribute( "Entries",
                  IsDgDirectSumCompletionMorphism );

DeclareAttribute( "Indices",
                  IsDgDirectSumCompletionMorphism );

DeclareAttribute( "EntriesAsListListOfMorphisms",
                  IsDgDirectSumCompletionMorphism );
