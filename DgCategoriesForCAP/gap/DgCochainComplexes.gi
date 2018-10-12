#############################################################################
##
##  DgCategoriesForCAP: Experimenting with differential graded categories
##
##  Copyright 2018, Sebastian Posur, University of Siegen
##
#############################################################################

####################################
##
## Constructors
##
####################################

##
InstallMethod( DgBoundedCochainComplexCategory,
               [ IsCapCategory ],
               
  function( underlying_category )
    local category, prerequisites, oper;
    
    if not ( HasIsAdditiveCategory( underlying_category ) and IsAdditiveCategory( underlying_category ) ) then
        
        Error( "The underlying category has to be an additive category" );
        
    fi;
    
    if not IsLinearCategoryOverCommutativeRing( underlying_category ) then
        
        Error( "The underlying category has to be an a linear category over a commutative ring" );
        
    fi;
    
    prerequisites := [ "PreCompose", "IsZeroForMorphisms", "ZeroObject", "ZeroMorphism" ];
    
    for oper in prerequisites do
        
        if not CanCompute( underlying_category, oper ) then
            
            Error( "The underlying category should be able to compute ", oper );
            
        fi;
        
    od;
    
    category := CreateCapCategory( Concatenation( "Dg cochain complexes( ", Name( underlying_category )," )"  ) );
    
    SetFilterObj( category, IsDgBoundedCochainComplexCategory );
    
    ## in a dg sense
    # SetIsAdditiveCategory( category, true );
    
    SetCommutativeRingOfDgCategory( category, CommutativeRingOfLinearCategory( underlying_category ) );
    
    SetUnderlyingCategory( category, underlying_category );
    
    AddObjectRepresentation( category, IsDgBoundedCochainComplex );
    
    AddMorphismRepresentation( category, IsDgBoundedCochainMap );
    
    DisableAddForCategoricalOperations( category );
    
    CapCategorySwitchLogicOff( category );
    
    INSTALL_FUNCTIONS_FOR_DG_COCHAIN_COMPLEXES( category );
    
    Finalize( category );
    
    return category;
    
end );

##
InstallMethod( DgBoundedCochainComplex,
               [ IsList, IsDgBoundedCochainComplexCategory ],
               
  function( differential_list, category )
    local dg_cochain_complex;
    
    ## side effect: differential_list knows that it is strictly sorted
    if not IsSSortedList( differential_list ) then
        
        Error( "A cochain complex must have a strictly sorted differential list" );
        
    fi;
    
    dg_cochain_complex := rec( );
    
    ObjectifyObjectForCAPWithAttributes( 
                             dg_cochain_complex, category,
                             DifferentialList, differential_list
    );

    Add( category, dg_cochain_complex );
    
    return dg_cochain_complex;
    
end );

##
InstallMethod( DgBoundedCochainMap,
               [ IsDgBoundedCochainComplex, IsList, IsDgBoundedCochainComplex, IsInt ],
  function( source, morphism_list, range, dgdeg )
    local dg_cochain_map, category;
    
    ## side effect: morphism_list knows that it is strictly sorted
    if not IsSSortedList( morphism_list ) then
        
        Error( "A cochain complex must have a strictly sorted morphism list" );
        
    fi;
    
    dg_cochain_map := rec( );
    
    category := CapCategory( source );
    
    ObjectifyMorphismForCAPWithAttributes( 
        dg_cochain_map, category,
        Source, source,
        Range, range,
        MorphismList, morphism_list,
        DgDegree, dgdeg
    );

    Add( category, dg_cochain_map );
    
    return dg_cochain_map;
    
end );

####################################
##
## Getters
##
####################################

##
InstallMethod( \[\],
               [ IsDgBoundedCochainComplex, IsInt ],
               
  function( complex, index )
    local differential_list, first;
    
    differential_list := DifferentialList( complex );
    
    first := First( differential_list, l -> (index = l[1]) or (index = l[1] + 1) );
    
    if first = fail then
        
        return ZeroObject( UnderlyingCategory( CapCategory( complex ) ) );
        
    else
        
        if index = first[1] then
            
            return Source( first[2] );
            
        else #index = first[1] + 1
            
            return Range( first[2] );
            
        fi;
        
    fi;
    
end );

