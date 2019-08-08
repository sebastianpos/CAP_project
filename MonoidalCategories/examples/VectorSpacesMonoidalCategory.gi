LoadPackage( "MonoidalCategories" );

LoadPackage( "MatricesForHomalg" );

###################################
##
## Technical stuff
##
###################################

BindGlobal( "VectorSpacesConstructorsLoaded", true );

###################################
##
## Types and Representations
##
###################################

DeclareRepresentation( "IsHomalgRationalVectorSpaceRep",
                       IsCapCategoryObjectRep,
                       [ ] );

BindGlobal( "TheTypeOfHomalgRationalVectorSpaces",
        NewType( TheFamilyOfCapCategoryObjects,
                IsHomalgRationalVectorSpaceRep ) );

DeclareRepresentation( "IsHomalgRationalVectorSpaceMorphismRep",
                       IsCapCategoryMorphismRep,
                       [ ] );

BindGlobal( "TheTypeOfHomalgRationalVectorSpaceMorphism",
        NewType( TheFamilyOfCapCategoryMorphisms,
                IsHomalgRationalVectorSpaceMorphismRep ) );

###################################
##
## Attributes
##
###################################
                
DeclareAttribute( "Dimension",
                  IsHomalgRationalVectorSpaceRep );

#######################################
##
## Operations
##
#######################################

DeclareOperation( "QVectorSpace",
                  [ IsInt ] );

DeclareOperation( "VectorSpaceMorphism",
                  [ IsHomalgRationalVectorSpaceRep, IsObject, IsHomalgRationalVectorSpaceRep ] );

##NOTE: the other test files will rewrite the global variable vecspaces.
##this has an effect on the constructors below!
vecspaces := CreateCapCategory( "VectorSpacesMonoidalCategory" );

## set all properties of the category in the beginning 
SetIsAbelianCategory( vecspaces, true );

SetIsStrictMonoidalCategory( vecspaces, true );

SetIsRigidSymmetricClosedMonoidalCategory( vecspaces, true );
##

VECTORSPACES_FIELD := HomalgFieldOfRationals( );
# ActivateDerivationInfo();
#######################################
##
## Categorical Implementations
##
#######################################

##
InstallMethod( QVectorSpace,
               [ IsInt ],
               
  function( dim )
    local space;
    
    space := rec( );
    
    ObjectifyWithAttributes( space, TheTypeOfHomalgRationalVectorSpaces,
                             Dimension, dim 
    );

    # is this the right place?
    Add( vecspaces, space );
    
    return space;
    
end );

##
InstallMethod( VectorSpaceMorphism,
                  [ IsHomalgRationalVectorSpaceRep, IsObject, IsHomalgRationalVectorSpaceRep ],
                  
  function( source, matrix, range )
    local morphism;

    if not IsHomalgMatrix( matrix ) then
    
      morphism := HomalgMatrix( matrix, Dimension( source ), Dimension( range ), VECTORSPACES_FIELD );

    else

      morphism := matrix;

    fi;

    morphism := rec( morphism := morphism );
    
    
    ObjectifyWithAttributes( morphism, TheTypeOfHomalgRationalVectorSpaceMorphism,
                             Source, source,
                             Range, range 
    );

    Add( vecspaces, morphism );
    
    return morphism;
    
end );


#######################################
##
## View and Display
##
#######################################

InstallMethod( ViewObj,
               [ IsHomalgRationalVectorSpaceRep ],

  function( obj )

    Print( "<A rational vector space of dimension ", String( Dimension( obj ) ), ">" );

end );

InstallMethod( ViewObj,
               [ IsHomalgRationalVectorSpaceMorphismRep ],

  function( obj )

    Print( "A rational vector space homomorphism with matrix: \n" );
# 
#     Print( String( obj!.morphism ) );
  
    Display( obj!.morphism );

end );

SetIsAbelianCategory( vecspaces, true );

AddIsCongruentForMorphisms( vecspaces,

  function( a, b )
  
    return a!.morphism = b!.morphism;
  
end );

