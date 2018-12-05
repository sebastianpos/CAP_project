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

##
AddDerivationToCAP( IsDgZeroForObjects,
  function( object )
    
    return IsDgZeroForMorphisms( IdentityMorphism( object ) );
    
end : CategoryFilter := IsDgCategory,
      Description := "IsDgZeroForObjects by checking whether the identity is zero" );

###########################
##
## Methods returning a morphism where the source and range can directly be read of from the input
##
###########################

##
AddDerivationToCAP( DgMorphismBetweenDirectSums,
                    
  function( S, morphism_matrix, T, dgdeg )
    local diagram_direct_sum_source, diagram_direct_sum_range, test_diagram_product, test_diagram_coproduct;
    
    if morphism_matrix = [ ] or morphism_matrix[1] = [ ] then
        return DgZeroMorphism( S, T, dgdeg );
    fi;
    
    diagram_direct_sum_source := List( morphism_matrix, row -> Source( row[1] ) );
    
    diagram_direct_sum_range := List( morphism_matrix[1], entry -> Range( entry ) );
    
    test_diagram_coproduct := [ ];
    
    for test_diagram_product in morphism_matrix do
      
      Add( test_diagram_coproduct, DgUniversalMorphismIntoDirectSum( diagram_direct_sum_range, test_diagram_product ) );
      
    od;
    
    return DgUniversalMorphismFromDirectSum( diagram_direct_sum_source, test_diagram_coproduct );
    
end : Description := "DgMorphismBetweenDirectSums using universal morphisms of direct sums" );
