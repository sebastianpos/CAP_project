#############################################################################
##
##                                               CAP package
##
##  Copyright 2015, Sebastian Gutsche, TU Kaiserslautern
##                  Sebastian Posur,   RWTH Aachen
##
#! @Chapter Monoidal Categories
#!
##
#############################################################################

####################################
##
#! @Section Basic Operations for Monoidal Categories
##
####################################

## TensorProductOnObjects
DeclareOperationWithCache( "TensorProductOnObjects",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddTensorProductOnObjects",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddTensorProductOnObjects",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddTensorProductOnObjects",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddTensorProductOnObjects",
                  [ IsCapCategory, IsList ] );

## TensorProductOnMorphisms
DeclareOperation( "TensorProductOnMorphisms",
                  [ IsCapCategoryMorphism, IsCapCategoryMorphism ] );

DeclareOperation( "TensorProductOnMorphisms",
                  [ IsCapCategoryObject, IsCapCategoryMorphism, IsCapCategoryMorphism, IsCapCategoryObject ] );

DeclareOperation( "AddTensorProductOnMorphisms",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddTensorProductOnMorphisms",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddTensorProductOnMorphisms",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddTensorProductOnMorphisms",
                  [ IsCapCategory, IsList ] );


##
DeclareOperation( "AssociatorRightToLeft",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AssociatorRightToLeft",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddAssociatorRightToLeft",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddAssociatorRightToLeft",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddAssociatorRightToLeft",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddAssociatorRightToLeft",
                  [ IsCapCategory, IsList ] );



##
DeclareOperation( "AssociatorLeftToRight",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AssociatorLeftToRight",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddAssociatorLeftToRight",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddAssociatorLeftToRight",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddAssociatorLeftToRight",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddAssociatorLeftToRight",
                  [ IsCapCategory, IsList ] );


##
DeclareAttribute( "TensorUnit",
                  IsCapCategory );

DeclareOperation( "AddTensorUnit",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddTensorUnit",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddTensorUnit",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddTensorUnit",
                  [ IsCapCategory, IsList ] );


##
DeclareAttribute( "LeftUnitor",
                  IsCapCategoryObject );

# the second argument is the given tensor product
DeclareOperation( "LeftUnitor",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddLeftUnitor",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddLeftUnitor",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddLeftUnitor",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddLeftUnitor",
                  [ IsCapCategory, IsList ] );



##
DeclareAttribute( "LeftUnitorInverse",
                  IsCapCategoryObject );

# the second argument is the given tensor product
DeclareOperation( "LeftUnitorInverse",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddLeftUnitorInverse",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddLeftUnitorInverse",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddLeftUnitorInverse",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddLeftUnitorInverse",
                  [ IsCapCategory, IsList ] );


##
DeclareAttribute( "RightUnitor",
                  IsCapCategoryObject );

# the second argument is the given tensor product
DeclareOperation( "RightUnitor",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddRightUnitor",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddRightUnitor",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddRightUnitor",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddRightUnitor",
                  [ IsCapCategory, IsList ] );


##
DeclareAttribute( "RightUnitorInverse",
                  IsCapCategoryObject );

# the second argument is the given tensor product
DeclareOperation( "RightUnitorInverse",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddRightUnitorInverse",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddRightUnitorInverse",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddRightUnitorInverse",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddRightUnitorInverse",
                  [ IsCapCategory, IsList ] );


##
DeclareOperation( "Braiding",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "Braiding",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddBraiding",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddBraiding",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddBraiding",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddBraiding",
                  [ IsCapCategory, IsList ] );


##
DeclareOperation( "BraidingInverse",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "BraidingInverse",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddBraidingInverse",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddBraidingInverse",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddBraidingInverse",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddBraidingInverse",
                  [ IsCapCategory, IsList ] );


##
DeclareOperation( "InternalHomOnObjects",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddInternalHomOnObjects",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddInternalHomOnObjects",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddInternalHomOnObjects",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddInternalHomOnObjects",
                  [ IsCapCategory, IsList ] );


DeclareOperation( "InternalHomOnMorphisms",
                  [ IsCapCategoryMorphism, IsCapCategoryMorphism ] );

DeclareOperation( "InternalHomOnMorphisms",
                  [ IsCapCategoryObject, IsCapCategoryMorphism, IsCapCategoryMorphism, IsCapCategoryObject ] );

DeclareOperation( "AddInternalHomOnMorphisms",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddInternalHomOnMorphisms",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddInternalHomOnMorphisms",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddInternalHomOnMorphisms",
                  [ IsCapCategory, IsList ] );

