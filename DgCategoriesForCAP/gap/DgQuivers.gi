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
##
InstallMethod( DgQuiver,
               [ IsQuiverAlgebra, IsList, IsList ],
               
  function( quiver_algebra, degree, differential )
    local category, vec;
    
    category := CreateCapCategory( Concatenation( "Dg quiver( ", String( quiver_algebra )," )"  ) );
    
    category!.degree_list := degree;
    
    category!.differential_list := differential;
    
    SetFilterObj( category, IsDgQuiver );
    
    SetCommutativeRingOfDgCategory( category, LeftActingDomain( quiver_algebra ) );
    
    SetUnderlyingQuiverAlgebra( category, quiver_algebra );
    
    ## homomorphism structure
    
    vec := MatrixCategory( CommutativeRingOfDgCategory( category ) );
    
    CapCategorySwitchLogicOff( vec );
    
    DeactivateCachingOfCategory( vec );
    
    SetUnderlyingLinearCategory( category, vec );
    
    SetRangeCategoryOfHomomorphismStructure( category, DgBoundedCochainComplexCategory( vec ) );
    
    AddObjectRepresentation( category, IsDgQuiverObject );
    
    AddMorphismRepresentation( category, IsDgQuiverMorphism );
    
    DisableAddForCategoricalOperations( category );
    
    CapCategorySwitchLogicOff( category );
    
    INSTALL_FUNCTIONS_FOR_DG_QUIVERS( category, quiver_algebra, degree, differential );
    
    Finalize( category );
    
    return category;
    
end );

##
InstallMethod( DgQuiverObject,
               [ IsVertex, IsDgQuiver ],
               
  function( vertex, dg_quiver )
    local object;
    
    object := rec( );
    
    ObjectifyObjectForCAPWithAttributes(
                             object, dg_quiver,
                             UnderlyingVertex, vertex
    );
    
    Add( dg_quiver, object );
    
    return object;
    
end );

##
InstallMethod( DgQuiverMorphism,
               [ IsDgQuiverObject, IsQuiverAlgebraElement, IsDgQuiverObject, IsInt ],
  function( source, element, range, dgdegree )
    local morphism, category;
    
    morphism := rec( );
    
    category := CapCategory( source );
    
    ObjectifyMorphismForCAPWithAttributes( 
        morphism, category,
        Source, source,
        Range, range,
        DgDegree, dgdegree,
        UnderlyingQuiverAlgebraElement, element
    );

    Add( category, morphism );
    
    return morphism;
    
end );

##
InstallMethod( ObjectsOfDgQuiver,
               [ IsDgQuiver ],
               
  function( dg_quiver) 
    local vertices;
    
    vertices := Vertices( QuiverOfAlgebra( UnderlyingQuiverAlgebra( dg_quiver ) )  );
    
    return List( vertices, v -> DgQuiverObject( v, dg_quiver ) );
    
end );


InstallMethod( ArrowsOfDgQuiver,
               [ IsDgQuiver ],
               
  function( dg_quiver) 
    local A, arrows, dg_arrows, i, arrow, v, w, element;
    
    A := UnderlyingQuiverAlgebra( dg_quiver );
    
    arrows := Arrows( QuiverOfAlgebra( A )  );
    
    dg_arrows := [ ];
    
    for i in [ 1 .. Size( arrows ) ] do
      
      arrow := arrows[i];
      v := DgQuiverObject( Source( arrow ), dg_quiver );
      w := DgQuiverObject( Target( arrow ), dg_quiver );
      element := PathAsAlgebraElement( A, arrow );
      
      Add( dg_arrows,
        DgQuiverMorphism( v, element, w, dg_quiver!.degree_list[i] )
      );
      
    od;
    
    return dg_arrows;
    
end );

####################################
##
## Preparation operations
##
####################################

####################################
##
## Basic operations
##
####################################

