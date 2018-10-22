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

##
AddDerivationToCAP( DgSubtractionForMorphisms,
                      
  function( mor1, mor2 )
    
    return DgAdditionForMorphisms( mor1, DgAdditiveInverseForMorphisms( mor2 ) );
    
end : CategoryFilter := IsDgCategory,
      Description := "DgSubtractionForMorphisms(mor1, mor2) as the sum of mor1 and the additive inverse of mor2" );
