#############################################################################
##
##  DgCategoriesForCAP: Experimenting with differential graded categories
##
##  Copyright 2018, Sebastian Posur, University of Siegen
##
#############################################################################

InstallValue( DG_CATEGORIES_METHOD_NAME_RECORD, rec(

## Basic operations for dg categories
# try out new strategy: no WithGiven-operations (create the objects in the concrete implementation instead)

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

IsDgZeroForObjects := rec(
  installation_name := "IsDgZeroForObjects",
  filter_list := [ [ "object", IsDgCategoryObject ] ],
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
  io_type := [ [ "a", "b", "i" ], [ "a", "b" ] ],
  cache_name := "DgZeroMorphism",
  return_type := "morphism" ),

DgZeroObject := rec(
  installation_name := "DgZeroObject",
  filter_list := [ [ "category", IsDgCategory ] ],
  cache_name := "DgZeroObject",
  return_type := "object" ),

DgUniversalMorphismFromZeroObject := rec(
  installation_name := "DgUniversalMorphismFromZeroObject",
  filter_list := [ [ "object", IsDgCategoryObject ], IsInt ],
  io_type := [ [ "A", "i" ], [ "Z", "A" ] ],
  return_type := "morphism" ),

DgUniversalMorphismIntoZeroObject := rec(
  installation_name := "DgUniversalMorphismIntoZeroObject",
  filter_list := [ [ "object", IsDgCategoryObject ], IsInt ],
  io_type := [ [ "A", "i" ], [ "A", "Z" ] ],
  return_type := "morphism" ),

DgDirectSum := rec(
  installation_name := "DgDirectSumOp",
  filter_list := [ IsList, [ "object", IsDgCategoryObject ] ],
  argument_list := [ 1 ],
  cache_name := "DgDirectSumOp",
  return_type := "object",
  pre_function := function( diagram, selection_object )
      local category;
      
      category := CapCategory( selection_object );
      
      if not ForAll( diagram, IsDgCategoryObject ) then
          
          return [ false, "not all elements of the diagram are dg objects" ];
          
      elif not ForAll( diagram, i -> IsIdenticalObj( category, CapCategory( i ) ) )  then
          
          return [ false, "not all given objects lie in the same category" ];
          
      fi;
      
      return [ true ];
      
  end ),

DgProjectionInFactorOfDirectSum := rec(
  installation_name := "DgProjectionInFactorOfDirectSumOp",
  argument_list := [ 1, 2 ],
  filter_list := [ IsList, IsInt, [ "object", IsDgCategoryObject ] ],
  io_type := [ [ "D", "k" ], [ "S", "D_k" ] ],
  cache_name := "DgProjectionInFactorOfDirectSumOp",
  return_type := "morphism" ),

DgInjectionOfCofactorOfDirectSum := rec(
  installation_name := "DgInjectionOfCofactorOfDirectSumOp",
  argument_list := [ 1, 2 ],
  filter_list := [ IsList, IsInt, [ "object", IsDgCategoryObject ] ],
  io_type := [ [ "D", "k" ], [ "D_k", "S" ] ],
  cache_name := "DgInjectionOfCofactorOfDirectSumOp",
  return_type := "morphism" ),

DgUniversalMorphismFromDirectSum := rec(
  installation_name := "DgUniversalMorphismFromDirectSumOp",
  argument_list := [ 1, 2 ],
  filter_list := [ IsList, IsList, [ "object", IsDgCategoryObject ] ],
  io_type := [ [ "D", "tau" ], [ "S", "tau_1_range" ] ],
  cache_name := "DgUniversalMorphismFromDirectSumOp",
  pre_function := function( diagram, sink, selection_object )
    local category, test_object, current_morphism, current_return, l, test_deg, sub_sink;
    
    category := CapCategory( selection_object );
    
    if not ForAll( diagram, IsDgCategoryObject ) then
        
      return [ false, "not all elements of the diagram are dg objects" ];
        
    elif not ForAll( sink, IsDgCategoryMorphism ) then
      
      return [ false, "not all elements in the sink are morphisms" ];
      
    elif not ForAll( diagram, i -> IsIdenticalObj( category, CapCategory( i ) ) ) then
          
      return [ false, "not all given objects in the diagram lie in the same category" ];
          
    elif not ForAll( sink, i -> IsIdenticalObj( category, CapCategory( i ) ) ) then
      
      return [ false, "not all given morphisms in the sink lie in the same category" ];
      
    fi;
    
    l := Length( sink );
    
    if not l = Length( diagram ) then
      
      return [ false, "diagram and sink have to be of the same length" ];
      
    fi;
    
    test_deg := DgDegree( sink[1] );
    
    sub_sink := sink{[2 .. l]};
    
    if not ForAll( sub_sink, m -> DgDegree( m ) = test_deg ) then
      
      return [ false, "morphisms are of unequal degrees in the given sink" ];
      
    fi;
    
    test_object := Range( sink[1] );
    
    for current_morphism in sub_sink do
        
        current_return := IsEqualForObjects( Range( current_morphism ), test_object );
        
        if current_return = fail then
            
            return [ false, "cannot decide whether ranges of morphisms in given sink diagram are equal" ];
            
        elif current_return = false then
            
            return [ false, "ranges of morphisms must be equal in given sink diagram" ];
            
        fi;
        
    od;
    
    return [ true ];
    
  end,
  return_type := "morphism" ),

DgUniversalMorphismIntoDirectSum := rec(
  installation_name := "DgUniversalMorphismIntoDirectSumOp",
  argument_list := [ 1, 2 ],
  filter_list := [ IsList, IsList, [ "object", IsDgCategoryObject ] ],
  io_type := [ [ "D", "tau" ], [ "tau_1_source", "S" ] ],
  cache_name := "DgUniversalMorphismIntoDirectSumOp",
  pre_function := function( diagram, source, selection_object )
    local category, test_object, current_morphism, current_return, l, test_deg, sub_source;
    
    category := CapCategory( selection_object );
    
    if not ForAll( diagram, IsDgCategoryObject ) then
        
      return [ false, "not all elements of the diagram are dg objects" ];
        
    elif not ForAll( source, IsDgCategoryMorphism ) then
      
      return [ false, "not all elements in the source are morphisms" ];
      
    elif not ForAll( diagram, i -> IsIdenticalObj( category, CapCategory( i ) ) ) then
          
      return [ false, "not all given objects in the diagram lie in the same category" ];
          
    elif not ForAll( source, i -> IsIdenticalObj( category, CapCategory( i ) ) ) then
      
      return [ false, "not all given morphisms in the source lie in the same category" ];
      
    fi;
    
    l := Length( source );
    
    if not l = Length( diagram ) then
      
      return [ false, "diagram and source have to be of the same length" ];
      
    fi;
    
    test_deg := DgDegree( source[1] );
    
    sub_source := source{[2 .. l]};
    
    if not ForAll( sub_source, m -> DgDegree( m ) = test_deg ) then
      
      return [ false, "morphisms are of unequal degrees in the given source" ];
      
    fi;
    
    test_object := Source( source[1] );
    
    for current_morphism in sub_source do
        
        current_return := IsEqualForObjects( Source( current_morphism ), test_object );
        
        if current_return = fail then
            
            return [ false, "cannot decide whether sources of morphisms in given source diagram are equal" ];
            
        elif current_return = false then
            
            return [ false, "sources of morphisms must be equal in given source diagram" ];
            
        fi;
        
    od;
    
    return [ true ];
    
  end,
  return_type := "morphism" ),
  
  DgMorphismBetweenDirectSums := rec(
    installation_name := "DgMorphismBetweenDirectSums",
    filter_list := [ [ "object", IsDgCategoryObject ], IsList, [ "object", IsDgCategoryObject ], IsInt ],
    io_type := [ [ "S", "mat", "T", "d" ], [ "S", "T" ] ],
    cache_name := "DgMorphismBetweenDirectSums",
    pre_function := function( S, mat, T, dgdeg )
      local size, entry, mor, source;
      
      if IsEmpty( mat ) then
          
          return [ true ];
          
      fi;
      
      if not ForAll( mat, entry -> IsList( entry ) ) then
          
          return [ false, "2nd argument has to be a list of lists" ];
          
      fi;
      
      if ForAll( mat, entry -> IsEmpty( entry ) ) then
          
          return [ true ];
          
      fi;
      
      size := Size( mat[1] );
      
      if not ForAll( [ 2 .. Size( mat ) ], i -> Size( mat[i] ) = size ) then
          
          return [ false, "the lists in the 2nd argument have to be of equal sizes" ];
          
      fi;
      
      if not ForAll( mat, entry -> ForAll( entry, mor -> IsDgCategoryMorphism( mor ) ) ) then
          
          return [ false, "the lists in the 2nd argument have to consists of dg category morphisms" ];
          
      fi;
      
      if not ForAll( mat, entry -> ForAll( entry, mor -> DgDegree( mor ) = dgdeg ) ) then
          
          return [ false, "the given morphisms must have equal degrees" ];
          
      fi;
      
      for entry in mat do
          
          mor := entry[1];
          
          source := Source( mor );
          
          if not ForAll( [ 2 .. Size( entry ) ], i -> IsEqualForObjects( Source( entry[i] ), source ) ) then
              
              return [ false, "morphisms in the same row must have equal sources" ];
              
          fi;
          
      od;
      
      return [ true ];
      
    end,
    return_type := "morphism" ),
  ) );