AddIsEqualForObjects( vecspaces,

  function( a, b )
  
    return Dimension( a ) = Dimension( b );
  
end );

AddIsZeroForMorphisms( vecspaces,

  function( a )
    
    return IsZero( a!.morphism );
    
end );

AddAdditionForMorphisms( vecspaces,
                         
  function( a, b )
    
    return VectorSpaceMorphism( Source( a ), a!.morphism + b!.morphism, Range( a ) );
    
end );

AddAdditiveInverseForMorphisms( vecspaces,
                                
  function( a )
    
    return VectorSpaceMorphism( Source( a ), - a!.morphism, Range( a ) );
    
end );

AddZeroMorphism( vecspaces,
                     
  function( a, b )
    
    return VectorSpaceMorphism( a, HomalgZeroMatrix( Dimension( a ), Dimension( b ), VECTORSPACES_FIELD ), b );
    
end );

##
AddIdentityMorphism( vecspaces,
                     
  function( obj )
#     return VectorSpaceMorphism( obj, IdentityMat( Dimension( obj ) ), obj );
    return VectorSpaceMorphism( obj, HomalgIdentityMatrix( Dimension( obj ), VECTORSPACES_FIELD ), obj );
    
end );

##
AddPreCompose( vecspaces,

  function( mor_left, mor_right )
    local composition;

    composition := mor_left!.morphism * mor_right!.morphism;

    return VectorSpaceMorphism( Source( mor_left ), composition, Range( mor_right ) );

end );

##
AddZeroObject( vecspaces,

  function( )

    return QVectorSpace( 0 );

end );

##
AddLiftAlongMonomorphism( vecspaces,

  function( monomorphism, test_morphism )

    return VectorSpaceMorphism( Source( test_morphism ), RightDivide( test_morphism!.morphism, monomorphism!.morphism ), Source( monomorphism ) );

end );

##
AddColiftAlongEpimorphism( vecspaces,
  
  function( epimorphism, test_morphism )
    
    return VectorSpaceMorphism( Range( epimorphism ), LeftDivide( epimorphism!.morphism, test_morphism!.morphism ), Range( test_morphism ) );
    
end );

##
AddKernelObject( vecspaces,

  function( morphism )
    local homalg_matrix;

    homalg_matrix := morphism!.morphism;
  
    return QVectorSpace( NrRows( homalg_matrix ) - RowRankOfMatrix( homalg_matrix ) );

end );

##
AddKernelEmbedding( vecspaces,

  function( morphism )
    local kernel_emb, kernel_obj;
    
    kernel_emb := SyzygiesOfRows( morphism!.morphism );
    
    kernel_obj := QVectorSpace( NrRows( kernel_emb ) );
    
    return VectorSpaceMorphism( kernel_obj, kernel_emb, Source( morphism ) );
    
end );

##
AddKernelEmbeddingWithGivenKernelObject( vecspaces,

  function( morphism, kernel )
    local kernel_emb;

    kernel_emb := SyzygiesOfRows( morphism!.morphism );

    return VectorSpaceMorphism( kernel, kernel_emb, Source( morphism ) );

end );

##
AddCokernelObject( vecspaces,

  function( morphism )
    local homalg_matrix;

    homalg_matrix := morphism!.morphism;

    return QVectorSpace( NrColumns( homalg_matrix ) - RowRankOfMatrix( homalg_matrix ) );

end );


##
AddCokernelProjection( vecspaces,

  function( morphism )
    local cokernel_proj, cokernel_obj;

    cokernel_proj := SyzygiesOfColumns( morphism!.morphism );

    cokernel_obj := QVectorSpace( NrColumns( cokernel_proj ) );

    return VectorSpaceMorphism( Range( morphism ), cokernel_proj, cokernel_obj );

end );

##
AddCokernelProjectionWithGivenCokernelObject( vecspaces,

  function( morphism, cokernel )
    local cokernel_proj;

    cokernel_proj := SyzygiesOfColumns( morphism!.morphism );

    return VectorSpaceMorphism( Range( morphism ), cokernel_proj, cokernel );

end );

