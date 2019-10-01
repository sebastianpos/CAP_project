#! @Chapter Examples and Tests

#! @Section First test

LoadPackage( "LocalizationsOfRingsForCAP" );

#! @Example
R := HomalgFieldOfRationalsInSingular() * "x,y,z";;
prime := HomalgMatrix( "[x,y]", 1, 1, R );;
loc_func := LocalizationProblemFunctionForPrimeIdeal( R, prime );;
LRows := CategoryOfLocalizedRows( R, loc_func );;
R1 := CategoryOfLocalizedRowsObject( LRows, 1 );;
R2 := CategoryOfLocalizedRowsObject( LRows, 2 );;
matrix := HomalgMatrix( "[x^2 + y^2, x^3*y + 1, y^3 + 1, x^2 + y^2 + 1, 0, 1]", 2, 3, R );;
mor := AsCategoryOfLocalizedRowsMorphism( matrix, LRows );;
IsWellDefined( mor );
#! true
matrix := HomalgMatrix( "[x^2 - 1,y * (x-1)]", 1, 2, R );;
mor1 := CategoryOfLocalizedRowsMorphism( R1, matrix, "x-1"/R, R2 );;
mor2 := AsCategoryOfLocalizedRowsMorphism( HomalgMatrix( "[x + 1,y]", 1, 2, R ), LRows );;
IsCongruentForMorphisms( mor1, mor2 );
#! true
IsEqualForMorphisms( mor1, mor2 );
#! false
IsZeroForMorphisms( mor1 - mor2 );
#! true
matrix := HomalgMatrix( "[0,1,1,0]", 2, 2, R );;
mor3 := CategoryOfLocalizedRowsMorphism( R2, matrix, "y*x - 1"/R, R2 );;
PreCompose( mor1, mor3 );;
IsCongruentForMorphisms( mor1 - mor2, ZeroMorphism( R1, R2 ) );
#! true
IsEqualForMorphisms(
    PreCompose( UniversalMorphismIntoZeroObject( R2 ), UniversalMorphismFromZeroObject( R1 ) ),
    ZeroMorphism( R2, R1 )
);
#! true
sigma1 := CategoryOfLocalizedRowsMorphism( R1, HomalgIdentityMatrix( 1, R ), "2"/R, R1 );;
sigma2 := CategoryOfLocalizedRowsMorphism( R1, HomalgIdentityMatrix( 1, R ), "3"/R, R1 );;
sigma3 := CategoryOfLocalizedRowsMorphism( R1, HomalgIdentityMatrix( 1, R ), "5"/R, R1 );;
R3 := DirectSum( R1, R2 );;
sigma123 := CategoryOfLocalizedRowsMorphism( R1, HomalgMatrix( "[ 1/2, 1/3, 1/5 ]", 1, 3, R ), One( R ), R3 );;
sigma123p := CategoryOfLocalizedRowsMorphism( R3, HomalgMatrix( "[ 1/2, 1/3, 1/5 ]", 3, 1, R ), One( R ), R1 );;
u := UniversalMorphismIntoDirectSum( [ sigma1, sigma2, sigma3 ] );;
IsCongruentForMorphisms( u, sigma123 );
#! true
up := UniversalMorphismFromDirectSum( [ sigma1, sigma2, sigma3 ] );;
IsCongruentForMorphisms( up, sigma123p );
#! true
alpha := CategoryOfLocalizedRowsMorphism( R3, HomalgMatrix( "[ x,y,z ]", 3, 1, R ), "x"/R, R1 );;
tau := CategoryOfLocalizedRowsMorphism( R1, HomalgMatrix( "[ -y^2, x*y, 0 ]", 1, 3, R ), One( R ), R3 );;
IsCongruentForMorphisms( PreCompose( WeakKernelLift( alpha, tau ), WeakKernelEmbedding( alpha ) ), tau );
#! true
beta := CategoryOfLocalizedRowsMorphism( R1, HomalgMatrix( "[ x,y,z ]", 1, 3, R ), "x"/R, R3 );;
tau_beta := CategoryOfLocalizedRowsMorphism( R3, HomalgMatrix( "[ -y^2, x*y, 0 ]", 3, 1, R ), One( R ), R1 );;
IsCongruentForMorphisms( PreCompose( WeakCokernelProjection( beta ), WeakCokernelColift( beta, tau_beta ) ), tau_beta );
#! true
IsWellDefined( DistinguishedObjectOfHomomorphismStructure( LRows ) );
#! true
IsCongruentForMorphisms( alpha,
    InterpretMorphismFromDinstinguishedObjectToHomomorphismStructureAsMorphism(
        R3, R1, InterpretMorphismAsMorphismFromDinstinguishedObjectToHomomorphismStructure( alpha )
    )
);
#! true
#! @EndExample