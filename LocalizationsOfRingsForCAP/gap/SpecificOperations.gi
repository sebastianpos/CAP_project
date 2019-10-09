#############################################################################
##
##  Copyright 2019, Sebastian Posur, University of Siegen
##
#############################################################################

##
InstallMethod( QuotientByTorsion,
               [ IsFreydCategoryObject ],
               
  function( obj )
    local mor, mat;
    
    mor := RelationMorphism( obj );
    
    mat := NumeratorOfLocalizedRowsMorphism( mor );
    
    mat := ReducedSyzygiesOfRows( TransposedMatrix( ReducedSyzygiesOfRows( TransposedMatrix( mat ) ) ) );
    
    return
        FreydCategoryObject( 
            UniversalMorphismFromDirectSum(
                mor,
                AsCategoryOfLocalizedRowsMorphism( mat, CapCategory( mor ) )
            )
        );
    
end );

##
InstallMethod( EpimorphismToQuotientByTorsion,
               [ IsFreydCategoryObject ],
  function( obj )
    local torsion_free_quotient, mor, nr_gen, cat, ring;
    
    torsion_free_quotient := QuotientByTorsion( obj );
    
    mor :=  RelationMorphism( obj );
    
    nr_gen := NrColumns( mor );
    
    cat := CapCategory( mor );
    
    ring := UnderlyingRing( cat );
    
    return
        FreydCategoryMorphism( 
            obj,
            AsCategoryOfLocalizedRowsMorphism( HomalgIdentityMatrix( nr_gen, ring ), cat ),
            torsion_free_quotient
        );
    
end );