##
AddCoproduct( vecspaces,

  function( object_product_list )
    local dim;
    
    dim := Sum( List( object_product_list, c -> Dimension( c ) ) );
    
    return QVectorSpace( dim );
  
end );

##
## the user may assume that Length( object_product_list ) > 1
AddInjectionOfCofactorOfDirectSum( vecspaces,

  function( object_product_list, injection_number )
    local components, dim, dim_pre, dim_post, dim_cofactor, coproduct, number_of_objects, injection_of_cofactor;
    
    components := object_product_list;
    
    number_of_objects := Length( components );
    
    dim := Sum( components, c -> Dimension( c ) );
    
    dim_pre := Sum( components{ [ 1 .. injection_number - 1 ] }, c -> Dimension( c ) );
    
    dim_post := Sum( components{ [ injection_number + 1 .. number_of_objects ] }, c -> Dimension( c ) );
    
    dim_cofactor := Dimension( object_product_list[ injection_number ] );
    
    coproduct := QVectorSpace( dim );
    
    injection_of_cofactor := HomalgZeroMatrix( dim_cofactor, dim_pre ,VECTORSPACES_FIELD );
    
    injection_of_cofactor := UnionOfColumns( injection_of_cofactor, 
                                         HomalgIdentityMatrix( dim_cofactor, VECTORSPACES_FIELD ) );
    
    injection_of_cofactor := UnionOfColumns( injection_of_cofactor, 
                                         HomalgZeroMatrix( dim_cofactor, dim_post, VECTORSPACES_FIELD ) );
    
    return VectorSpaceMorphism( object_product_list[ injection_number ], injection_of_cofactor, coproduct );

end );

##
## the user may assume that Length( object_product_list ) > 1
AddInjectionOfCofactorOfDirectSumWithGivenDirectSum( vecspaces,

  function( object_product_list, injection_number, coproduct )
    local components, dim_pre, dim_post, dim_cofactor, number_of_objects, injection_of_cofactor;
    
    components := object_product_list;
    
    number_of_objects := Length( components );
    
    dim_pre := Sum( components{ [ 1 .. injection_number - 1 ] }, c -> Dimension( c ) );
    
    dim_post := Sum( components{ [ injection_number + 1 .. number_of_objects ] }, c -> Dimension( c ) );
    
    dim_cofactor := Dimension( object_product_list[ injection_number ] );
    
    injection_of_cofactor := HomalgZeroMatrix( dim_cofactor, dim_pre ,VECTORSPACES_FIELD );
    
    injection_of_cofactor := UnionOfColumns( injection_of_cofactor, 
                                         HomalgIdentityMatrix( dim_cofactor, VECTORSPACES_FIELD ) );
    
    injection_of_cofactor := UnionOfColumns( injection_of_cofactor, 
                                         HomalgZeroMatrix( dim_cofactor, dim_post, VECTORSPACES_FIELD ) );
    
    return VectorSpaceMorphism( object_product_list[ injection_number ], injection_of_cofactor, coproduct );

end );

##
AddUniversalMorphismFromDirectSum( vecspaces,

  function( diagram, sink )
    local dim, coproduct, components, universal_morphism, morphism;
    
    components := sink;
    
    dim := Sum( components, c -> Dimension( Source( c ) ) );
    
    coproduct := QVectorSpace( dim );
    
    universal_morphism := sink[1]!.morphism;
    
    for morphism in components{ [ 2 .. Length( components ) ] } do
    
      universal_morphism := UnionOfRows( universal_morphism, morphism!.morphism );
  
    od;
  
    return VectorSpaceMorphism( coproduct, universal_morphism, Range( sink[1] ) );
  
end );

##
AddUniversalMorphismFromDirectSumWithGivenDirectSum( vecspaces,

  function( diagram, sink, coproduct )
    local components, universal_morphism, morphism;
    
    components := sink;
    
    universal_morphism := sink[1]!.morphism;
    
    for morphism in components{ [ 2 .. Length( components ) ] } do
    
      universal_morphism := UnionOfRows( universal_morphism, morphism!.morphism );
  
    od;
  
    return VectorSpaceMorphism( coproduct, universal_morphism, Range( sink[1] ) );
  
end );