##
InstallGlobalFunction( INSTALL_FUNCTIONS_FOR_DG_QUIVERS,
  
  function( category, quiver_algebra, degree, differential )
    local paths, DG_DIFFERENTIAL_ON_PATHS, DG_DEGREE_ON_PATHS, DG_BASIS_PATHS, DG_BASIS_PATHS_DEGREES, field;
    
    field := CommutativeRingOfDgCategory( category );
    
    # use the source-to-target specific commands to avoid case distinctions
    #
    DG_DIFFERENTIAL_ON_PATHS := function( path )
        local arrow_list, n, i, element, coefficient, pre_path, d, post_path;
        
        arrow_list := ArrowList( path ); # in source-to-target-order
        
        arrow_list := Reversed( arrow_list );
        
        n := Size( arrow_list ); # n = 0 if path is an identity path
        
        element := Zero( quiver_algebra );
        
        for i in [ 1 .. n ] do
        
        coefficient := (-1)^(Sum( [ 1 .. i - 1 ], j -> degree[ArrowNumber( arrow_list[j] )] mod 2 ) ) / field;
        
        if i > 1 then
            
            pre_path := arrow_list{[ 1 .. i - 1]};
            
            pre_path := ComposePaths( Reversed( pre_path ) );
            
            pre_path := PathAsAlgebraElement( quiver_algebra, pre_path );
            
        else
            
            pre_path := One( quiver_algebra );
            
        fi;
        
        d := differential[ ArrowNumber( arrow_list[i] ) ];
        
        if i < n then
            
            post_path := arrow_list{[ i + 1 .. n]};
            
            post_path := ComposePaths( Reversed( post_path ) );
            
            post_path := PathAsAlgebraElement( quiver_algebra, post_path );
            
        else
            
            post_path := One( quiver_algebra );
            
        fi;
        
        element := element + coefficient * ComposeElements( ComposeElements( post_path, d ), pre_path );
        
        od;
        
        return element;
        
    end;
    
    ##
    DG_DEGREE_ON_PATHS := function( path )
      local arrow_list;
      
      arrow_list := ArrowList( path );
      
      return Sum( arrow_list, a -> degree[ArrowNumber(a)] );
      
    end;
    
    AddIsEqualForCacheForObjects( category,
      IsIdenticalObj );
    
    ##
    AddIsEqualForCacheForMorphisms( category,
      IsIdenticalObj );
    
    ##
    AddIsEqualForObjects( category,
      function( v, w )
        
        return UnderlyingVertex( v ) = UnderlyingVertex( w );
        
    end );
    
    ##
    AddIsCongruentForMorphisms( category,
      function( alpha, beta )
        
        if DgDegree( alpha ) <> DgDegree( beta ) then
            
            return false;
            
        fi;
        
        return UnderlyingQuiverAlgebraElement( alpha ) = UnderlyingQuiverAlgebraElement( beta );
        
    end );
    
    ##
    AddIsWellDefinedForObjects( category,
      function( v )
        
        if not IsIdenticalObj( QuiverOfAlgebra( quiver_algebra ), QuiverOfPath( UnderlyingVertex( v ) ) ) then
            
            return false;
            
        fi;
        
        return true;
        
    end );
    
    ##
    AddIsWellDefinedForMorphisms( category,
      function( alpha )
        local element, rep, v, w, coeffs, dgdeg, paths;
        
        element := UnderlyingQuiverAlgebraElement( alpha );
        
        if not IsIdenticalObj( AlgebraOfElement( element ), quiver_algebra ) then
            
            return false;
            
        fi;
        
        if IsZero( element ) then # zero can be of any degree
            
            return true;
            
        fi;
        
        if not IsUniform( element ) then
            
            return false;
            
        fi;
        
        rep := element;
        
        if IsQuotientOfPathAlgebraElement( element ) then
            
            rep := Representative( element );
            
        fi;
        
        v := Source( LeadingPath( rep ) ); 
        
        if not ( UnderlyingVertex( Source( alpha ) ) = v ) then
            
            return false;
            
        fi;
        
        w := Target( LeadingPath( rep ) );
        
        if not ( UnderlyingVertex( Range( alpha ) ) = w ) then
            
            return false;
            
        fi;
        
        ## test the degree (also, test being homogeneous wrt. the degree)
        
        paths := Paths( element );
        
        if Size( paths ) > 0 then
            
            coeffs := Coefficients( element );
            
            dgdeg := Set( List( paths, DG_DEGREE_ON_PATHS ) );
            
            if Size( dgdeg ) > 1 then
                
                return false;
                
            elif dgdeg[1] <> DgDegree( alpha ) then
                
                return false;
                
            fi;
            
        else
            
            if DgDegree( alpha ) <> 0 then
                
                return false;
                
            fi;
            
        fi;
        
        # all tests passed, so it is well-defined
        return true;
        
    end );
    
    ##
    AddIdentityMorphism( category,
      function( v )
        local element;
        
        element := PathAsAlgebraElement( quiver_algebra, UnderlyingVertex( v ) );
        
        return DgQuiverMorphism( v, element, v, 0 );
        
    end );
    
    ##
    AddPostCompose( category,
        function( beta, alpha )
        local element;
        
        element := ComposeElements( UnderlyingQuiverAlgebraElement( alpha ), UnderlyingQuiverAlgebraElement( beta ) );
        
        return DgQuiverMorphism( Source( alpha ), element, Range( beta ), DgDegree( alpha ) + DgDegree( beta ) );
        
    end );
    
    ##
    AddIsDgZeroForMorphisms( category,
      function( alpha )
        
        return IsZero( UnderlyingQuiverAlgebraElement( alpha ) );
        
    end );
    
    ##
    AddDgDifferential( category,
      function( alpha )
        local element, paths, coeffs, i;
        
        element := UnderlyingQuiverAlgebraElement( alpha );
        
        paths := Paths( element );
        
        coeffs := Coefficients( element );
        
        element := Zero( quiver_algebra );
        
        for i in [ 1 .. Size( coeffs ) ] do
            
            element := element + coeffs[i] * DG_DIFFERENTIAL_ON_PATHS( paths[i] );
            
        od;
        
        return DgQuiverMorphism( Source( alpha ), element, Range( alpha ), DgDegree( alpha ) + 1 );
        
    end );
    
    ##
    AddDgZeroMorphism( category,
      function( source, range, dgdeg )
        
        return DgQuiverMorphism( source, Zero( quiver_algebra ), range, dgdeg );
        
    end );
    
    ##
    AddDgScalarMultiplication( category,
      
      function( r, alpha )
        
        return DgQuiverMorphism( Source( alpha ), 
                                 r * UnderlyingQuiverAlgebraElement( alpha ),
                                 Range( alpha ),
                                 DgDegree( alpha ) 
        );
        
    end );
    
    ##
    AddDgAdditionForMorphisms( category,
      function( alpha, beta )
        
        return DgQuiverMorphism( Source( alpha ),
                                UnderlyingQuiverAlgebraElement( alpha )
                                + UnderlyingQuiverAlgebraElement( beta ),
                                Range( alpha ),
                                DgDegree( alpha )
        );
        
    end );
    
    ##
    AddDgSubtractionForMorphisms( category,
      function( alpha, beta )
        
        return DgQuiverMorphism( Source( alpha ),
                                UnderlyingQuiverAlgebraElement( alpha )
                                - UnderlyingQuiverAlgebraElement( beta ),
                                Range( alpha ),
                                DgDegree( alpha )
        );
        
    end );
    
    ##
    AddDgAdditiveInverseForMorphisms( category,
      
      function( alpha )
        
        return DgQuiverMorphism( Source( alpha ),
                                - UnderlyingQuiverAlgebraElement( alpha ),
                                Range( alpha ),
                                DgDegree( alpha )
        );
        
    end );
    
    ## Homomorphism structure (in cochain complexes)
    
    ##
    DG_BASIS_PATHS := FunctionWithCache(
      function( v, w, deg )
        
        return Filtered( BasisPathsBetweenVertices( quiver_algebra, UnderlyingVertex( v ), UnderlyingVertex( w ) ), p -> DG_DEGREE_ON_PATHS( p ) = deg );
        
    end );
    
    ##
    DG_BASIS_PATHS_DEGREES := FunctionWithCache(
      function( v, w )
        local basis;
        
        basis := BasisPathsBetweenVertices( quiver_algebra, UnderlyingVertex( v ), UnderlyingVertex( w ) );
        
        return Set( List( basis, DG_DEGREE_ON_PATHS ) );
        
    end );
    
    ##
    AddHomomorphismStructureOnObjects( category,
      
      function( v, w )
        local basis_pre, basis_post, i, differential_list, field, degrees, d, obj_pre, obj_post, morphism, matrix, obj_post_hit;
        
        degrees := DG_BASIS_PATHS_DEGREES( v, w );
        
        if IsEmpty( degrees ) then
            
            return DgZeroObject( RangeCategoryOfHomomorphismStructure( category ) );
            
        fi;
        
        differential_list := [ ];
        
        field := CommutativeRingOfDgCategory( category );
        
        d := degrees[1];
        
        basis_pre := DG_BASIS_PATHS( v, w, d );
        
        obj_pre := VectorSpaceObject( Size( basis_pre ), field );
        
        obj_post_hit := false;
        
        for i in [ 2 .. Size( degrees - 1 ) ] do
            
            basis_post := DG_BASIS_PATHS( v, w, degrees[i] );
            
            obj_post := VectorSpaceObject( Size( basis_post ), field );
            
            if degrees[i] = d + 1 then
                
                matrix := HomalgMatrix( 
                    List( basis_pre, p -> CoefficientsOfPaths( basis_post, DG_DIFFERENTIAL_ON_PATHS( p ) ) ),
                    Dimension( obj_pre ),
                    Dimension( obj_post ),
                    field
                );
                
                morphism := VectorSpaceMorphism( obj_pre, matrix, obj_post );
                
                Add( differential_list, [ d, morphism ] );
                
                obj_post_hit := true;
                
            else
                
                if not obj_post_hit then
                    
                    Add( differential_list, [ d, UniversalMorphismIntoZeroObject( obj_pre ) ] );
                    
                fi;
                
                obj_post_hit := false;
                
            fi;
            
            basis_pre := basis_post;
            
            obj_pre := obj_post;
            
            d := degrees[i];
            
        od;
        
        if not obj_post_hit then
            
            Add( differential_list, [ degrees[ Size( degrees ) ], UniversalMorphismIntoZeroObject( obj_pre ) ] );
            
        fi;
        
        return DgBoundedCochainComplex( differential_list, RangeCategoryOfHomomorphismStructure( category ) );
        
    end );
    
    ##
    AddHomomorphismStructureOnMorphismsWithGivenObjects( category,
      
      function( source, alpha, beta, range )
        local morphism_list, deg, d, v, vp, w, wp, v_wp_degs, vp_w_degs, relevant_degs, basis_pre, basis_post, obj_pre, obj_post, matrix, morphism;
        
        deg := DgDegree( alpha ) + DgDegree( beta );
        
        v := Source( alpha );
        
        vp := Range( alpha );
        
        w := Source( beta );
        
        wp := Range( beta );
        
        v_wp_degs := DG_BASIS_PATHS_DEGREES( v, wp );
        
        vp_w_degs := DG_BASIS_PATHS_DEGREES( vp, w );
        
        relevant_degs := Filtered( vp_w_degs, d -> (d + deg) in v_wp_degs );
        
        morphism_list := [ ];
        
        for d in relevant_degs do
            
            basis_pre := DG_BASIS_PATHS( vp, w, d );
            
            basis_post := DG_BASIS_PATHS( v, wp, d + deg );
            
            obj_pre := source[ d ];
            
            obj_post := range[ d + deg ];
            
            matrix := HomalgMatrix(
                    List( basis_pre, p -> 
                        CoefficientsOfPaths( basis_post,
                            ComposeElements( UnderlyingQuiverAlgebraElement( alpha ),
                                ComposeElements( PathAsAlgebraElement( quiver_algebra, p ) , UnderlyingQuiverAlgebraElement( beta ) )
                            )
                        )
                    ),
                    Dimension( obj_pre ),
                    Dimension( obj_post ),
                    field
            );
            
            morphism := VectorSpaceMorphism( obj_pre, matrix, obj_post );
            
            Add( morphism_list, [ d, morphism ] );
            
        od;
        
        return DgBoundedCochainMap( source, morphism_list, range, deg );
        
    end );
    
    ##
    AddDistinguishedObjectOfHomomorphismStructure( category,
      
      function( )
        local differential_list;
        
        differential_list := [
            [ 0, UniversalMorphismIntoZeroObject( TensorUnit( UnderlyingLinearCategory( category ) ) ) ]
        ];
        
        return DgBoundedCochainComplex( differential_list, RangeCategoryOfHomomorphismStructure( category ) );
        
    end );
    
    ##
    AddInterpretMorphismAsMorphismFromDinstinguishedObjectToHomomorphismStructure( category,
      
      function( alpha )
        local distinguished_object, v, w, hom_structure, element, deg, basis, morphism;
        
        distinguished_object := DistinguishedObjectOfHomomorphismStructure( category );
        
        v := Source( alpha );
        
        w := Range( alpha );
        
        hom_structure := HomomorphismStructureOnObjects( v, w );
        
        element := UnderlyingQuiverAlgebraElement( alpha );
        
        deg := DgDegree( alpha );
        
        basis := DG_BASIS_PATHS( v, w, deg );
        
        morphism := VectorSpaceMorphism(
            distinguished_object[0],
            HomalgMatrix( [ CoefficientsOfPaths( basis, element ) ], 1, Size( basis ), field ),
            hom_structure[deg]
        );
        
        return DgBoundedCochainMap( 
            distinguished_object,
            [ [ deg, morphism ] ],
            hom_structure,
            deg
        );
        
    end );
    
    ##
    AddInterpretMorphismFromDinstinguishedObjectToHomomorphismStructureAsMorphism( category,
      function( v, w, cochain_map )
        local deg, coeffs, basis, element;
        
        deg := DgDegree( cochain_map );
        
        coeffs := EntriesOfHomalgMatrix( UnderlyingMatrix( cochain_map^deg ) );
        
        basis := DG_BASIS_PATHS( v, w, deg );
        
        element := QuiverAlgebraElement( quiver_algebra, coeffs, basis );
        
        return DgQuiverMorphism( v, element, w, deg );
        
    end );
    
    ##
    AddDgWitnessForExactnessOfMorphism( category,
      function( alpha )
        local v, w, deg, cochain_map, hom_structure, lift, coeffs, basis, element;
        
        v := Source( alpha );
        
        w := Range( alpha );
        
        deg := DgDegree( alpha );
        
        cochain_map := InterpretMorphismAsMorphismFromDinstinguishedObjectToHomomorphismStructure( alpha );
        
        hom_structure := Range( cochain_map );
        
        lift := Lift( cochain_map^deg, hom_structure^(deg-1) );
        
        if lift = fail then
            
            return fail;
            
        fi;
        
        coeffs := EntriesOfHomalgMatrix( UnderlyingMatrix( lift ) );
        
        basis := DG_BASIS_PATHS( v, w, deg - 1 );
        
        element := QuiverAlgebraElement( quiver_algebra, coeffs, basis );
        
        return DgQuiverMorphism(
            v,
            element,
            w,
            deg -1
        );
        
    end );
    
end ); 

####################################
##
## View
##
####################################

##
InstallMethod( ViewObj,
        [ IsDgQuiverObject ],

  function( v )
    
    ViewObj( UnderlyingVertex( v ) );
    
end );

##
InstallMethod( ViewObj,
        [ IsDgQuiverMorphism ],

  function( alpha )
    
    ViewObj( UnderlyingVertex( Source( alpha ) ) );
    Print( "-- " );
    ViewObj( UnderlyingQuiverAlgebraElement( alpha ) );
    Print( " -->" );
    ViewObj( UnderlyingVertex( Range( alpha ) ) );
    
end );
