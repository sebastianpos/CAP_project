
LoadPackage( "CategoriesForHomalg" );

DeclareRepresentation( "IsHomalgIntegerRep",
                       IsHomalgCategoryObjectRep,
                       [ ] );

BindGlobal( "TheTypeOfHomalgIntegers",
        NewType( TheFamilyOfHomalgCategoryObjects,
                IsHomalgIntegerRep ) );

DeclareRepresentation( "IsHomalgIntegerMorphismRep",
                       IsHomalgCategoryMorphismRep,
                       [ ] );

BindGlobal( "TheTypeOfHomalgIntegerMorphism",
        NewType( TheFamilyOfHomalgCategoryMorphisms,
                IsHomalgIntegerMorphismRep ) );

############################
##
## Attributes
##
############################

DeclareAttribute( "AsInteger",
                  IsHomalgIntegerRep );

############################
##
## Category
##
############################

integer_category := CreateHomalgCategory( "Integers" );

#############################
##
## Constructors
##
#############################

DeclareOperation( "HomalgInteger",
                  [ IsInt ] );

##
InstallMethodWithCache( HomalgInteger,
                        [ IsInt ],
                        
  function( integer )
    local homalg_integer;
    
    homalg_integer := rec( );
    
    ObjectifyWithAttributes( homalg_integer, TheTypeOfHomalgIntegers,
                             AsInteger, integer );
    
    Add( integer_category, homalg_integer );
    
    return homalg_integer;
    
end );

DeclareOperation( "HomalgIntegerMorphism",
                  [ IsInt, IsInt ] );

##
InstallMethod( HomalgIntegerMorphism,
               [ IsInt, IsInt ],
               
  function( source, range )
    
    if range < source then
        
        Error( "such a morphism does not exist" );
        
    fi;
    
    return HomalgIntegerMorphism( HomalgInteger( source ), HomalgInteger( range ) );
    
end );

DeclareOperation( "HomalgIntegerMorphism",
                  [ IsHomalgIntegerRep, IsHomalgIntegerRep ] );

##
InstallMethodWithCache( HomalgIntegerMorphism,
                        [ IsHomalgIntegerRep, IsHomalgIntegerRep ],
                        
  function( source, range )
    local morphism;
    
    if AsInteger( range ) < AsInteger( source ) then
        
        Error( "such a morphism does not exist" );
        
    fi;
    
    morphism := rec( );
    
    ObjectifyWithAttributes( morphism, TheTypeOfHomalgIntegerMorphism,
                             Source, source,
                             Range, range );
    
    Add( integer_category, morphism );
    
    return morphism;
    
end );

##
AddEqualityOfMorphisms( integer_category,
                         
  ReturnTrue );

##
AddIsZeroForMorphisms( integer_category,
                       
  function( a )
    
    return true;
    
end );

##
AddAdditionForMorphisms( integer_category,
                         
  function( a, b )
    
    return a;
    
end );

##
AddAdditiveInverseForMorphisms( integer_category,
                                
  IdFunc );

##
AddZeroMorphism( integer_category,
                 
  function( a, b )
    
    return HomalgIntegerMorphism( a, b );
    
end );

##
AddIdentityMorphism( integer_category,
                     
  function( obj )
    
    return HomalgIntegerMorphism( obj, obj );
    
end );

##
AddPreCompose( integer_category,
               
  function( mor1, mor2 )
    
    return HomalgIntegerMorphism( Source( mor1 ), Range( mor2 ) );
    
end );

#
AddPullback( integer_category,
             
  function( product_mor )
    local pullback;
    
    pullback := Gcd( List( Components( product_mor ), i -> AsInteger( Source( i ) ) ) );
    
    return HomalgInteger( pullback );
    
end );

##
AddProjectionInFactorOfPullbackWithGivenPullback( integer_category,
                                 
  function( product_mor, pullback, coordinate )
    local range;
    
    range := Source( product_mor[ coordinate ] );
    
    return HomalgIntegerMorphism( pullback, range );
    
end );


##
AddPushout( integer_category,
            
  function( product_mor )
    local pushout;
    
    pushout := Lcm( List( Components( product_mor ), i -> AsInteger( Range( i ) ) ) );
    
    return HomalgInteger( pushout );
    
end );

##
AddInjectionOfCofactorWithGivenPushout( integer_category,
                                 
  function( product_mor, pushout, coordinate )
    local source;
    
    source := Range( product_mor[ coordinate ] );
    
    return HomalgIntegerMorphism( source, pushout );
    
end );

##
AddMonoAsKernelLift( integer_category,
                     
  function( monomorphism, test_morphism )
    
    return HomalgIntegerMorphism( Source( test_morphism ), Source( monomorphism ) );
    
end );

##


###################################
##
## View
##
###################################

##
InstallMethod( ViewObj,
               [ IsHomalgIntegerRep ],
               
  function( integer_obj )
    
    Print( "<The integer object representing " );
    
    Print( String( AsInteger( integer_obj ) ) );
    
    Print( ">" );
    
end );

##
InstallMethod( ViewObj,
               [ IsHomalgIntegerMorphismRep ],
               
  function( integer_mor )
    
    Print( "<" );
    
    Print( String( AsInteger( Source( integer_mor ) ) ) );
    
    Print( " -> " );
    
    Print( String( AsInteger( Range( integer_mor ) ) ) );
    
    Print( ">" );
    
end );