##
AddDirectSum( vecspaces,

  function( object_product_list )
    local dim;
    
    dim := Sum( List( object_product_list, c -> Dimension( c ) ) );
    
    return QVectorSpace( dim );
  
end );

#
# the user may assume that Length( object_product_list ) > 1
AddProjectionInFactorOfDirectSum( vecspaces,

  function( object_product_list, projection_number )
    local components, dim, dim_pre, dim_post, dim_factor, direct_product, number_of_objects, projection_in_factor;
    
    components := object_product_list;
    
    number_of_objects := Length( components );
    
    dim := Sum( components, c -> Dimension( c ) );
    
    dim_pre := Sum( components{ [ 1 .. projection_number - 1 ] }, c -> Dimension( c ) );
    
    dim_post := Sum( components{ [ projection_number + 1 .. number_of_objects ] }, c -> Dimension( c ) );
    
    dim_factor := Dimension( object_product_list[ projection_number ] );
    
    direct_product := QVectorSpace( dim );
    
    projection_in_factor := HomalgZeroMatrix( dim_pre, dim_factor, VECTORSPACES_FIELD );
    
    projection_in_factor := UnionOfRows( projection_in_factor, 
                                         HomalgIdentityMatrix( dim_factor, VECTORSPACES_FIELD ) );
    
    projection_in_factor := UnionOfRows( projection_in_factor, 
                                         HomalgZeroMatrix( dim_post, dim_factor, VECTORSPACES_FIELD ) );
    
    return VectorSpaceMorphism( direct_product, projection_in_factor, object_product_list[ projection_number ] );

end );

##
## the user may assume that Length( object_product_list ) > 1
AddProjectionInFactorOfDirectSumWithGivenDirectSum( vecspaces,

  function( object_product_list, projection_number, direct_product )
    local components, dim_pre, dim_post, dim_factor, number_of_objects, projection_in_factor;
    
    components := object_product_list;
    
    number_of_objects := Length( components );
    
    dim_pre := Sum( components{ [ 1 .. projection_number - 1 ] }, c -> Dimension( c ) );
    
    dim_post := Sum( components{ [ projection_number + 1 .. number_of_objects ] }, c -> Dimension( c ) );
    
    dim_factor := Dimension( object_product_list[ projection_number ] );
    
    projection_in_factor := HomalgZeroMatrix( dim_pre, dim_factor, VECTORSPACES_FIELD );
    
    projection_in_factor := UnionOfRows( projection_in_factor, 
                                         HomalgIdentityMatrix( dim_factor, VECTORSPACES_FIELD ) );
    
    projection_in_factor := UnionOfRows( projection_in_factor, 
                                         HomalgZeroMatrix( dim_post, dim_factor, VECTORSPACES_FIELD ) );
    
    return VectorSpaceMorphism( direct_product, projection_in_factor, object_product_list[ projection_number ] );

end );

AddUniversalMorphismIntoDirectSum( vecspaces,

  function( diagram, sink )
    local dim, direct_product, components, universal_morphism, morphism;
    
    components := sink;
    
    dim := Sum( components, c -> Dimension( Range( c ) ) );
    
    direct_product := QVectorSpace( dim );
    
    universal_morphism := sink[1]!.morphism;
    
    for morphism in components{ [ 2 .. Length( components ) ] } do
    
      universal_morphism := UnionOfColumns( universal_morphism, morphism!.morphism );
  
    od;
  
    return VectorSpaceMorphism( Source( sink[1] ), universal_morphism, direct_product );
  
end );

AddUniversalMorphismIntoDirectSumWithGivenDirectSum( vecspaces,

  function( diagram, sink, direct_product )
    local components, universal_morphism, morphism;
    
    components := sink;
    
    universal_morphism := sink[1]!.morphism;
    
    for morphism in components{ [ 2 .. Length( components ) ] } do
    
      universal_morphism := UnionOfColumns( universal_morphism, morphism!.morphism );
  
    od;
  
    return VectorSpaceMorphism( Source( sink[1] ), universal_morphism, direct_product );
  
end );