CAP_INTERNAL_INSTALL_ADDS_FROM_RECORD( DG_CATEGORIES_METHOD_NAME_RECORD );

InstallMethod( AddDgZeroObject,
               [ IsCapCategory, IsFunction, IsInt ],
               
  function( category, func, weight )
    local wrapped_func;
    
    wrapped_func := function( cat ) return func(); end;
    
    AddDgZeroObject( category, [ [ wrapped_func, [ ] ] ], weight );
    
end );

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

####################################
##
## Dg addition
##
####################################

##
InstallMethod( \+,
               [ IsDgCategoryMorphism, IsDgCategoryMorphism ],
  function( morphism_1, morphism_2 )
    
    return DgAdditionForMorphisms( morphism_1, morphism_2 );
    
end );

##
InstallMethod( \-,
               [ IsDgCategoryMorphism, IsDgCategoryMorphism ],
  function( morphism_1, morphism_2 )
    
    return DgSubtractionForMorphisms( morphism_1, morphism_2 );
    
end );

##
InstallMethod( AdditiveInverse,
               [ IsDgCategoryMorphism ],
  function( morphism )
    
    return DgAdditiveInverseForMorphisms( morphism );
    
end );

####################################
##
## Ops
##
####################################

##
InstallMethod( DgDirectSum,
              [ IsList ],
              
  function( diagram )
    
    return DgDirectSumOp( diagram, diagram[1] );
    
end );

