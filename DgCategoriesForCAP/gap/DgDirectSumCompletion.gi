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
    
    SetCommutativeRingOfDgCategory( category, CommutativeRingOfDgCategory( underlying_category ) );
    
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
    local underlying_category, DECOMPOSE_UNION_OF_SETS, PERFORM_BINARY_OPERATOR_ON_MORPHISMS_FOR_DG_DIRECT_SUM_COMPLETION,
          GET_INDICES, GET_ENTRIES;
    
    underlying_category := UnderlyingCategory( category );
    
    ##
    GET_INDICES := function( mor, i )
        
        if IsBound( Indices(mor)[i] ) then
            
            return Indices(mor)[i];
            
        else
            
            return [];
            
        fi;
        
    end;
    
    ##
    GET_ENTRIES := function( mor, i )
        
        if IsBound( Entries(mor)[i] ) then
            
            return Entries(mor)[i];
            
        else
            
            return [];
            
        fi;
        
    end;
    
    ##
    AddIsEqualForCacheForObjects( category,
      IsIdenticalObj );
    
    ##
    AddIsEqualForCacheForMorphisms( category,
      IsIdenticalObj );
    
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
    
    ##
    AddIsEqualForObjects( category,
      function( obj_1, obj_2 )
        local list_1, list_2, size;
        
        list_1 := ObjectList( obj_1 );
        
        list_2 := ObjectList( obj_2 );
        
        size := Size( list_1 );
        
        return size = Size( list_2 )
               and ForAll( [ 1 .. size ], i -> IsEqualForObjects( list_1[i], list_2[i] ) );
        
    end );
    
    ##
    AddIsEqualForMorphisms( category,
      function( mor_1, mor_2 )
        local flat_1, flat_2;
        
        if DgDegree( mor_1 ) <> DgDegree( mor_2 ) then
            
            return false;
            
        fi;
        
        if not Indices( mor_1 ) = Indices( mor_2 ) then
            
            return false;
            
        fi;
        
        flat_1 := Flat( Entries( mor_1 ) );
        
        flat_2 := Flat( Entries( mor_2 ) );
        
        return ForAll( [ 1 .. Size( flat_1 ) ], i -> IsEqualForMorphisms( flat_1[i], flat_2[i] ) );
        
    end );
    
    DECOMPOSE_UNION_OF_SETS := function( A, B )
        
        return [
            Difference( A, B ),
            Difference( B, A ),
            Intersection( A, B )
        ];
        
    end;
    
    ##
    AddIsCongruentForMorphisms( category,
      function( mor_1, mor_2 )
        local indices_1, indices_2, bound_1, bound_2, entries_1, entries_2, dec, i, dec_entries,
              j_counter, j_counter_1, j_counter_2, j;
        
        if DgDegree( mor_1 ) <> DgDegree( mor_2 ) then
            
            return false;
            
        fi;
        
        indices_1 := Indices( mor_1 );
        
        indices_2 := Indices( mor_2 );
        
        bound_1 := BoundPositions( indices_1 );
        
        bound_2 := BoundPositions( indices_2 );
        
        entries_1 := Entries( mor_1 );
        
        entries_2 := Entries( mor_2 );
        
        dec := DECOMPOSE_UNION_OF_SETS( bound_1, bound_2 );
        
        # bound_1 - bound_2
        
        if ForAny(dec[1], i -> ForAny( entries_1[i], mor -> not IsDgZeroForMorphisms( mor ) ) ) then
            
            return false;
            
        fi;
        
        # bound_2 - bound_1
        
        if ForAny( dec[2], i -> ForAny( entries_2[i], mor -> not IsDgZeroForMorphisms( mor ) ) ) then
            
            return false;
            
        fi;
        
        # bound_1 cap bound_2
        
        for i in dec[3] do
            
            dec_entries := DECOMPOSE_UNION_OF_SETS( indices_1[i], indices_2[i] );
            
            ## indices_1[i] - indices_2[i]
            
            for j in dec_entries[1] do
                
                j_counter := Position( indices_1[i], j );
                
                if not IsDgZeroForMorphisms( entries_1[i][j_counter] ) then
                    
                    return false;
                    
                fi;
                
            od;
            
            ## indices_2[i] - indices_1[i]
            
            for j in dec_entries[2] do
                
                j_counter := Position( indices_2[i], j );
                
                if not IsDgZeroForMorphisms( entries_2[i][j_counter] ) then
                    
                    return false;
                    
                fi;
                
            od;
            
            ## indices_1[i] cap indices_2[i]
            
            for j in dec_entries[3] do
                
                j_counter_1 := Position( indices_1[i], j );
                
                j_counter_2 := Position( indices_2[i], j );
                
                if not IsCongruentForMorphisms( entries_1[i][j_counter_1], entries_2[i][j_counter_2] ) then
                    
                    return false;
                    
                fi;
                
            od;
            
        od;
        
        return true;
        
    end );
    
    ##
    AddIdentityMorphism( category,
      
      function( obj )
        local list, indices, entries;
        
        list := ObjectList( obj );
        
        indices := [ 1 .. Size( list ) ];
        
        entries := List( indices, i -> [ IdentityMorphism( list[i] ) ] );
        
        indices := List( indices, i -> [ i ] );
        
        return DgDirectSumCompletionMorphism(
            obj,
            indices,
            entries,
            obj,
            0
        );
        
    end );
    
    ##
    AddPostCompose( category,
      function( mor_2, mor_1 )
        local indices_1, entries_1, indices_2, entries_2, indices_prod, entries_prod, i,
              entries_row_i, possible_ks, j_counter, entries_row_ij, j, k,
              k_counter, prod_ik, occurences_k, pos;
        
        indices_1 := Indices( mor_1 );
        
        indices_2 := Indices( mor_2 );
        
        entries_1 := Entries( mor_1 );
        
        entries_2 := Entries( mor_2 );
        
        indices_prod := [ ];
        
        entries_prod := [ ];
        
        ## i: non-empty rows of mor_1
        for i in BoundPositions( indices_1 ) do
            
            entries_row_i := [ ];
            
            possible_ks := [ ];
            
            ## j: non-empty columns in the i-th row of mor_1
            for j_counter in [ 1 .. Size( indices_1[i] ) ] do
                
                entries_row_ij := [ ];
                
                j := indices_1[i][j_counter];
                
                if IsBound( indices_2[j] ) then
                    
                    ## k: non-empty columns in the j-th row of mor_2
                    for k_counter in [ 1 .. Size( indices_2[j]) ] do
                        
                        k := indices_2[j][k_counter];
                        
                        prod_ik := PreCompose( entries_1[i][j_counter], entries_2[j][k_counter] );
                        
                        Add( entries_row_ij, prod_ik );
                        
                        Add( possible_ks, k );
                        
                    od;
                    
                    Add( entries_row_i, entries_row_ij );
                    
                fi;
                
            od;
            
            possible_ks := Set( possible_ks );
            
            ## if this is the case, then there will be a non-empty i-th row in the product
            if not IsEmpty( possible_ks ) then
                
                indices_prod[i] := possible_ks;
                
                entries_prod[i] := [];
                
                # collect 
                
                for k in possible_ks do
                    
                    occurences_k := [ ];
                    
                    for j_counter in [ 1 .. Size( indices_1[i] ) ] do
                        
                        j := indices_1[i][j_counter];
                        
                        pos := Position( indices_2[j], k );
                        
                        if pos <> fail then
                            
                            Add( occurences_k, entries_row_i[j_counter][pos] );
                            
                        fi;
                        
                    od;
                    
                    prod_ik := Iterated( occurences_k, DgAdditionForMorphisms );
                    
                    Add( entries_prod[i], prod_ik );
                    
                od;
                
            fi;
            
        od;
        
        return DgDirectSumCompletionMorphism(
            Source( mor_1 ),
            indices_prod,
            entries_prod,
            Range( mor_2 ),
            DgDegree( mor_1 ) + DgDegree( mor_2 )
        );
        
    end );
    
    ##
    AddDgDifferential( category,
      function( mor )
        
        return DgDirectSumCompletionMorphism(
            Source( mor ),
            Indices( mor ),
            List( Entries( mor ), row -> List( row, DgDifferential ) ),
            Range( mor ),
            DgDegree( mor ) + 1
        );
        
    end );
    
    ##
    AddIsDgZeroForMorphisms( category,
      function( mor )
        
        return ForAll( Entries( mor ), row -> ForAll( row, m -> IsDgZeroForMorphisms( m ) ) );
        
    end );
    
    PERFORM_BINARY_OPERATOR_ON_MORPHISMS_FOR_DG_DIRECT_SUM_COMPLETION := function( mor_1, mor_2, oper )
        local bound, indices, entries, b, indices_1, indices_2, j, pos_1, pos_2, entry;
        
        bound := Union( BoundPositions( Indices( mor_1 ) ), BoundPositions( Indices( mor_2 ) ) );
        
        indices := [];
        
        entries := [];
        
        for b in bound do
            
            ## compute indices of addition
            indices_1 := GET_INDICES( mor_1, b );
            
            indices_2 := GET_INDICES( mor_2, b );
            
            indices[b] := Union( indices_1, indices_2 );
            
            entries[b] := [];
            
            for j in indices[b] do
                
                pos_1 := Position( indices_1, j );
                
                pos_2 := Position( indices_2, j );
                
                if pos_1 <> fail then
                    
                    if pos_2 <> fail then
                        
                        entry := oper( Entries( mor_1 )[b][pos_1], Entries( mor_2 )[b][pos_2]  );
                        
                    else
                        
                        entry := Entries( mor_1 )[b][pos_1];
                        
                    fi;
                    
                else
                    
                    entry := Entries( mor_2 )[b][pos_2];
                    
                fi;
                
                Add( entries[b], entry );
                
            od;
            
        od;
        
        return DgDirectSumCompletionMorphism(
            Source( mor_1 ),
            indices,
            entries,
            Range( mor_1 ),
            DgDegree( mor_1 )
        );
        
    end;
    
    ##
    AddDgAdditionForMorphisms( category,
      function( mor_1, mor_2 )
        
        return PERFORM_BINARY_OPERATOR_ON_MORPHISMS_FOR_DG_DIRECT_SUM_COMPLETION(
            mor_1, mor_2, DgAdditionForMorphisms
        );
        
    end );
    
    ##
    AddDgSubtractionForMorphisms( category,
      function( mor_1, mor_2 )
        
        return PERFORM_BINARY_OPERATOR_ON_MORPHISMS_FOR_DG_DIRECT_SUM_COMPLETION(
            mor_1, mor_2, DgSubtractionForMorphisms
        );
        
    end );
    
    ##
    AddDgZeroMorphism( category,
      function( source, range, dgdeg )
        
        return DgDirectSumCompletionMorphism(
            source,
            [ ],
            [ ],
            range,
            dgdeg
        );
        
    end );
    
    ##
    AddDgScalarMultiplication( category,
      function( r, mor )
        
        return DgDirectSumCompletionMorphism(
            Source( mor ),
            Indices( mor ),
            List( Entries( mor ), row -> List( row, alpha -> DgScalarMultiplication( r, alpha ) ) ),
            Range( mor ),
            DgDegree( mor )
        );
        
    end );
    
    ##
    AddDgZeroObject( category,
      function( )
        
        return DgDirectSumCompletionObject( [ ], category );
        
    end );
    
    ##
    AddDgUniversalMorphismIntoZeroObject( category,
      function( obj, dgdeg )
        
        return DgDirectSumCompletionMorphism(
            obj,
            [ ],
            [ ],
            DgZeroObject( category ),
            dgdeg
        );
        
    end );
    
    ##
    AddDgUniversalMorphismFromZeroObject( category,
      function( obj, dgdeg )
        
        return DgDirectSumCompletionMorphism(
            DgZeroObject( category ),
            [ ],
            [ ],
            obj,
            dgdeg
        );
        
    end );
    
    ##
    AddDgDirectSum( category,
      function( diagram )
        
        return DgDirectSumCompletionObject(
            Concatenation( List( diagram, ObjectList ) ), category
        );
        
    end );
    
    ##
    AddDgProjectionInFactorOfDirectSum( category,
      function( diagram, k )
        local source, range, indices, entries, pre, list, i, i_counter;
        
        source := DgDirectSum( diagram );
        
        range := diagram[k];
        
        indices := [ ];
        
        entries := [ ];
        
        pre := Sum( List( [ 1 .. k - 1 ], i -> Size( ObjectList( diagram[i] ) ) ) );
        
        list := ObjectList( range );
        
        for i in [ pre + 1 .. pre + Size( list ) ] do
            
            i_counter := i - pre;
            
            indices[i] := [ i_counter ];
            
            entries[i] := [ IdentityMorphism( list[ i_counter ] ) ];
            
        od;
        
        return DgDirectSumCompletionMorphism( 
            source, 
            indices,
            entries,
            range, 
            0 
        );
        
    end );
    
    ##
    AddDgInjectionOfCofactorOfDirectSum( category,
      function( diagram, k )
        local source, range, indices, entries, pre, list, i;
        
        range := DgDirectSum( diagram );
        
        source := diagram[k];
        
        indices := [ ];
        
        entries := [ ];
        
        pre := Sum( List( [ 1 .. k - 1 ], i -> Size( ObjectList( diagram[i] ) ) ) );
        
        list := ObjectList( source );
        
        for i in [ 1 .. Size( list ) ] do
            
            indices[i] := [ pre + i ];
            
            entries[i] := [ IdentityMorphism( list[ i ] ) ];
            
        od;
        
        return DgDirectSumCompletionMorphism( 
            source, 
            indices,
            entries,
            range, 
            0 
        );
        
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
    
    Print( "The formal dg direct sum of ", Size( list ), " object(s):\n" );
    
    for obj in ObjectList( object ) do
        
        Display( obj );
        
    od;
    
end );

##
InstallMethod( Display,
        [ IsDgDirectSumCompletionMorphism ],

  function( morphism )
    local i, j;
    
    Print( "Degree: ", String( DgDegree( morphism ) ), "\n\n" );
    
    Print( "Source:\n");
    
    Display( Source( morphism ) );
    
    Print( "\n");
    
    Print( "Range:\n");
    
    Display( Range( morphism ) );
    
    Print( "\n");
    
    Print( "Defining matrix:\n");
    
    for i in BoundPositions( Indices( morphism ) ) do
        
        for j in [ 1 .. Size( Indices( morphism )[i] ) ] do
            
            Print( "[", String(i), ",", String( Indices( morphism )[i][j] ), "]:\n" );
            
            Display( Entries( morphism )[i][j] );
            
        od;
        
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
