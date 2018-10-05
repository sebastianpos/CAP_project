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
    
    prerequisites := [ "PreCompose", "IsZeroForMorphisms", "ZeroObject", "ZeroMorphism" ];
    
    for oper in prerequisites do
        
        if not CanCompute( underlying_category, oper ) then
            
            Error( "The underlying category should be able to compute ", oper );
            
        fi;
        
    od;
    
    category := CreateCapCategory( Concatenation( "Dg cochain complexes( ", Name( underlying_category )," )"  ) );
    
    SetFilterObj( category, IsDgBoundedCochainComplexCategory );
    
    SetIsAdditiveCategory( category, true );
    
    SetUnderlyingCategory( category, underlying_category );
    
    AddObjectRepresentation( category, IsDgBoundedCochainComplex );
    
    AddMorphismRepresentation( category, IsDgBoundedCochainMap );
    
    DisableAddForCategoricalOperations( category );
    
    INSTALL_FUNCTIONS_FOR_DG_COCHAIN_COMPLEXES( category );
    
    Finalize( category );
    
    return category;
    
end );

##
InstallMethod( DgBoundedCochainComplex,
                        [ IsList, IsDgBoundedCochainComplexCategory ],
               
  function( differential_list, category )
    local dg_cochain_complex;
    
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
    type_check_is_list_int_mor := function( differential_list )
        local index_list;
        
        if not ForAll( differential_list, l -> IsList( l ) ) or
           not ForAll( differential_list, l -> Size( l ) = 2 ) or
           not ForAll( differential_list, l -> IsInt( l[1] ) ) or
           not ForAll( differential_list, l -> IsCapCategoryMorphism( l[2] ) ) or
           not ForAll( differential_list, l -> IsIdenticalObj( CapCategory( l[2] ), underlying_category ) ) then
           
            return [ false ];
            
        fi;
        
        index_list := List( differential_list, l -> l[1] );
        
        if not IsDuplicateFree( index_list ) or
           not IsSortedList( index_list )  then
            
            return [ false ];
            
        fi;
        
        return [ true, index_list ];
        
    end;
    
    ##
    AddIsWellDefinedForObjects( category,
      function( complex )
        local differential_list, index_list, size, i, a;
        
        differential_list := DifferentialList( complex );
        
        index_list := type_check_is_list_int_mor( differential_list );
        
        if not index_list[1] then
            
            return false;
            
        fi;
        
        index_list := index_list[2];
        
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
        
        index_list := type_check_is_list_int_mor( morphism_list );
        
        if not index_list[1] then
            
            return false;
            
        fi;
        
        index_list := index_list[2];
        
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
    
end );
