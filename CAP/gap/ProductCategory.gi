#############################################################################
##
##                                               CAP package
##
##  Copyright 2013, Sebastian Gutsche, TU Kaiserslautern
##                  Sebastian Posur,   RWTH Aachen
##
## Chapter Product category
##
#############################################################################

DeclareRepresentation( "IsCapCategoryProductCellRep",
                       IsAttributeStoringRep and IsCapCategoryProductCell,
                       [ ] );

DeclareRepresentation( "IsCapCategoryProductObjectRep",
                       IsCapCategoryProductCellRep and IsCapCategoryProductObject and IsCapCategoryObjectRep,
                       [ ] );

DeclareRepresentation( "IsCapCategoryProductMorphismRep",
                       IsCapCategoryProductCellRep and IsCapCategoryProductMorphism and IsCapCategoryMorphismRep,
                       [ ] );

DeclareRepresentation( "IsCapCategoryProductTwoCellRep",
                       IsCapCategoryProductCellRep and IsCapCategoryProductTwoCell and IsCapCategoryTwoCellRep,
                       [ ] );

BindGlobal( "TheTypeOfCapCategoryProductObjects",
        NewType( TheFamilyOfCapCategoryObjects,
                IsCapCategoryProductObjectRep ) );

BindGlobal( "TheTypeOfCapCategoryProductMorphisms",
        NewType( TheFamilyOfCapCategoryMorphisms,
                IsCapCategoryProductMorphismRep ) );

BindGlobal( "TheTypeOfCapCategoryProductTwoCells",
        NewType( TheFamilyOfCapCategoryTwoCells,
                IsCapCategoryProductTwoCellRep ) );

###################################
##
## Section Fallback methods for functors
##
###################################

##
InstallMethod( Components,
               [ IsCapCategory and IsCapProductCategory ],
               
  i -> [ i ] );

##
InstallMethod( Components,
               [ IsCapCategoryProductCell ],
               
  i -> [ i ] );

###################################
##
## Section Constructor
##
###################################

BindGlobal( "CAP_INTERNAL_CREATE_PRODUCT_ARGUMENT_LIST",
  
  function( arg_list )
    local nr_components, current_argument, i, j, current_mat, new_args;
    
    i := 1;
    
    while IsInt( arg_list[ i ] ) do
        i := i + 1;
    od;
    
    if IsCapCategoryCell( arg_list[ 1 ] ) or IsCapCategory( arg_list[ 1 ] ) then
        
        nr_components := Length( arg_list[ 1 ] );
        
    elif IsList( arg_list[ 1 ] ) then
        
        nr_components := Length( arg_list[ 1 ][ 1 ] );
        
    fi;
    
    new_args := List( [ 1 .. nr_components ], i -> [ ] );
    
    for i in [ 1 .. Length( arg_list ) ] do
        
        current_argument := arg_list[ i ];
        
        if IsCapCategoryCell( current_argument ) or IsCapCategory( current_argument ) then
            
            for j in [ 1 .. nr_components ] do
                new_args[ j ][ i ] := current_argument[ j ];
            od;
            
        elif IsInt( current_argument ) then
            
            for j in [ 1 .. nr_components ] do
                new_args[ j ][ i ] := current_argument;
            od;
            
        elif IsList( current_argument ) then
            
            current_mat := TransposedMat( List( current_argument, Components ) );
            
            for j in [ 1 .. nr_components ] do
                new_args[ j ][ i ] := current_mat[ j ];
            od;
            
        else
            
            Error( "Unrecognized argument type" );
            
        fi;
        
    od;
    
    return new_args;
    
end );

##
BindGlobal( "CAP_INTERNAL_INSTALL_PRODUCT_ADDS_FROM_CATEGORY",
  
  function( product_category )
    local recnames, current_recname, category_weight_list, current_entry, func,
          current_add, create_func, components;
    
    recnames := RecNames( CAP_INTERNAL_METHOD_NAME_RECORD );
    
    components := Components( product_category );
    
    category_weight_list := List( components, category -> category!.derivations_weight_list );
    
    for current_recname in recnames do
        
        current_entry := CAP_INTERNAL_METHOD_NAME_RECORD.( current_recname );
        
        if IsBound( current_entry.no_install ) and current_entry.no_install = true then
            continue;
        fi;
        
        if ForAny( category_weight_list, list -> CurrentOperationWeight( list, current_recname ) = infinity ) then
            continue;
        fi;
        
        create_func := function( current_name )
            
            return function( arg )
                local product_args, result_list;
                
                product_args := CAP_INTERNAL_CREATE_PRODUCT_ARGUMENT_LIST( arg );
                
                result_list := List( product_args, i -> CallFuncList( ValueGlobal( current_name ), i ) );
                
                if ForAll( result_list, IsBool ) then
                    return ForAll( result_list, i -> i = true );
                fi;
                
                return CallFuncList( Product, result_list );
                
            end;
            
        end;
        
        func := create_func( current_recname );
        
        current_add := ValueGlobal( Concatenation( "Add", current_recname ) );
        
        current_add( product_category, func );
        
    od;
    
end );

