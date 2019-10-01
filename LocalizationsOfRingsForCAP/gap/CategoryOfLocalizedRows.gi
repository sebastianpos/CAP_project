#############################################################################
##
##  Copyright 2019, Sebastian Posur, University of Siegen
##
#############################################################################

####################################
##
## Constructors
##
####################################

##
InstallMethod( CategoryOfLocalizedRows,
               [ IsHomalgRing, IsFunction ],
               
  function( homalg_ring, witness_tester_function )
    local category, to_be_finalized;
    
    if not ( HasIsCommutative( homalg_ring ) and IsCommutative( homalg_ring ) ) then
      
      Error( "the ring must be commutative" );
    
    fi;
    
    category := CreateCapCategory( Concatenation( "LocRows( ", RingName( homalg_ring )," )"  ) );
    
    SetFilterObj( category, IsCategoryOfLocalizedRows );
    
    SetIsAdditiveCategory( category, true );
    
    SetUnderlyingRing( category, homalg_ring );
    
    AddObjectRepresentation( category, IsCategoryOfLocalizedRowsObject );
    
    AddMorphismRepresentation( category, IsCategoryOfLocalizedRowsMorphism );
    
    INSTALL_FUNCTIONS_FOR_CATEGORY_OF_LOCALIZED_ROWS( category );
    
    to_be_finalized := ValueOption( "FinalizeCategory" );
      
    if to_be_finalized = false then
      
      return category;
    
    fi;
    
    Finalize( category );
    
    return category;
    
end );

##
InstallMethod( CategoryOfLocalizedRowsObjectOp,
               [ IsCategoryOfLocalizedRows, IsInt ],
               
  function( category, rank )
    local object;
    
    if rank < 0 then
      
      return Error( "first argument must be a non-negative integer" );
      
    fi;
    
    object := rec( );
    
    ObjectifyObjectForCAPWithAttributes( object,
                                         category,
                                         RankOfObject, rank
    );
    
    return object;
    
end );


##
InstallMethod( AsCategoryOfLocalizedRowsMorphism,
               [ IsHomalgMatrix, IsCategoryOfLocalizedRows ],
               
  function( homalg_matrix, category )
    local ring, source, range;
    
    ring := UnderlyingRing( category );
    
    source := CategoryOfLocalizedRowsObject( category, NrRows( homalg_matrix ) );
    
    range := CategoryOfLocalizedRowsObject( category, NrColumns( homalg_matrix ) );
    
    return CategoryOfLocalizedRowsMorphism( source, homalg_matrix, One( ring ), range );
    
end );

##
InstallMethod( CategoryOfLocalizedRowsMorphism,
               [ IsCategoryOfLocalizedRowsObject, IsHomalgMatrix, IsHomalgRingElement, IsCategoryOfLocalizedRowsObject ],
               
  function( source, homalg_matrix, denominator, range )
    local morphism, homalg_ring, category;
    
    category := CapCategory( source );
    
    if not IsIdenticalObj( category, CapCategory( range ) ) then
      
      return Error( "source and range are not defined over identical categories" );
      
    fi;
    
    homalg_ring := HomalgRing( homalg_matrix );
    
    if not IsIdenticalObj( homalg_ring, UnderlyingRing( category ) ) then
      
      return Error( "the matrix is defined over a different ring than the objects" );
      
    fi;
    
    if NrRows( homalg_matrix ) <> RankOfObject( source ) then
      
      return Error( "the number of rows has to be equal to the rank of the source" );
      
    fi;
    
    if NrColumns( homalg_matrix ) <> RankOfObject( range ) then
      
      return Error( "the number of columns has to be equal to the rank of the range" );
      
    fi;
    
    morphism := rec( );
    
    ObjectifyMorphismForCAPWithAttributes( morphism, category,
                                           Source, source,
                                           Range, range,
                                           NumeratorOfLocalizedRowsMorphism, homalg_matrix,
                                           DenominatorOfLocalizedRowsMorphism, denominator
    );
    
    return morphism;
    
end );