##
AddTerminalObject( vecspaces,

  function( )

    return QVectorSpace( 0 );

end );

##
AddUniversalMorphismIntoTerminalObject( vecspaces,

  function( sink )
    local morphism;

    morphism := VectorSpaceMorphism( sink, HomalgZeroMatrix( Dimension( sink ), 0, VECTORSPACES_FIELD ), QVectorSpace( 0 ) );

    return morphism;

end );

##
AddUniversalMorphismIntoTerminalObjectWithGivenTerminalObject( vecspaces,

  function( sink, terminal_object )
    local morphism;

    morphism := VectorSpaceMorphism( sink, HomalgZeroMatrix( Dimension( sink ), 0, VECTORSPACES_FIELD ), terminal_object );

    return morphism;

end );

##
AddInitialObject( vecspaces,

  function( )

    return QVectorSpace( 0 );

end );

##
AddUniversalMorphismFromInitialObject( vecspaces,

  function( source )
    local morphism;

    morphism := VectorSpaceMorphism( QVectorSpace( 0 ), HomalgZeroMatrix( 0, Dimension( source ), VECTORSPACES_FIELD ), source );

    return morphism;

end );

##
AddUniversalMorphismFromInitialObjectWithGivenInitialObject( vecspaces,

  function( source, initial_object )
    local morphism;

    morphism := VectorSpaceMorphism( initial_object, HomalgZeroMatrix( 0, Dimension( source ), VECTORSPACES_FIELD ), source );

    return morphism;

end );

##
AddIsWellDefinedForObjects( vecspaces,

  function( vectorspace )
  
    return IsHomalgRationalVectorSpaceRep( vectorspace ) and Dimension( vectorspace ) >= 0;
  
end );

##
AddIsWellDefinedForMorphisms( vecspaces,

  function( morphism )
    local matrix;
    
    if not IsHomalgRationalVectorSpaceMorphismRep( morphism ) then
      return false;
    fi;
    
    matrix := morphism!.morphism;
    
    return     IsHomalgMatrix( matrix )
           and NrRows( matrix ) = Dimension( Source( morphism ) )
           and NrColumns( matrix ) = Dimension( Range( morphism ) );
    
end );

AddIsZeroForObjects( vecspaces,

  function( obj )
  
    return Dimension( obj ) = 0;
  
end );

AddIsMonomorphism( vecspaces,

  function( morphism )
  
    return RowRankOfMatrix( morphism!.morphism ) = Dimension( Source( morphism ) );
  
end );

AddIsEpimorphism( vecspaces,

  function( morphism )
  
    return ColumnRankOfMatrix( morphism!.morphism ) = Dimension( Range( morphism ) );
  
end );

AddIsIsomorphism( vecspaces,

  function( morphism )
  
    return Dimension( Range( morphism ) ) = Dimension( Source( morphism ) ) 
           and ColumnRankOfMatrix( morphism!.morphism ) = Dimension( Range( morphism ) );
  
end );

##
AddImageObject( vecspaces,

  function( morphism )
  
    return QVectorSpace( RowRankOfMatrix( morphism!.morphism ) );
  
end );

##
AddTensorProductOnObjects( vecspaces,

  [ 
    [ function( object_1, object_2 )
        return QVectorSpace( Dimension( object_1 ) * Dimension( object_2 ) );
      end,
      [ ] ],
    
    [ function( object_1, object_2 )
        return object_1;
      end,
      [ IsZero, ] ],
     
    [ function( object_1, object_2 )
        return object_2;
      end,
      [ , IsZero ] ]
  ]

);

##
AddTensorProductOnMorphismsWithGivenTensorProducts( vecspaces,
  
  function( new_source, morphism_1, morphism_2, new_range )
    
    return VectorSpaceMorphism( new_source, KroneckerMat( morphism_1!.morphism, morphism_2!.morphism ), new_range );
    
end );