##
DeclareOperation( "EvaluationMorphism",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

## the last argument is the source
DeclareOperation( "EvaluationMorphism",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddEvaluationMorphism",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddEvaluationMorphism",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddEvaluationMorphism",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddEvaluationMorphism",
                  [ IsCapCategory, IsList ] );

##
DeclareOperation( "CoevaluationMorphism",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

## the last argument is the range
DeclareOperation( "CoevaluationMorphism",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddCoevaluationMorphism",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddCoevaluationMorphism",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddCoevaluationMorphism",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddCoevaluationMorphism",
                  [ IsCapCategory, IsList ] );


##
DeclareOperation( "TensorProductToInternalHomAdjunctionMap",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddTensorProductToInternalHomAdjunctionMap",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddTensorProductToInternalHomAdjunctionMap",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddTensorProductToInternalHomAdjunctionMap",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddTensorProductToInternalHomAdjunctionMap",
                  [ IsCapCategory, IsList ] );


DeclareOperation( "InternalHomToTensorProductAdjunctionMap",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddInternalHomToTensorProductAdjunctionMap",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddInternalHomToTensorProductAdjunctionMap",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddInternalHomToTensorProductAdjunctionMap",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddInternalHomToTensorProductAdjunctionMap",
                  [ IsCapCategory, IsList ] );


##
DeclareOperation( "MonoidalPreComposeMorphism",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "MonoidalPreComposeMorphism",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddMonoidalPreComposeMorphism",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddMonoidalPreComposeMorphism",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddMonoidalPreComposeMorphism",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddMonoidalPreComposeMorphism",
                  [ IsCapCategory, IsList ] );


DeclareOperation( "MonoidalPostComposeMorphism",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "MonoidalPostComposeMorphism",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddMonoidalPostComposeMorphism",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddMonoidalPostComposeMorphism",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddMonoidalPostComposeMorphism",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddMonoidalPostComposeMorphism",
                  [ IsCapCategory, IsList ] );


##
DeclareAttribute( "DualOnObjects",
                  IsCapCategoryObject );

DeclareOperation( "AddDualOnObjects",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDualOnObjects",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDualOnObjects",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDualOnObjects",
                  [ IsCapCategory, IsList ] );

##
DeclareAttribute( "DualOnMorphisms",
                  IsCapCategoryMorphism );

DeclareOperation( "DualOnMorphisms",
                  [ IsCapCategoryObject, IsCapCategoryMorphism, IsCapCategoryObject ] );

DeclareOperation( "AddDualOnMorphisms",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddDualOnMorphisms",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddDualOnMorphisms",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddDualOnMorphisms",
                  [ IsCapCategory, IsList ] );

##
DeclareAttribute( "EvaluationForDual",
                  IsCapCategoryObject );

## the second argument is the tensor product
DeclareOperation( "EvaluationForDual",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddEvaluationForDual",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddEvaluationForDual",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddEvaluationForDual",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddEvaluationForDual",
                  [ IsCapCategory, IsList ] );

##
DeclareAttribute( "CoevaluationForDual",
                  IsCapCategoryObject );

## the second argument is the tensor product
DeclareOperation( "CoevaluationForDual",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddCoevaluationForDual",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddCoevaluationForDual",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddCoevaluationForDual",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddCoevaluationForDual",
                  [ IsCapCategory, IsList ] );


##
DeclareAttribute( "MorphismToBidual",
                  IsCapCategoryObject );

## the second argument is the bidual
DeclareOperation( "MorphismToBidual",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddMorphismToBidual",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddMorphismToBidual",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddMorphismToBidual",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddMorphismToBidual",
                  [ IsCapCategory, IsList ] );



##
DeclareOperation( "TensorProductInternalHomCompatibilityMorphism",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "TensorProductInternalHomCompatibilityMorphism",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddTensorProductInternalHomCompatibilityMorphism",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddTensorProductInternalHomCompatibilityMorphism",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddTensorProductInternalHomCompatibilityMorphism",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddTensorProductInternalHomCompatibilityMorphism",
                  [ IsCapCategory, IsList ] );


##
DeclareOperation( "TensorProductDualityCompatibilityMorphism",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "TensorProductDualityCompatibilityMorphism",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddTensorProductDualityCompatibilityMorphism",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddTensorProductDualityCompatibilityMorphism",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddTensorProductDualityCompatibilityMorphism",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddTensorProductDualityCompatibilityMorphism",
                  [ IsCapCategory, IsList ] );


##
DeclareOperation( "MorphismFromTensorProductToInternalHom",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "MorphismFromTensorProductToInternalHom",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddMorphismFromTensorProductToInternalHom",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddMorphismFromTensorProductToInternalHom",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddMorphismFromTensorProductToInternalHom",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddMorphismFromTensorProductToInternalHom",
                  [ IsCapCategory, IsList ] );


##
DeclareOperation( "MorphismFromInternalHomToTensorProduct",
                  [ IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "MorphismFromInternalHomToTensorProduct",
                  [ IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject, IsCapCategoryObject ] );

DeclareOperation( "AddMorphismFromInternalHomToTensorProduct",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddMorphismFromInternalHomToTensorProduct",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddMorphismFromInternalHomToTensorProduct",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddMorphismFromInternalHomToTensorProduct",
                  [ IsCapCategory, IsList ] );


##
DeclareAttribute( "TraceMap",
                  IsCapCategoryMorphism );

DeclareOperation( "AddTraceMap",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddTraceMap",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddTraceMap",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddTraceMap",
                  [ IsCapCategory, IsList ] );


##
DeclareAttribute( "RankMorphism",
                  IsCapCategoryObject );

DeclareOperation( "AddRankMorphism",
                  [ IsCapCategory, IsFunction ] );

DeclareOperation( "AddRankMorphism",
                  [ IsCapCategory, IsFunction, IsInt ] );

DeclareOperation( "AddRankMorphism",
                  [ IsCapCategory, IsList, IsInt ] );

DeclareOperation( "AddRankMorphism",
                  [ IsCapCategory, IsList ] );

