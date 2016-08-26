############################################################################
##
##                                ActionsForCAP package
##
##  Copyright 2016, Sebastian Gutsche, University of Siegen
##                  Sebastian Posur,   University of Siegen
##
##
#############################################################################

####################################
##
## GAP Category
##
####################################

DeclareRepresentation( "IsSemisimpleCategoryObjectRep",
                       IsSemisimpleCategoryObject and IsAttributeStoringRep,
                       [ ] );

BindGlobal( "TheFamilyOfSemisimpleCategoryObjects",
        NewFamily( "TheFamilyOfSemisimpleCategoryObjects" ) );

BindGlobal( "TheTypeOfSemisimpleCategoryObjects",
        NewType( TheFamilyOfSemisimpleCategoryObjects,
                IsSemisimpleCategoryObjectRep ) );

####################################
##
## Constructors
##
####################################

##
InstallMethod( SemisimpleCategoryObject,
               [ IsList, IsCapCategory ],
               
  function( semisimple_object_list, category )
    local semisimple_object_flat_list, size;
    
    size := Size( semisimple_object_list );
    
    semisimple_object_flat_list := List( [ 2 .. 2 * size + 1 ],
      i -> semisimple_object_list[ QuoInt( i, 2 ) ][ RemInt( i, 2 ) + 1 ] );
    
    return SemisimpleCategoryObjectConstructorWithFlatList( semisimple_object_flat_list, category );
    
end );

##
InstallMethodWithCache( SemisimpleCategoryObjectConstructorWithFlatList,
               [ IsList, IsCapCategory ],
               
  function( semisimple_object_flat_list, category )
    local size, semisimple_object_list, semisimple_category_object, normalized_semisimple_object_list, field;
    
    size := Size( semisimple_object_flat_list );
    
    semisimple_object_list := List( [ 1 .. size/2 ], i ->
      [ semisimple_object_flat_list[ 2*i - 1 ], semisimple_object_flat_list[ 2*i ] ] );
    
    semisimple_category_object := rec( );
    
    normalized_semisimple_object_list := NormalizeSemisimpleCategoryObjectList( semisimple_object_list, category );
    
    field := UnderlyingCategoryForSemisimpleCategory( category )!.field_for_matrix_category;
    
    ObjectifyWithAttributes( semisimple_category_object, TheTypeOfSemisimpleCategoryObjects,
                             SemisimpleCategoryObjectList, normalized_semisimple_object_list,
                             UnderlyingFieldForHomalg, field
    );

    Add( category, semisimple_category_object );
    
    return semisimple_category_object;
    
end );

##
InstallMethod( NormalizeSemisimpleCategoryObjectList,
               [ IsList, IsCapCategory ],
               
  function( semisimple_object_list, category )
    local sort_function, result_list, multiplicity, j, irreducible_object, size, i;
    
    semisimple_object_list := Filtered( semisimple_object_list, entry -> entry[1] > 0 );
    
    sort_function := function( a, b ) return a[2] <= b[2]; end;
    
    Sort( semisimple_object_list, sort_function );
    
    size := Size( semisimple_object_list );
    
    result_list := [ ];
    
    i := 1;
    
    while ( i <= size ) do
        
        irreducible_object := semisimple_object_list[i][2];
        
        multiplicity := semisimple_object_list[i][1];
        
        j := i + 1;
        
        while ( j <= size ) and ( semisimple_object_list[j][2] = irreducible_object ) do
            
            multiplicity := multiplicity + semisimple_object_list[j][1];
            
            j := j + 1;
            
        od;
        
        Add( result_list, [ multiplicity, irreducible_object ] );
        
        i := j;
        
    od;
    
    return result_list;
    
end );

####################################
##
## Attributes
##
####################################

##
InstallMethod( Support,
               [ IsSemisimpleCategoryObject ],
               
  function( object )
    
    return List( SemisimpleCategoryObjectList( object ), elem -> elem[2] );
    
end );

####################################
##
## Operations
##
####################################

##
InstallMethod( Multiplicity,
               [ IsSemisimpleCategoryObject, IsObject ],
               
  function( semisimple_category_object, irr )
    local coeff;
    
    coeff := First( SemisimpleCategoryObjectList( semisimple_category_object ), elem -> elem[2] = irr );
    
    if coeff = fail then
        
        return 0;
        
    else
        
        return coeff[1];
        
    fi;
    
end );

##
InstallMethod( Component,
               [ IsSemisimpleCategoryObject, IsObject ],
               
  function( semisimple_category_object, irr )
    local multiplicity;
    
    multiplicity := Multiplicity( semisimple_category_object, irr );
    
    return VectorSpaceObject( multiplicity, UnderlyingFieldForHomalg( semisimple_category_object ) );
    
end );

##
InstallMethod( TestPentagonIdentity,
               [ IsSemisimpleCategoryObject, IsSemisimpleCategoryObject, IsSemisimpleCategoryObject, IsSemisimpleCategoryObject ],
               
  function( object_a, object_b, object_c, object_d )
    local morphism_1, morphism_2;
    
    morphism_1 :=
      TensorProductOnMorphisms( AssociatorLeftToRight( object_a, object_b, object_c ), IdentityMorphism( object_d ) );
    
    morphism_1 := PreCompose( morphism_1,
      AssociatorLeftToRight( object_a, TensorProductOnObjects( object_b, object_c ), object_d ) );
    
    morphism_1 := PreCompose( morphism_1,
      TensorProductOnMorphisms( IdentityMorphism( object_a ), AssociatorLeftToRight( object_b, object_c, object_d ) ) );
    
    morphism_2 := AssociatorLeftToRight( TensorProductOnObjects( object_a, object_b ), object_c, object_d );
    
    morphism_2 := PreCompose( morphism_2,
      AssociatorLeftToRight( object_a, object_b, TensorProductOnObjects( object_c, object_d ) ) );
    
    return morphism_1 = morphism_2;
    
end );

##
InstallMethod( TestPentagonIdentityForAllQuadruplesInList,
               [ IsList ],
               
  function( object_list )
    local a, b, c, d, size, list, test, string;
    
    size := Size( object_list );
    
    list := [ 1 .. size ];
    
    for a in list do
        
        for b in list do
            
            for c in list do
                
                for d in list do
                    
                    test := TestPentagonIdentity( object_list[a], object_list[b], object_list[c], object_list[d] );
                    
                    string := Concatenation( "(", String( a ), ", ", String( b ), ", ", String( c ), ", ", String( d ), ")" );
                    
                    if not test then
                        
                        Print( Concatenation( "The quadruple ", string, " FAILED! \n" ) ); 
                        
                    else
                        
                        Print( Concatenation( "The quadruple ", string, " is okay! \n" ) ); 
                        
                    fi;
                    
                od;
                
            od;
            
            
        od;
        
    od;
    
    
end );


####################################
##
## View
##
####################################

##
InstallMethod( Display,
               [ IsSemisimpleCategoryObject ],
               
  function( object )
    local object_list, string, i, size;
    
    object_list := SemisimpleCategoryObjectList( object );
    
    size := Size( object_list );
    
    if size = 0 then
        
        Print( "0\n" );
        
        return;
        
    fi;
    
    string := Concatenation( String( object_list[1][1] ), "*(χ_", String( object_list[1][2] ), ")" );
    
    for i in [ 2 .. size ] do
        
        Append( string, Concatenation( " + ", String( object_list[i][1] ), "*(χ_", String( object_list[i][2] ), ")" ) );
        
    od;
    
    Print( Concatenation( string, "\n" ) );
    
end );