# ####################################
# ##
# ## Basic operations
# ##
# ####################################


InstallGlobalFunction( INSTALL_FUNCTIONS_FOR_CATEGORY_OF_LOCALIZED_ROWS,
  
  function( category )
    local ring, one, minusone, is_integral_domain,
    CATEGORY_OF_LOCALIZED_ROWS_denominator_helper_function, CATEGORY_OF_LOCALIZED_ROWS_binary_application;
    
    ring := UnderlyingRing( category );
    
    one := One( ring );
    
    minusone := MinusOne( ring );
    
    is_integral_domain := HasIsIntegralDomain( ring ) and IsIntegralDomain( ring );
    
    ##
    AddIsEqualForCacheForObjects( category,
      IsIdenticalObj );
    
    ##
    AddIsEqualForCacheForMorphisms( category,
      IsIdenticalObj );

    
    ## Well-defined for objects and morphisms
    ##
    AddIsWellDefinedForObjects( category,
      function( object )
        
        if not IsIdenticalObj( category, CapCategory( object ) ) then
          
          return false;
          
        elif RankOfObject( object ) < 0 then
          
          return false;
          
        fi;
        
        # all tests passed, so it is well-defined
        return true;
        
    end );
    
    ##
    AddIsWellDefinedForMorphisms( category,
      function( morphism )
        
        if not IsIdenticalObj( category, CapCategory( Source( morphism ) ) ) then
          
          return false;
          
        elif not IsIdenticalObj( category, CapCategory( morphism ) ) then
          
          return false;
          
        elif not IsIdenticalObj( category, CapCategory( Range( morphism ) ) ) then
          
          return false;
          
        elif NrRows( NumeratorOfLocalizedRowsMorphism( morphism ) ) <> RankOfObject( Source( morphism ) ) then
          
          return false;
          
        elif NrColumns( NumeratorOfLocalizedRowsMorphism( morphism ) ) <> RankOfObject( Range( morphism ) ) then
          
          return false;
          
        elif not DenominatorOfLocalizedRowsMorphism( morphism ) in ring then
          
          return false;
          
        fi;
        
        if is_integral_domain then
            
            if IsZero( DenominatorOfLocalizedRowsMorphism( morphism ) ) then
                
                return false;
                
            fi;
            
        else
            
            ## TODO: Add test
            
        fi;
        
        # all tests passed, so it is well-defined
        return true;
        
    end );
    
    ## Equality Basic Operations for Objects and Morphisms
    ##
    AddIsEqualForObjects( category,
      function( object_1, object_2 )
      
        return RankOfObject( object_1 ) = RankOfObject( object_2 );
      
    end );
    
    ##
    AddIsEqualForMorphisms( category,
      function( morphism_1, morphism_2 )
        
        return ( NumeratorOfLocalizedRowsMorphism( morphism_1 ) = NumeratorOfLocalizedRowsMorphism( morphism_2 ) )
               and
               ( DenominatorOfLocalizedRowsMorphism( morphism_1 ) = DenominatorOfLocalizedRowsMorphism( morphism_2 ) );
        
    end );
    
    ##
    
    if is_integral_domain then
        
        AddIsCongruentForMorphisms( category,
        function( morphism_1, morphism_2 )
            
            return DenominatorOfLocalizedRowsMorphism( morphism_2 ) * NumeratorOfLocalizedRowsMorphism( morphism_1 )
                    = 
                DenominatorOfLocalizedRowsMorphism( morphism_1 ) * NumeratorOfLocalizedRowsMorphism( morphism_2 );
            
        end );
        
    fi;
    
    ## Basic Operations for a Category
    ##
    AddIdentityMorphism( category,
      
      function( object )
        
        return CategoryOfLocalizedRowsMorphism( object,
                                                HomalgIdentityMatrix( RankOfObject( object ), ring ),
                                                one,
                                                object );
        
    end );
    
    ##
    AddPreCompose( category,
      
      [
        [ function( morphism_1, morphism_2 )
            local num_matrix, denominator;
            
            num_matrix := NumeratorOfLocalizedRowsMorphism( morphism_1 ) * NumeratorOfLocalizedRowsMorphism( morphism_2 );
            
            denominator := DenominatorOfLocalizedRowsMorphism( morphism_1 ) * DenominatorOfLocalizedRowsMorphism( morphism_2 );
            
            return CategoryOfLocalizedRowsMorphism( Source( morphism_1 ), num_matrix, denominator, Range( morphism_2 ) );
            
          end, [ , ] ],
        
        [ function( left_morphism, identity_morphism )
            
            return left_morphism;
            
          end, [ , IsIdenticalToIdentityMorphism ] ],
        
        [ function( identity_morphism, right_morphism )
            
            return right_morphism;
            
          end, [ IsIdenticalToIdentityMorphism, ] ],
        
      ]
    
    );
    
    # ## Basic Operations for an Additive Category
    
    if is_integral_domain then
        ##
        AddIsZeroForMorphisms( category,
        function( morphism )
            
            return IsZero( NumeratorOfLocalizedRowsMorphism( morphism ) );
            
        end );
        
    fi;
    
    ##
    AddAdditionForMorphisms( category,
      function( morphism_1, morphism_2 )
        local num1, den1, num2, den2;
        
        num1 := NumeratorOfLocalizedRowsMorphism( morphism_1 );
        
        num2 := NumeratorOfLocalizedRowsMorphism( morphism_2 );
        
        den1 := DenominatorOfLocalizedRowsMorphism( morphism_1 );
        
        den2 := DenominatorOfLocalizedRowsMorphism( morphism_2 );
        
        return CategoryOfLocalizedRowsMorphism(
                Source( morphism_1 ),
                den2 * num1 + den1 * num2,
                den1 * den2,
                Range( morphism_2 ) 
        );
        
    end );
    
    ##
    AddAdditiveInverseForMorphisms( category,
      function( morphism )
        
        return CategoryOfLocalizedRowsMorphism(
                Source( morphism ),
                NumeratorOfLocalizedRowsMorphism( morphism ),
                minusone * DenominatorOfLocalizedRowsMorphism( morphism ),
                Range( morphism ) );
        
    end );
    
    ##
    AddZeroMorphism( category,
      function( source, range )
        
        return CategoryOfLocalizedRowsMorphism(
                 source,
                 HomalgZeroMatrix( RankOfObject( source ), RankOfObject( range ), ring ),
                 one,
                 range );
        
    end );
    
    ##
    AddZeroObject( category,
      function( )
        
        return CategoryOfLocalizedRowsObject( category, 0 );
        
    end );
    
    ##
    AddUniversalMorphismIntoZeroObjectWithGivenZeroObject( category,
      function( sink, zero_object )
        local morphism;
        
        morphism := CategoryOfLocalizedRowsMorphism( sink, HomalgZeroMatrix( RankOfObject( sink ), 0, ring ), one, zero_object );
        
        return morphism;
        
    end );
    
    ##
    AddUniversalMorphismFromZeroObjectWithGivenZeroObject( category,
      function( source, zero_object )
        local morphism;
        
        morphism := CategoryOfLocalizedRowsMorphism( zero_object, HomalgZeroMatrix( 0, RankOfObject( source ), ring ), one, source );
        
        return morphism;
        
    end );
    
    ##
    AddDirectSum( category,
      function( object_list )
      local rank;
      
      rank := Sum( List( object_list, object -> RankOfObject( object ) ) );
      
      return CategoryOfLocalizedRowsObject( category, rank );
      
    end );
    
#     ## TODO
#     AddDirectSumFunctorialWithGivenDirectSums( category,
#       function( direct_sum_source, diagram, direct_sum_range )
        
#         return CategoryOfLocalizedRowsMorphism( direct_sum_source,
#                                        DiagMat( List( diagram, mor -> NumeratorOfLocalizedRowsMorphism( mor ) ) ),
#                                        direct_sum_range );
        
#     end );
    
    ##
    AddProjectionInFactorOfDirectSumWithGivenDirectSum( category,
      function( object_list, projection_number, direct_sum_object )
        local rank_pre, rank_post, rank_factor, number_of_objects, projection_in_factor;
        
        number_of_objects := Length( object_list );
        
        rank_pre := Sum( object_list{ [ 1 .. projection_number - 1 ] }, c -> RankOfObject( c ) );
        
        rank_post := Sum( object_list{ [ projection_number + 1 .. number_of_objects ] }, c -> RankOfObject( c ) );
        
        rank_factor := RankOfObject( object_list[ projection_number ] );
        
        projection_in_factor := HomalgZeroMatrix( rank_pre, rank_factor, ring );
        
        projection_in_factor := UnionOfRows( projection_in_factor, 
                                             HomalgIdentityMatrix( rank_factor, ring ) );
        
        projection_in_factor := UnionOfRows( projection_in_factor, 
                                             HomalgZeroMatrix( rank_post, rank_factor, ring ) );
        
        return CategoryOfLocalizedRowsMorphism( direct_sum_object, projection_in_factor, one, object_list[ projection_number ] );
        
    end );
    
    ## Input: X_list = [ [ x_1, ..., x_r ], x ]
    ##      : Y_list = [ [ y_1, ..., y_s ], y ]
    ## Output:
    ## [ [ x_1 * y, ..., x_r * y, y_1 * x, ... y_s * x ], x * y ]
    CATEGORY_OF_LOCALIZED_ROWS_denominator_helper_function := function( X_list, Y_list )
    
      return [ Concatenation( X_list[1] * Y_list[2], Y_list[1] * X_list[2] ), X_list[2] * Y_list[2] ];
    
    end;
    
    ## Input: list = [ a_1, ..., a_r ]
    ##      :    f = function 
    CATEGORY_OF_LOCALIZED_ROWS_binary_application := function( list, f )
      local size, new_list, i;
      
      while true do
        
        size := Size( list );
        
        if size = 1 then
          return list;
        elif size = 2 then
          return f( list[1], list[2] );
        fi;
        
        new_list := [];
        i := 1;
        
        while i < size do
          Add( new_list, f( list[i], list[i+1]) );
          i := i + 2;
        od;
        
        if i = size then
          Add( new_list, list[size] );
        fi;
        
        list := new_list;
        
      od;
      
    end;
    
    ##
    AddUniversalMorphismIntoDirectSumWithGivenDirectSum( category,
      function( diagram, source, direct_sum )
        local denominators, matrix;
        
        ## Init
        ## [ [ 1 ], d_1 ], ..., [ [ 1 ], d_n ]
        denominators := List( source, t -> [ [ one ], DenominatorOfLocalizedRowsMorphism( t ) ] );
        
        denominators := 
          CATEGORY_OF_LOCALIZED_ROWS_binary_application( denominators, CATEGORY_OF_LOCALIZED_ROWS_denominator_helper_function );
        
        matrix :=
          UnionOfColumns(
            List( [ 1 .. Size( source ) ], i -> denominators[1][i] * NumeratorOfLocalizedRowsMorphism( source[i] ) )
        );
        
        return CategoryOfLocalizedRowsMorphism( Source( source[1] ), matrix, denominators[2], direct_sum );
      
    end );
    
    ##
    AddInjectionOfCofactorOfDirectSumWithGivenDirectSum( category,
      function( object_list, injection_number, coproduct )
        local rank_pre, rank_post, rank_cofactor, number_of_objects, injection_of_cofactor;
        
        number_of_objects := Length( object_list );
        
        rank_pre := Sum( object_list{ [ 1 .. injection_number - 1 ] }, c -> RankOfObject( c ) );
        
        rank_post := Sum( object_list{ [ injection_number + 1 .. number_of_objects ] }, c -> RankOfObject( c ) );
        
        rank_cofactor := RankOfObject( object_list[ injection_number ] );
        
        # now construct the mapping matrix
        injection_of_cofactor := HomalgZeroMatrix( rank_cofactor, rank_pre ,ring );
        
        injection_of_cofactor := UnionOfColumns( injection_of_cofactor, 
                                             HomalgIdentityMatrix( rank_cofactor, ring ) );
        
        injection_of_cofactor := UnionOfColumns( injection_of_cofactor, 
                                             HomalgZeroMatrix( rank_cofactor, rank_post, ring ) );
        
        return CategoryOfLocalizedRowsMorphism( object_list[ injection_number ], injection_of_cofactor, one, coproduct );
        
    end );
    
    ##
    AddUniversalMorphismFromDirectSumWithGivenDirectSum( category,
      function( diagram, sink, direct_sum )
        local denominators, matrix;
        
        ## Init
        ## [ [ 1 ], d_1 ], ..., [ [ 1 ], d_n ]
        denominators := List( sink, t -> [ [ one ], DenominatorOfLocalizedRowsMorphism( t ) ] );
        
        denominators := 
          CATEGORY_OF_LOCALIZED_ROWS_binary_application( denominators, CATEGORY_OF_LOCALIZED_ROWS_denominator_helper_function );
        
        matrix :=
          UnionOfRows(
            List( [ 1 .. Size( sink ) ], i -> denominators[1][i] * NumeratorOfLocalizedRowsMorphism( sink[i] ) )
        );
        
        return CategoryOfLocalizedRowsMorphism( direct_sum, matrix, denominators[2], Range( sink[1] ) );
      
    end );
    
#     ## Operations important for Freyd categories
    
    AddWeakKernelEmbedding( category,
      function( morphism )
        local homalg_matrix;
        
        homalg_matrix := ReducedSyzygiesOfRows( NumeratorOfLocalizedRowsMorphism( morphism ) );
        
        return CategoryOfLocalizedRowsMorphism( CategoryOfLocalizedRowsObject( category, NrRows( homalg_matrix ) ), homalg_matrix, one, Source( morphism ) );
        
    end );
    
    if is_integral_domain then
      
      AddWeakKernelLift( category,
        function( morphism, test_morphism )
          local weak_kernel_emb, alpha, tau;
          
          weak_kernel_emb := WeakKernelEmbedding( morphism );
          
          alpha := NumeratorOfLocalizedRowsMorphism( weak_kernel_emb );
          
          tau := NumeratorOfLocalizedRowsMorphism( test_morphism );
          
          return CategoryOfLocalizedRowsMorphism(
            Source( test_morphism ),
            RightDivide( tau, alpha ),
            DenominatorOfLocalizedRowsMorphism( test_morphism ),
            Source( weak_kernel_emb )
          );
          
      end );
      
    fi;
    
    ##
    AddWeakCokernelProjection( category,
      function( morphism )
        local homalg_matrix;
        
        homalg_matrix := ReducedSyzygiesOfColumns( NumeratorOfLocalizedRowsMorphism( morphism ) );
        
        return CategoryOfLocalizedRowsMorphism( Range( morphism ), homalg_matrix, one, CategoryOfLocalizedRowsObject( category, NrColumns( homalg_matrix ) ) );
        
    end );
    
    if is_integral_domain then
      
      AddWeakCokernelColift( category,
        function( morphism, test_morphism )
          local weak_cok_proj, alpha, tau;
          
          weak_cok_proj := WeakCokernelProjection( morphism );
          
          alpha := NumeratorOfLocalizedRowsMorphism( weak_cok_proj );
          
          tau := NumeratorOfLocalizedRowsMorphism( test_morphism );
          
          return CategoryOfLocalizedRowsMorphism(
            Range( weak_cok_proj ),
            LeftDivide( alpha, tau ),
            DenominatorOfLocalizedRowsMorphism( test_morphism ),
            Range( test_morphism )
          );
          
      end );
      
    fi;
    
    ##
    AddProjectionOfBiasedWeakFiberProduct( category,
      function( morphism_1, morphism_2 )
        local homalg_matrix;
        
        homalg_matrix := ReducedSyzygiesOfRows( NumeratorOfLocalizedRowsMorphism( morphism_1 ), NumeratorOfLocalizedRowsMorphism( morphism_2 ) );
        
        return CategoryOfLocalizedRowsMorphism( CategoryOfLocalizedRowsObject( category, NrRows( homalg_matrix ) ), homalg_matrix, one, Source( morphism_1 ) );
        
    end );
    
## TODO: Lifts and Colifts
#     ##
#     AddIsLiftable( category,
#       function( alpha, beta )
        
#         return IsZero( DecideZeroRows( NumeratorOfLocalizedRowsMorphism( alpha ), NumeratorOfLocalizedRowsMorphism( beta ) ) )
        
#     end );
    
#     ##
#     AddLift( category,
#       function( alpha, beta )
#         local right_divide;
        
#         right_divide := RightDivide( NumeratorOfLocalizedRowsMorphism( alpha ), NumeratorOfLocalizedRowsMorphism( beta ) )
        
#         if right_divide = fail then
          
#           return fail;
          
#         fi;
        
#         return CategoryOfLocalizedRowsMorphism( Source( alpha ), right_divide, Source( beta ) );
        
#     end );
    
    ##
    AddInjectionOfBiasedWeakPushout( category,
        function( morphism_1, morphism_2 )
        local homalg_matrix;
        
        homalg_matrix := ReducedSyzygiesOfColumns( NumeratorOfLocalizedRowsMorphism( morphism_1 ), NumeratorOfLocalizedRowsMorphism( morphism_2 ) );
        
        return CategoryOfLocalizedRowsMorphism( Range( morphism_1 ), homalg_matrix, one, CategoryOfLocalizedRowsObject( category, NrColumns( homalg_matrix ) ) );
        
    end );
    
#     ##
#     AddIsColiftable( category,
#       function( alpha, beta )
        
#         return IsZero( DecideZeroColumns( NumeratorOfLocalizedRowsMorphism( beta ), NumeratorOfLocalizedRowsMorphism( alpha ) ) )
        
#     end );
    
#     ##
#     AddColift( category,
#       function( alpha, beta )
#         local left_divide;
        
#         left_divide := LeftDivide( NumeratorOfLocalizedRowsMorphism( alpha ), NumeratorOfLocalizedRowsMorphism( beta ) )
        
#         if left_divide = fail then
          
#           return fail;
          
#         fi;
        
#         return CategoryOfLocalizedRowsMorphism( Range( alpha ), left_divide, Range( beta ) );
        
#     end );
    
#     ## Basic Operation Properties
#     ##
    AddIsZeroForObjects( category,
      function( object )
      
        return RankOfObject( object ) = 0;
      
      end );
    
#     ## Operations related to homomorphism structure

        SetRangeCategoryOfHomomorphismStructure( category, category );
        
        ##
        AddHomomorphismStructureOnObjects( category,
          function( object_1, object_2 )
            
            return CategoryOfLocalizedRowsObject( category, RankOfObject( object_1 ) * RankOfObject( object_2 ) );
            
        end );
        
        ##
        AddHomomorphismStructureOnMorphismsWithGivenObjects( category,
          function( source, alpha, beta, range )
            
            return CategoryOfLocalizedRowsMorphism(
                    source,
                    KroneckerMat( TransposedMatrix( NumeratorOfLocalizedRowsMorphism( alpha ) ), NumeratorOfLocalizedRowsMorphism( beta ) ),
                    DenominatorOfLocalizedRowsMorphism( alpha ) * DenominatorOfLocalizedRowsMorphism( beta ),
                    range );
            
        end );
        
        ##
        AddDistinguishedObjectOfHomomorphismStructure( category,
          function( )
            
            return CategoryOfLocalizedRowsObject( category, 1 );
            
        end );
        
        ##
        AddInterpretMorphismAsMorphismFromDinstinguishedObjectToHomomorphismStructure( category,
          function( alpha )
            local underlying_matrix, nr_rows;
            
            underlying_matrix := NumeratorOfLocalizedRowsMorphism( alpha );
            
            nr_rows := NrRows( underlying_matrix );
            
            if ( nr_rows = 0 ) or ( NrColumns( underlying_matrix ) = 0 ) then
                
                return UniversalMorphismIntoZeroObject( DistinguishedObjectOfHomomorphismStructure( category ) );
                
            elif nr_rows > 1 then
                
                underlying_matrix := Iterated( List( [ 1 .. nr_rows ], i -> CertainRows( underlying_matrix, [ i ] ) ), UnionOfColumns );
                
            fi;
            
            return CategoryOfLocalizedRowsMorphism(
                     DistinguishedObjectOfHomomorphismStructure( category ),
                     underlying_matrix,
                     DenominatorOfLocalizedRowsMorphism( alpha ),
                     HomomorphismStructureOnObjects( Source( alpha ), Range( alpha ) )
                   );
            
        end );
        
        ##
        AddInterpretMorphismFromDinstinguishedObjectToHomomorphismStructureAsMorphism( category,
          function( A, B, morphism )
            local nr_rows, nr_columns, underlying_matrix;
            
            nr_rows := RankOfObject( A );
            
            nr_columns := RankOfObject( B );
            
            if nr_rows = 0 or nr_columns = 0 then
                
                return ZeroMorphism( A, B );
                
            fi;
            
            underlying_matrix := NumeratorOfLocalizedRowsMorphism( morphism );
            
            underlying_matrix := Iterated( List( [ 1 .. nr_rows ], i -> CertainColumns( underlying_matrix, [ ((i - 1) * nr_columns + 1) .. i * nr_columns ] ) ), UnionOfRows );
            
            return CategoryOfLocalizedRowsMorphism( A, underlying_matrix, DenominatorOfLocalizedRowsMorphism( morphism ), B );
            
        end );
    
end );

