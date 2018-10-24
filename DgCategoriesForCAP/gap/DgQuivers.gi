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
    
    SetFilterObj( category, IsDgQuiver );
    
    SetCommutativeRingOfDgCategory( category, LeftActingDomain( quiver_algebra) );
    
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
    local paths;
    
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
    
    ##
    AddPreCompose( category,
      function( alpha, beta )
        local element;
        
        element := UnderlyingQuiverAlgebraElement( alpha ) * UnderlyingQuiverAlgebraElement( beta );
        
        return DgQuiverMorphism( Source( alpha ), element, Range( beta ), DgDegree( alpha ) + DgDegree( beta ) );
        
    end );
    
end );