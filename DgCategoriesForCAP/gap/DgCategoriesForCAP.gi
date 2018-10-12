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

IsDgZeroForMorphisms := rec(
  installation_name := "IsDgZeroForMorphisms",
  filter_list := [ [ "morphism", IsDgCategoryMorphism ] ],
  return_type := "bool" 
),

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