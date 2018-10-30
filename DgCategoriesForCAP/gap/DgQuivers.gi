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
    local category;
    
    category := CreateCapCategory( Concatenation( "Dg quiver( ", String( quiver_algebra )," )"  ) );
    
    category!.degree_list := degree;
    
    category!.differential_list := differential;
    
    SetFilterObj( category, IsDgQuiver );
    
    SetCommutativeRingOfDgCategory( category, LeftActingDomain( quiver_algebra) );
    
    SetUnderlyingQuiverAlgebra( category, quiver_algebra );
    
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

##
InstallGlobalFunction( PRECOMPUTE_PATHS_FOR_DG_QUIVERS,
               [ IsQuiverAlgebra ],
               
  function( quiver_algebra )
    local quiver, vertices, basis, list, path;
    
    quiver := QuiverOfAlgebra( quiver_algebra );
    
    vertices := Vertices( quiver );
    
    basis := BasisPaths( CanonicalBasis( quiver_algebra ) );
    
    list := List( vertices, i -> List( vertices, i -> [ ] ) );
    
    for path in basis do
        
        Add( list[ VertexNumber( Source( path ) ) ][ VertexNumber( Target( path ) ) ], path );
        
    od;
    
    return list;
    
end );

####################################
##
## Basic operations
##
####################################

##
InstallGlobalFunction( INSTALL_FUNCTIONS_FOR_DG_QUIVERS,
  
  function( category, quiver_algebra, degree, differential )
    local paths, DG_DIFFERENTIAL_ON_PATHS, is_left_quiver, field;
    
    field := CommutativeRingOfDgCategory( category );
    
    is_left_quiver := IsLeftQuiver( QuiverOfAlgebra( quiver_algebra) );
    
    if is_left_quiver then
        
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
            
            ## try to get rid of the distinction by having a source-to-target multiplication for quiver algebras
            element := element + coefficient * (pre_path * d * post_path);
            
          od;
          
          return element;
          
        end;
        
    else
    
    fi;
    
    
    
    paths := PRECOMPUTE_PATHS_FOR_DG_QUIVERS( quiver_algebra );
    
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
    AddIdentityMorphism( category,
      function( v )
        local element;
        
        element := PathAsAlgebraElement( quiver_algebra, UnderlyingVertex( v ) );
        
        return DgQuiverMorphism( v, element, v, 0 );
        
    end );
    
    if not is_left_quiver then
        
        ##
        AddPostCompose( category,
          function( beta, alpha )
            local element;
            
            element := UnderlyingQuiverAlgebraElement( alpha ) * UnderlyingQuiverAlgebraElement( beta );
            
            return DgQuiverMorphism( Source( alpha ), element, Range( beta ), DgDegree( alpha ) + DgDegree( beta ) );
            
        end );
        
    else
        
        ##
        AddPostCompose( category,
          function( beta, alpha )
            local element;
            
            element := UnderlyingQuiverAlgebraElement( beta ) * UnderlyingQuiverAlgebraElement( alpha );
            
            return DgQuiverMorphism( Source( alpha ), element, Range( beta ), DgDegree( alpha ) + DgDegree( beta ) );
            
        end );
        
    fi;
    
    ##
    AddIsDgZeroForMorphisms( category,
      function( alpha )
        
        return IsZero( UnderlyingQuiverAlgebraElement( alpha ) );
        
    end );
    
    ##
    AddDgDifferential( category,
      function( alpha )
        local element, v, w, basis, coeffs, i;
        
        element := UnderlyingQuiverAlgebraElement( alpha );
        
        v := UnderlyingVertex( Source( alpha ) );
        
        w := UnderlyingVertex( Range( alpha ) );
        
        basis := BasisPathsBetweenVertices( quiver_algebra, v, w );
        
        coeffs := CoefficientsOfPaths( basis, element );
        
        element := Zero( quiver_algebra );
        
        for i in [ 1 .. Size( coeffs) ] do
            
            if not IsZero( coeffs[i] ) then
                
                element := element + coeffs[i] * DG_DIFFERENTIAL_ON_PATHS( basis[i] );
                
            fi;
            
        od;
        
        return DgQuiverMorphism( Source( alpha ), element, Range( alpha ), DgDegree( alpha ) + 1 );
        
    end );
    
end ); 