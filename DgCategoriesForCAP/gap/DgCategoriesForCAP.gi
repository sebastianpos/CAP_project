#############################################################################
##
##  DgCategoriesForCAP: Experimenting with differential graded categories
##
##  Copyright 2018, Sebastian Posur, University of Siegen
##
#############################################################################

InstallValue( DG_CATEGORIES_METHOD_NAME_RECORD, rec(

## Basic operations for dg categories

DgDifferential := rec(
  installation_name := "DgDifferential",
  filter_list := [ [ "morphism", IsDgCategoryMorphism ] ],
  return_type := "morphism",
  io_type := [ [ "a" ], [ "a_source", "a_range" ] ] 
),

DgScalarMultiplication := rec(
  installation_name := "DgScalarMultiplication",
  filter_list := [ IsRingElement, [ "morphism", IsDgCategoryMorphism ] ],
  io_type := [ [ "r", "a" ], [ "a_source", "a_range" ] ],
  cache_name := "DgScalarMultiplication",
  
  pre_function := function( r, morphism )
    
    if not r in CommutativeRingOfDgCategory( CapCategory( morphism ) ) then
      
      return [ false, "the first argument is not an element of the ring of the dg category of the morphism" ];
      
    fi;
    
    return [ true ];
  end,
  return_type := "morphism" 
),

IsDgClosedMorphism := rec(
  installation_name := "IsDgClosedMorphism",
  filter_list := [ [ "morphism", IsDgCategoryMorphism ] ],
  return_type := "bool" 
),

DgWitnessForExactnessOfMorphism := rec(
  installation_name := "DgWitnessForExactnessOfMorphism",
  filter_list := [ [ "morphism", IsDgCategoryMorphism ] ],
  return_type := "morphism_or_fail",
  io_type := [ [ "a" ], [ "a_source", "a_range" ] ] 
),

IsDgZeroForMorphisms := rec(
  installation_name := "IsDgZeroForMorphisms",
  filter_list := [ [ "morphism", IsDgCategoryMorphism ] ],
  return_type := "bool" 
),

DgAdditionForMorphisms := rec(
  installation_name := "DgAdditionForMorphisms",
  filter_list := [ [ "morphism", IsDgCategoryMorphism ], [ "morphism", IsDgCategoryMorphism ] ],
  io_type := [ [ "a" ], [ "a_source", "a_range" ] ],
  cache_name := "DgAdditionForMorphisms",
  pre_function := function( morphism_1, morphism_2 )
    local value_1, value_2;
    
    value_1 := IsEqualForObjects( Source( morphism_1 ), Source( morphism_2 ) );
    
    if value_1 = fail then
      
      return [ false, "cannot decide whether sources are equal" ];
      
    elif value_1 = false then
      
      return [ false, "sources are not equal" ];
    
    fi;
    
    value_2 := IsEqualForObjects( Range( morphism_1 ), Range( morphism_2 ) );
    
    if value_2 = fail then
      
      return [ false, "cannot decide whether ranges are equal" ];
      
    elif value_2 = false then
      
      return [ false, "ranges are not equal" ];
    
    fi;
    
    if not DgDegree( morphism_1 ) = DgDegree( morphism_2 ) then
      
      return [ false, "degrees differ" ];
      
    fi;
    
    return [ true ];
    
  end,
  return_type := "morphism" ),

DgSubtractionForMorphisms := rec(
  installation_name := "DgSubtractionForMorphisms",
  filter_list := [ [ "morphism", IsDgCategoryMorphism ], [ "morphism", IsDgCategoryMorphism ] ],
  io_type := [ [ "a" ], [ "a_source", "a_range" ] ],
  cache_name := "SubtractionForMorphisms",
  pre_function := ~.DgAdditionForMorphisms.pre_function,
  return_type := "morphism" ),

DgAdditiveInverseForMorphisms := rec(
  installation_name := "DgAdditiveInverseForMorphisms",
  filter_list := [ [ "morphism", IsDgCategoryMorphism ] ],
  io_type := [ [ "a" ], [ "a_source", "a_range" ] ],
  return_type := "morphism" ),

DgZeroMorphism := rec(
  installation_name := "DgZeroMorphism",
  filter_list := [ [ "object", IsDgCategoryObject ], [ "object", IsDgCategoryObject ], IsInt ],
  io_type := [ [ "a", "b" ], [ "a", "b" ] ],
  cache_name := "DgZeroMorphism",
  return_type := "morphism" ),
  ) );

CAP_INTERNAL_INSTALL_ADDS_FROM_RECORD( DG_CATEGORIES_METHOD_NAME_RECORD );

####################################
##
## Dg Composition
##
####################################

##
InstallMethod( DgPreCompose,
               [ IsDgCategoryMorphism, IsDgCategoryMorphism ],
  function( alpha, beta )
    
    return DgScalarMultiplication( (-1)^(DgDegree( alpha ) * DgDegree( beta )), PostCompose( beta, alpha ) );
    
end );

####################################
##
## Dg scalar multiplication
##
####################################

##
InstallMethod( \*,
               [ IsRingElement, IsDgCategoryMorphism ],
  function( ring_element, morphism )
    
    return DgScalarMultiplication( ring_element, morphism );
    
end );

##
InstallMethod( \*,
               [ IsDgCategoryMorphism, IsRingElement ],
  function( morphism, ring_element )
    
    return DgScalarMultiplication( ring_element, morphism );
    
end );