##
InstallMethod( \^,
               [ IsDgBoundedCochainComplex, IsInt ],
               
  function( complex, index )
    local differential_list, first;
    
    differential_list := DifferentialList( complex );
    
    first := First( differential_list, l -> index = l[1] );
    
    if first = fail then
        
        return ZeroMorphism( complex[index], complex[index+1] );
        
    else
        
        return first[2];
        
    fi;
    
end );

##
InstallMethod( \^,
               [ IsDgBoundedCochainMap, IsInt ],
               
  function( map, index )
    local morphism_list, first;
    
    morphism_list := MorphismList( map );
    
    first := First( morphism_list, l -> index = l[1] );
    
    if first = fail then
        
        return ZeroMorphism( Source( map )[index], Range( map )[index + DgDegree( map )] );
        
    else
        
        return first[2];
        
    fi;
    
end );

##
InstallMethod( IndexList,
               [ IsDgBoundedCochainComplex ],
               
  function( complex )
    local index_list;
    
    index_list := List( DifferentialList( complex ), l -> l[1] );
    
    ## side effect: index_list knows that it is strictly sorted
    if not IsSSortedList( index_list ) then
        
        Error( "A cochain complex must have a strictly sorted index list" );
        
    fi;
    
    return index_list;
    
end );

##
InstallMethod( IndexList,
               [ IsDgBoundedCochainMap ],
               
  function( map )
    local index_list;
    
    index_list := List( MorphismList( map ), l -> l[1] );
    
    ## side effect: index_list knows that it is strictly sorted
    if not IsSSortedList( index_list ) then
        
        Error( "A cochain map must have a strictly sorted index list" );
        
    fi;
    
    return index_list;
    
end );

##
InstallMethod( ObjectList,
               [ IsDgBoundedCochainComplex ],
               
  function( complex )
    local differential_list, object_list, l, s;
    
    differential_list := DifferentialList( complex );
    
    object_list := [];
    
    for l in differential_list do
        
        Add( object_list, [ l[1], Source( l[2] ) ] );
        
    od;
    
    s := Size( differential_list );
    
    if s > 0 then
        
        l := differential_list[s];
        
        Add( object_list, [ l[1] + 1, Range( l[2] ) ] );
        
    fi;
    
    ## side effect: index_list knows that it is strictly sorted
    if not IsSSortedList( object_list ) then
        
        Error( "A cochain complex must have a strictly sorted object list" );
        
    fi;
    
    return object_list;
    
end );

####################################
##
## Basic operations
##
####################################