##
InstallMethod( DgDirectSum,
              [ IsList, IsDgCategory ],
              
  function( diagram, category )
    
    if IsEmpty( diagram ) then
      
      return DgZeroObject( category );
      
    fi;
    
    return DgDirectSumOp( diagram, diagram[1] );
    
end );

##
InstallMethod( DgProjectionInFactorOfDirectSum,
              [ IsList, IsInt ],
              
  function( diagram, k )
    
    return DgProjectionInFactorOfDirectSumOp( diagram, k, diagram[1] );
    
end );

##
InstallMethod( DgInjectionOfCofactorOfDirectSum,
              [ IsList, IsInt ],
              
  function( diagram, k )
    
    return DgInjectionOfCofactorOfDirectSumOp( diagram, k, diagram[1] );
    
end );

##
InstallMethod( DgUniversalMorphismFromDirectSum,
              [ IsList, IsList ],
              
  function( diagram, sink )
    
    return DgUniversalMorphismFromDirectSumOp( diagram, sink, diagram[1] );
    
end );

##
InstallMethod( DgUniversalMorphismIntoDirectSum,
              [ IsList, IsList ],
              
  function( diagram, source )
    
    return DgUniversalMorphismIntoDirectSumOp( diagram, source, diagram[1] );
    
end );

####################################
##
## Conveniences
##
####################################

##
InstallMethod( DgMorphismBetweenDirectSums,
               [ IsList ],
               
  function( morphism_matrix )
    local nr_rows, nr_cols, dg;
    
    nr_rows := Size( morphism_matrix );
    
    if nr_rows = 0 then
        
        Error( "The given matrix must not be empty" );
        
    fi;
    
    nr_cols := Size( morphism_matrix[1] );
    
    if nr_cols = 0 then
        
        Error( "The given matrix must not be empty" );
        
    fi;
    
    return DgMorphismBetweenDirectSums(
             DgDirectSum( List( morphism_matrix, row -> Source( row[1] ) ) ),
             morphism_matrix,
             DgDirectSum( List( morphism_matrix[1], col -> Range( col ) ) ),
             DgDegree( morphism_matrix[1][1] )
           );
    
end );