##
InstallMethodWithCacheFromObject( ProductOp,
                                  [ IsList, IsCapCategory ],
                        
  function( category_list, selector )
    local product_category, namestring;
    
    if not ForAll( category_list, HasIsFinalized ) or not ForAll( category_list, IsFinalized ) then
        Error( "all categories for the product must be finalized" );
    fi;
    
    ## this is the convention in CapCat
    if Length( category_list ) = 1 then
      
      return category_list[1];
      
    fi;
    
    namestring := JoinStringsWithSeparator( List( category_list, Name ), ", " );
    
    namestring := Concatenation( "Product of: " , namestring );
    
    product_category := CreateCapCategory( namestring );
    
    SetComponents( product_category, category_list );
    
    SetLength( product_category, Length( category_list ) );
    
    SetFilterObj( product_category, IsCapProductCategory );
    
    CAP_INTERNAL_INSTALL_PRODUCT_ADDS_FROM_CATEGORY( product_category );
    
    Finalize( product_category );
    
    return product_category;
    
end : ArgumentNumber := 2 );

##
InstallMethodWithCacheFromObject( ProductOp_OnObjects,
                                  [ IsList, IsCapCategory ],
                        
  function( object_list, category )
    local product_object, entry, i;
    
    product_object := rec( );
    
    ObjectifyWithAttributes( product_object, TheTypeOfCapCategoryProductObjects,
                             Components, object_list,
                             Length, Length( object_list )
                           );
    
    Add( category, product_object );
    
    return product_object;
    
end : ArgumentNumber := 2 );

##
InstallMethodWithCacheFromObject( ProductOp_OnMorphisms,
                                  [ IsList, IsCapCategory ],
                                  
  function( morphism_list, category )
    local product_morphism, entry, i;
    
    product_morphism := rec( );
    
    ObjectifyWithAttributes( product_morphism, TheTypeOfCapCategoryProductMorphisms,
                             Components, morphism_list,
                             Length, Length( morphism_list )
                           );
    
    Add( category, product_morphism );
    
    return product_morphism;
    
end : ArgumentNumber := 2 );

##
InstallMethodWithCacheFromObject( ProductOp_OnTwoCells,
                                  [ IsList, IsCapCategory ],
                                  
  function( twocell_list, category )
    local product_twocell;
    
    product_twocell := rec( );
    
    ObjectifyWithAttributes( product_twocell, TheTypeOfCapCategoryProductTwoCells,
                             Components, twocell_list,
                             Length, Length( twocell_list )
                           );
    
    Add( category, product_twocell );
    
    return product_twocell;
    
end : ArgumentNumber := 2 );

##
InstallMethod( ProductOp,
               [ IsList, IsCapCategoryObject ],
               
  function( object_list, selector )
    local category_list;
    
    category_list := List( object_list, CapCategory );
    
    return ProductOp_OnObjects( object_list, ProductOp( category_list, category_list[ 1 ] ) );
    
end );

##
InstallMethod( ProductOp,
               [ IsList, IsCapCategoryMorphism ],
               
  function( morphism_list, selector )
    local category_list;
    
    category_list := List( morphism_list, CapCategory );
    
    return ProductOp_OnMorphisms( morphism_list, ProductOp( category_list, category_list[ 1 ] ) );
    
end );

##
InstallMethod( ProductOp,
               [ IsList, IsCapCategoryTwoCellRep ],
               
  function( twocell_list, selector )
    local category_list;
    
    category_list := List( twocell_list, CapCategory );
    
    return ProductOp_OnMorphisms( twocell_list, ProductOp( category_list, category_list[ 1 ] ) );
    
end );

##
InstallMethod( \[\],
               [ IsCapCategory and IsCapProductCategory, IsInt ],
               
  function( category, index )
    
    if Length( category ) < index then
        
        Error( "index too high, cannot compute this Component" );
        
    fi;
    
    return Components( category )[ index ];
    
end );

##
InstallMethod( \[\],
               [ IsCapCategoryProductCellRep, IsInt ],
               
  function( cell, index )
    
    if Length( cell ) < index then
        
        Error( "index too high, cannot compute this Component" );
        
    fi;
    
    return Components( cell )[ index ];
    
end );

###################################
##
## Section Morphism function
##
###################################

##
InstallMethod( Source,
               [ IsCapCategoryProductMorphismRep ],
               
  function( morphism )
    
    return CallFuncList( Product, List( Components( morphism ), Source ) );
    
end );

##
InstallMethod( Range,
               [ IsCapCategoryProductMorphismRep ],
               
  function( morphism )
    
    return CallFuncList( Product, List( Components( morphism ), Range ) );
    
end );

##
InstallMethod( Source,
               [ IsCapCategoryProductTwoCellRep ],
               
  function( twocell )
    
    return CallFuncList( Product, List( Components( twocell ), Source ) );
    
end );

##
InstallMethod( Range,
               [ IsCapCategoryProductMorphismRep ],
               
  function( twocell )
    
    return CallFuncList( Product, List( Components( twocell ), Range ) );
    
end );