##
InstallGlobalFunction( INSTALL_FUNCTIONS_FOR_DG_COCHAIN_COMPLEXES,
  
  function( category )
    local underlying_category, type_check_is_list_int_mor;
    
    underlying_category := UnderlyingCategory( category );
    
    ##
    AddIsEqualForCacheForObjects( category,
      IsIdenticalObj );
    
    ##
    AddIsEqualForCacheForMorphisms( category,
      IsIdenticalObj );
    
    ## Well-defined for objects and morphisms
    type_check_is_list_int_mor := function( differential_list, index_list )
        
        if not ForAll( differential_list, l -> IsList( l ) ) or
           not ForAll( differential_list, l -> Size( l ) = 2 ) or
           not ForAll( differential_list, l -> IsInt( l[1] ) ) or
           not ForAll( differential_list, l -> IsCapCategoryMorphism( l[2] ) ) or
           not ForAll( differential_list, l -> IsIdenticalObj( CapCategory( l[2] ), underlying_category ) ) then
           
            return false;
            
        fi;
        
        if not IsSSortedList( index_list )  then
            
            return false;
            
        fi;
        
        return true;
        
    end;
    
    ##
    AddIsWellDefinedForObjects( category,
      function( complex )
        local differential_list, index_list, size, i, a;
        
        differential_list := DifferentialList( complex );
        
        index_list := IndexList( complex );
        
        if not type_check_is_list_int_mor( differential_list, index_list ) then
            
            return false;
            
        fi;
        
        size := Size( index_list );
        
        for i in [ 1 .. size - 1 ] do
            
            a := index_list[ i + 1 ];
            
            if a - i = 1 then 
                
                if not IsEqualForMorphisms( Range( differential_list[i] ), Source( differential_list[a] ) ) or 
                   not IsZeroForMorphisms( PreCompose( differential_list[i], differential_list[a] ) ) then
                    
                    return false;
                    
                fi;
                
            fi;
            
        od;
        
        return true;
        
    end );
    
    ##
    AddIsWellDefinedForMorphisms( category,
      function( map )
        local morphism_list, index_list, source, range, dgdeg;
        
        morphism_list := MorphismList( map );
        
        index_list := IndexList( map );
        
        if not type_check_is_list_int_mor( morphism_list, index_list ) then
            
            return false;
            
        fi;
        
        source := Source( map );
        
        range := Range( map );
        
        dgdeg := DgDegree( map );
        
        if not ForAll( morphism_list, l -> IsEqualForObjects( Source( l[2] ), source[l[1]] ) ) or
           not ForAll( morphism_list, l -> IsEqualForObjects( Range( l[2] ), range[l[1] + dgdeg] ) ) then
            
            return false;
            
        fi;
        
        # all tests passed, so it is well-defined
        return true;
        
    end );
    
    ## Equality Basic Operations for Objects and Morphisms
    ##
    AddIsEqualForObjects( category,
      function( complex_1, complex_2 )
        local differential_list_1, differential_list_2, s;
        
        differential_list_1 := DifferentialList( complex_1 );
        
        differential_list_2 := DifferentialList( complex_2 );
        
        s := Size( differential_list_1 );
        
        if s <> Size( differential_list_2 ) then
            
            return false;
            
        fi;
        
        if not ForAll( [ 1 .. s ], i -> differential_list_1[i][1] = differential_list_2[i][1] ) then
            
            return false;
            
        fi;
        
        if not ForAll( [ 1 .. s ], i -> IsEqualForMorphismsOnMor( differential_list_1[i][2], differential_list_2[i][2] ) ) then
            
            return false;
            
        fi;
        
        return true;
        
    end );
    
    ##
    AddIsEqualForMorphisms( category,
      function( map_1, map_2 )
        local morphism_list_1, morphism_list_2, s;
        
        if DgDegree( map_1 ) <> DgDegree( map_2 ) then
            
            return false;
            
        fi;
        
        morphism_list_1 := MorphismList( map_1 );
        
        morphism_list_2 := MorphismList( map_2 );
        
        s := Size( morphism_list_1 );
        
        if s <> Size( morphism_list_2 ) then
            
            return false;
            
        fi;
        
        if not ForAll( [ 1 .. s ], i -> morphism_list_1[i][1] = morphism_list_2[i][1] ) then
            
            return false;
            
        fi;
        
        if not ForAll( [ 1 .. s ], i -> IsEqualForMorphismsOnMor( morphism_list_1[i][2], morphism_list_2[i][2] ) ) then
            
            return false;
            
        fi;
        
        return true;
        
    end );
    
    ##
    AddIsCongruentForMorphisms( category,
      function( map_1, map_2 )
        local morphism_list_1, morphism_list_2, index_list_1, index_list_2, i;
        
        if DgDegree( map_1 ) <> DgDegree( map_2 ) then
            
            return false;
            
        fi;
        
        morphism_list_1 := MorphismList( map_1 );
        
        morphism_list_2 := MorphismList( map_2 );
        
        index_list_1 := IndexList( map_1 );
        
        index_list_2 := IndexList( map_2 );
        
        for i in Difference( index_list_1, index_list_2 ) do
            
            if not IsZeroForMorphisms( map_1^i ) then
                
                return false;
                
            fi;
            
        od;
        
        for i in Difference( index_list_2, index_list_1 ) do
            
            if not IsZeroForMorphisms( map_2^i ) then
                
                return false;
                
            fi;
            
        od;
        
        for i in Intersection( index_list_1, index_list_2 ) do
            
            if not IsCongruentForMorphisms( map_1^i, map_2^i ) then
                
                return false;
                
            fi;
            
        od;
        
        return true;
        
    end );
    
    ## Basic Operations for a Category
    ##
    AddIdentityMorphism( category,
      
      function( complex )
        local object_list, l, morphism_list;
        
        object_list := ObjectList( complex );
        
        morphism_list := [];
        
        for l in object_list do
            
            Add( morphism_list, [ l[1], IdentityMorphism( l[2] ) ] );
            
        od;
        
        return DgBoundedCochainMap( complex, morphism_list, complex, 0 );
        
    end );
    
    ##
    AddDgScalarMultiplication( category,
      
      function( r, map )
        local morphism_list;
        
        morphism_list := MorphismList( map );
        
        morphism_list := List( morphism_list, l -> [ l[1], MultiplyWithElementOfCommutativeRingForMorphisms( r, l[2] ) ] );
        
        return DgBoundedCochainMap( Source( map ), morphism_list, Range( map ), DgDegree( map) );
        
    end );
    
    # ## TODO: add a dg version where one can specify the degree
    ##
    AddZeroMorphism( category,
      function( source, range )
        
        return DgBoundedCochainMap( source, [ ], range, 0 );
        
    end );
    
    ##
    AddPostCompose( category,
      function( map_2, map_1 )
        local index_list_1, dgdeg_1, index_list_2, morphism_list, morphism_list_1, morphism_list_2, i, first_1, first_2;
        
        index_list_1 := IndexList( map_1 );
        
        dgdeg_1 := DgDegree( map_1 );
        
        index_list_2 := List( IndexList( map_2 ), l -> l - dgdeg_1 );
        
        morphism_list_1 := MorphismList( map_1 );
        
        morphism_list_2 := MorphismList( map_2 );
        
        morphism_list := [];
        
        for i in Intersection( index_list_1, index_list_2 ) do
            
            first_1 := First( morphism_list_1, l -> l[1] = i );
            
            first_2 := First( morphism_list_2, l -> l[1] = i + dgdeg_1 );
            
            Add( morphism_list, [ i, PreCompose( first_1[2], first_2[2] ) ] );
            
        od;
        
        return DgBoundedCochainMap( Source( map_1 ), morphism_list, Range( map_2 ), DgDegree( map_1 ) + DgDegree( map_2 ) );
        
    end );
    
    ##
    AddDgDifferential( category,
      function( map )
        local dgdeg, source, range, d_morphism_list, morphism_list, index_list, i, entry, s;
        
        dgdeg := DgDegree( map );
        
        source := Source( map );
        
        range := Range( map );
        
        d_morphism_list := [];
        
        morphism_list := MorphismList( map );
        
        if not IsEmpty( morphism_list ) then
            
            index_list := IndexList( map );
            
            i := index_list[1] - 1;
            
            entry := MultiplyWithElementOfCommutativeRingForMorphisms( (-1)^(dgdeg + 1), PreCompose( source^i, map^(i+1) ) );
            
            Add( d_morphism_list, [ i, entry ] );
            
            s := Size( index_list );
            
            for i in index_list{[1..s-1]} do
                
                entry := 
                    MultiplyWithElementOfCommutativeRingForMorphisms( (-1)^(dgdeg + 1), PreCompose( source^i, map^(i+1) ) )
                    +
                    PreCompose( map^i, range^(i+dgdeg) );
                
                Add( d_morphism_list, [ i, entry ] );
                
            od;
            
            i := index_list[s];
            
            entry := PreCompose( map^i, range^(i+dgdeg) );
            
            Add( d_morphism_list, [ i, entry ] );
            
        fi;
        
        return DgBoundedCochainMap( source, d_morphism_list, range, dgdeg + 1 );
      
    end );
    
    ##
    AddIsDgZeroForMorphisms( category,
      function( map )
        
        return ForAll( MorphismList( map ), m -> IsZeroForMorphisms( m[2] ) );
        
    end );
    
end );
