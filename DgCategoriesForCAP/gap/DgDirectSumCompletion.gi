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
InstallMethod( DgDirectSumCompletion,
               [ IsDgCategory ],
               
  function( underlying_category )
    local category, prerequisites, oper;
    
    category := CreateCapCategory( Concatenation( "Dg direct sum completion( ", Name( underlying_category )," )"  ) );
    
    SetFilterObj( category, IsDgDirectSumCompletionCategory );
    
    SetUnderlyingCategory( category, underlying_category );
    
    AddObjectRepresentation( category, IsDgDirectSumCompletionObject );
    
    AddMorphismRepresentation( category, IsDgDirectSumCompletionMorphism );
    
    DisableAddForCategoricalOperations( category );
    
    CapCategorySwitchLogicOff( category );
    
    INSTALL_FUNCTIONS_FOR_DG_DIRECT_SUM_COMPLETION( category );
    
    Finalize( category );
    
    return category;
    
end );

##
InstallMethod( DgDirectSumCompletionObject,
               [ IsList, IsDgDirectSumCompletionCategory ],
               
  function( object_list, category )
    local completion_object;
    
    completion_object := rec( );
    
    ObjectifyObjectForCAPWithAttributes( 
                             completion_object, category,
                             ObjectList, object_list
    );

    Add( category, completion_object );
    
    return completion_object;
    
end );

##
InstallMethod( AsDgDirectSumCompletionObject,
               [ IsDgCategoryObject ],
               
  function( object ) 
    
    return DgDirectSumCompletionObject( [ object ], DgDirectSumCompletion( CapCategory( object ) ) );
    
end );

##
InstallMethod( DgDirectSumCompletionMorphism,
               [ IsDgDirectSumCompletionObject, IsList, IsList, IsDgDirectSumCompletionObject, IsInt ],
  function( source, indices, entries, range, dgdeg )
    local matrix, category;
    
    matrix := rec( );
    
    category := CapCategory( source );
    
    ObjectifyMorphismForCAPWithAttributes( 
        matrix, category,
        Source, source,
        Range, range,
        Entries, entries,
        Indices, indices,
        DgDegree, dgdeg
    );

    Add( category, matrix );
    
    return matrix;
    
end );

##
InstallMethod( AsDgDirectSumCompletionMorphism,
               [ IsDgCategoryMorphism, IsInt ],
               
  function( morphism, dgdeg )
    local indices, entries;
    
    indices := [ [ 1 ] ];
    
    entries := [ [ morphism ] ];
    
    DgDirectSumCompletionMorphism(
        AsDgDirectSumCompletionObject( Source( morphism ) ),
        indices,
        entries,
        AsDgDirectSumCompletionObject( Range( morphism ) ),
        dgdeg
    );
    
end );

####################################
##
## Basic operations
##
####################################

##
InstallGlobalFunction( INSTALL_FUNCTIONS_FOR_DG_DIRECT_SUM_COMPLETION,
  
  function( category )
    local underlying_category;
    
    underlying_category := UnderlyingCategory( category );
    
    ##
    AddIsWellDefinedForObjects( category,
      function( object )
        local list;
        
        list := ObjectList( object );
        
        return IsDenseList( list )
               and ForAll( list, obj -> IsDgCategoryObject( obj ) )
               and ForAll( ObjectList( object ), obj -> IsIdenticalObj( underlying_category, CapCategory( obj ) ) );
        
    end );
    
    ##
    AddIsWellDefinedForMorphisms( category,
      function( morphism )
        local entries, indices, source, range, s, flat, i, ind, mor, j, dgdeg;
        
        entries := Entries( morphism );
        
        indices := Indices( morphism );
        
        source := ObjectList( Source( morphism ) );
        
        range := ObjectList( Range( morphism ) );
        
        if not List( entries, Size ) = List( indices, Size ) then
            
            return false;
            
        fi;
        
        s := Size( entries );
        
        if s > Size( source ) then
            
            return false;
            
        fi;
        
        flat := Flat( indices );
        
        if not ForAll( flat, i -> IsInt( i ) and i > 0 and i <= Size( range ) ) then
            
            return false;
            
        fi;
        
        dgdeg := DgDegree( morphism );
        
        for i in [ 1 .. s ] do
            
            if IsBound( indices[i] ) then
                
                ind := indices[i];
                
                # check whether source and range match the morphism
                
                for j in [ 1 .. Size( ind ) ] do
                    
                    mor := entries[i][j];
                    
                    if not DgDegree( mor ) = dgdeg then
                        
                        return false;
                        
                    fi;
                    
                    if not IsEqualForObjects( Source( mor ), source[ i ] ) then
                        
                        return false;
                        
                    fi;
                    
                    if not IsEqualForObjects( Range( mor ), range[ ind[j] ] ) then
                        
                        return false;
                        
                    fi;
                    
                od;
                
            fi;
            
        od;
        
        ## check the degrees
        
        return true;
        
    end );
    
end );

####################################
##
## View
##
####################################

##
InstallMethod( Display,
        [ IsDgDirectSumCompletionObject ],

  function( object )
    local list, obj;
    
    list := ObjectList( object );
    
    Print( "The formal dg direct sum of ", Size( list ), "many objects:\n" );
    
    for obj in ObjectList( object ) do
        
        Display( obj );
        
    od;
    
end );

##
InstallMethod( ViewObj,
        [ IsDgDirectSumCompletionObject ],

  function( object )
    local list, size, i;
    
    list := ObjectList( object );
    
    size := Size( list );
    
    if size > 0 then
        
        for i in [ 1 .. size - 1 ] do
            
            ViewObj( list[i] );
            
            Print( " + " );
            
        od;
        
        ViewObj( list[ size ] );
        
    else
        
        Print( "0" );
        
    fi;
    
end );