# ####################################
# ##
# ## View
# ##
# ####################################

##
InstallMethod( Display,
               [ IsCategoryOfLocalizedRowsMorphism ],
               
  function( morphism )
    
    # source
    Print(  );
    
    # mapping matrix
    Display( "Numerator:" );
    Display( NumeratorOfLocalizedRowsMorphism( morphism ) );
    Print( "\n" );
    Display( "Denominator:" );
    Display( DenominatorOfLocalizedRowsMorphism( morphism ) );
    Print( "\n" );
    Display( "Type:" );
    # range
    Print( 
        String( RankOfObject( Source( morphism ) ) ), " -> ",
        String( RankOfObject( Range( morphism ) ) )
    );
    
end );

##
InstallMethod( String,
              [ IsCategoryOfLocalizedRowsObject ],
              
  function( category_of_rows_object )
    
    return Concatenation( "A row over a localization of ",
                          RingName( UnderlyingRing( CapCategory( category_of_rows_object ) ) ),
                          " of rank ", String( RankOfObject( category_of_rows_object ) ) );
    
end );
##
InstallMethod( ViewObj,
               [ IsCategoryOfLocalizedRowsObject ],

  function( category_of_rows_object )

    Print( Concatenation( "<", String( category_of_rows_object ), ">" ) );

end );

##
InstallMethod( Display,
               [ IsCategoryOfLocalizedRowsObject ],
               
  function( category_of_rows_object )
    
    Print( String( category_of_rows_object ) );
    
end );