##
AddAssociatorRightToLeftWithGivenTensorProducts( vecspaces,
  
  function( right_associated_object, object_1, object_2, object_3, left_associated_object )
    
    return VectorSpaceMorphism( right_associated_object, 
                                HomalgIdentityMatrix( Dimension( right_associated_object ), VECTORSPACES_FIELD ), 
                                left_associated_object );
    
end );

##
AddTensorUnit( vecspaces,
  
  function( )
    
    return QVectorSpace( 1 );
    
end );

##
AddLeftUnitorWithGivenTensorProduct( vecspaces,
  
  function( object, unit_tensored_object )
    
    return VectorSpaceMorphism( unit_tensored_object, 
                                HomalgIdentityMatrix( Dimension( object ), VECTORSPACES_FIELD ), 
                                object );
    
end );

##
AddRightUnitorWithGivenTensorProduct( vecspaces,
  
  function( object, object_tensored_unit )
    
    return VectorSpaceMorphism( object_tensored_unit, 
                                HomalgIdentityMatrix( Dimension( object ), VECTORSPACES_FIELD ), 
                                object );
end );

##
AddBraidingWithGivenTensorProducts( vecspaces,
  
  function( object_1_tensored_object_2, object_1, object_2, object_2_tensored_object_1 )
    local permutation_matrix, dim, dim_1, dim_2;
    
    dim_1 := Dimension( object_1 );
    
    dim_2 := Dimension( object_2 );
    
    dim := Dimension( object_1_tensored_object_2 );
    
    permutation_matrix := PermutationMat( 
                            PermList( List( [ 1 .. dim ], i -> ( RemInt( i - 1, dim_2 ) * dim_1 + QuoInt( i - 1, dim_2 ) + 1 ) ) ),
                            dim 
                          );
    
    return VectorSpaceMorphism( object_1_tensored_object_2,
                                HomalgMatrix( permutation_matrix, dim, dim, VECTORSPACES_FIELD ),
                                object_2_tensored_object_1
                              );
    
end );

##
AddDualOnObjects( vecspaces, space -> space );

##
AddDualOnMorphismsWithGivenDuals( vecspaces,
  
  function( dual_source, morphism, dual_range )
    
    return VectorSpaceMorphism( dual_source,
                                Involution( morphism!.morphism ),
                                dual_range );
    
end );

##
AddEvaluationForDualWithGivenTensorProduct( vecspaces,
  
  function( tensor_object, object, unit )
    local dimension, row, zero_row, i;
    
    dimension := Dimension( object );
    
    row := [ ];
    
    zero_row := List( [ 1 .. dimension ], i -> 0 );
    
    for i in [ 1 .. dimension - 1 ] do
      
      Add( row, 1 );
      
      Append( row, zero_row );
      
    od;
    
    if dimension > 0 then 
      
      Add( row, 1 );
      
    fi;
    
    return VectorSpaceMorphism( tensor_object,
                                row,
                                unit );
                                
end );

##
AddCoevaluationForDualWithGivenTensorProduct( vecspaces,
  
  function( unit, object, tensor_object )
    
    local dimension, row, zero_row, i;
    
    dimension := Dimension( object );
    
    row := [ ];
    
    zero_row := List( [ 1 .. dimension ], i -> 0 );
    
    for i in [ 1 .. dimension - 1 ] do
      
      Add( row, 1 );
      
      Append( row, zero_row );
      
    od;
    
    if dimension > 0 then 
      
      Add( row, 1 );
      
    fi;
    
    return VectorSpaceMorphism( unit,
                                HomalgMatrix( row, 1, Dimension( tensor_object ), VECTORSPACES_FIELD ),
                                tensor_object );
    
end );

##
AddMorphismToBidualWithGivenBidual( vecspaces,
  
  function( object, bidual_of_object )
    
    return VectorSpaceMorphism( object,
                                HomalgIdentityMatrix( Dimension( object ), VECTORSPACES_FIELD ),
                                bidual_of_object
                              );
    
end );

Finalize( vecspaces );
