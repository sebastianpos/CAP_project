#! @Chapter Examples and Tests

#! @Section MorphismFromSourceToPushout and MorphismFromFiberProductToSink

LoadPackage( "LinearAlgebraForCAP" );

#! @Example
field := HomalgFieldOfRationals( );;
A := VectorSpaceObject( 3, field );;
B := VectorSpaceObject( 2, field );;

alpha := VectorSpaceMorphism( B, HomalgMatrix( [ [ 1, -1, 1 ], [ 1, 1, 1 ] ], 2, 3, field ), A );;
beta := VectorSpaceMorphism( B, HomalgMatrix( [ [ 1, 2, 1 ], [ 2, 1, 1 ] ], 2, 3, field ), A );;

m := MorphismFromFiberProductToSink( [ alpha, beta ] );;
IsCongruentForMorphisms(
    m,
    PreCompose( ProjectionInFactorOfFiberProduct( [ alpha, beta ], 1 ), alpha )
);
#! true
IsCongruentForMorphisms(
    m,
    PreCompose( ProjectionInFactorOfFiberProduct( [ alpha, beta ], 2 ), beta )
);
#! true
alpha_p := DualOnMorphisms( alpha );;
beta_p := DualOnMorphisms( beta );;
m_p := MorphismFromSourceToPushout( [ alpha_p, beta_p ] );;
IsCongruentForMorphisms(
    m_p,
    PreCompose( alpha_p, InjectionOfCofactorOfPushout( [ alpha_p, beta_p ], 1 ) )
);
#! true
IsCongruentForMorphisms(
    m_p,
    PreCompose( beta_p, InjectionOfCofactorOfPushout( [ alpha_p, beta_p ], 2 ) )
);
#! true
#! @EndExample