##
InstallMethodWithCacheFromObject( HorizontalPreCompose,
                                  [ IsCapCategoryProductTwoCellRep, IsCapCategoryProductTwoCellRep ],
               
  function( twocell_left, twocell_right )
    local left_comp, right_comp;
    
    left_comp := Components( twocell_left );
    
    right_comp := Components( twocell_right );
    
    return CallFuncList( Product, List( [ 1 .. Length( twocell_left ) ], i -> HorizontalPreCompose( left_comp[ i ], right_comp[ i ] ) ) );
    
end );

##
InstallMethodWithCacheFromObject( VerticalPreCompose,
                                  [ IsCapCategoryProductTwoCellRep, IsCapCategoryProductTwoCellRep ],
               
  function( twocell_left, twocell_right )
    local left_comp, right_comp;
    
    left_comp := Components( twocell_left );
    
    right_comp := Components( twocell_right );
    
    return CallFuncList( Product, List( [ 1 .. Length( twocell_left ) ], i -> VerticalPreCompose( left_comp[ i ], right_comp[ i ] ) ) );
    
end );


###################################
##
## Functors on the product category
##
###################################

##
InstallMethodWithCache( DirectProductFunctor,
                        [ IsCapCategory, IsInt ],
               
  function( category, number_of_arguments )
    local direct_product_functor;
    
    direct_product_functor := CapFunctor( 
      Concatenation( "direct_product_on_", Name( category ), "_for_", String( number_of_arguments ), "_arguments" ),
      CallFuncList( Product, List( [ 1 .. number_of_arguments ], c -> category ) ), 
      category 
    );
    
    AddObjectFunction( direct_product_functor,
    
      function( object )
        
        return CallFuncList( DirectProduct, Components( object ) );
        
    end );
    
    AddMorphismFunction( direct_product_functor,
    
      function( new_source, morphism_list, new_range )
        local source, new_source_list;
        
        new_source_list := List( morphism_list, Source );
        
        source := List( [ 1 .. number_of_arguments ], i -> 
                        PreCompose( ProjectionInFactorOfDirectProduct( new_source_list, i ), morphism_list[i] ) );
        
        return CallFuncList( UniversalMorphismIntoDirectProduct, source );
        
   end );
   
   return direct_product_functor;
   
end );

##
InstallMethodWithCache( CoproductFunctor,
                        [ IsCapCategory, IsInt ],
               
  function( category, number_of_arguments )
    local coproduct_functor;
    
    coproduct_functor := CapFunctor( 
      Concatenation( "coproduct_on_", Name( category ), "_for_", String( number_of_arguments ), "_arguments" ),
      CallFuncList( Product, List( [ 1 .. number_of_arguments ], c -> category ) ), 
      category 
    );
    
    AddObjectFunction( coproduct_functor,
    
      function( object )
        
        return Coproduct( Components( object ) );
        
    end );
    
    AddMorphismFunction( coproduct_functor,
    
      function( new_source, morphism_list, new_range )
        local sink, new_range_list;
        
        new_range_list := List( morphism_list, Range );
        
        sink := List( [ 1 .. number_of_arguments ], i -> 
                      PreCompose( morphism_list[i], InjectionOfCofactorOfCoproduct( new_range_list, i ) ) );
        
        return CallFuncList( UniversalMorphismFromCoproduct, sink );
        
   end );
   
   return coproduct_functor;
   
end );

###################################
##
## Section Some hacks
##
###################################

BindGlobal( "CAP_INTERNAL_PRODUCT_SAVE", Product );

MakeReadWriteGlobal( "Product" );

## HEHE!
Product := function( arg )
  
  if ( ForAll( arg, IsCapCategory ) or ForAll( arg, IsCapCategoryObject ) or ForAll( arg, IsCapCategoryMorphism ) ) and Length( arg ) > 0 then
      
      return ProductOp( arg, arg[ 1 ] );
      
  fi;
  
  return CallFuncList( CAP_INTERNAL_PRODUCT_SAVE, arg );
  
end;

MakeReadOnlyGlobal( "Product" );

##
InstallMethod( IsEqualForCache,
               [ IsCapCategory and IsCapProductCategory, IsCapCategory and IsCapProductCategory ],
               
  function( category1, category2 )
    local list1, list2, length;
    
    list1 := Components( category1 );
    
    list2 := Components( category2 );
    
    length := Length( list1 );
    
    if length <> Length( list2 ) then
        
        return false;
        
    fi;
    
    return ForAll( [ 1 .. length ], i -> IsEqualForCache( list1[ i ], list2[ i ] ) );
    
end );

##
InstallMethod( IsEqualForCache,
               [ IsCapCategoryProductCellRep, IsCapCategoryProductCellRep ],
               
  function( obj1, obj2 )
    local list1, list2, length;
    
    list1 := Components( obj1 );
    
    list2 := Components( obj2 );
    
    length := Length( list1 );
    
    if length <> Length( list2 ) then
        
        return false;
        
    fi;
    
    return ForAll( [ 1 .. length ], i -> IsEqualForCache( list1[ i ], list2[ i ] ) );
    
end );
