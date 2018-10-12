###########################
##
## Methods returning a boolean
##
###########################

##
AddDerivationToCAP( IsDgClosedMorphism,
  function( morphism )
    
    return IsDgZeroForMorphisms( DgDifferential( morphism ) );
    
end : CategoryFilter := IsDgCategory,
      Description := "IsDgClosedMorphism by checking if the dg differential of the given morphism is zero" );