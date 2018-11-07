#! @Chapter Examples and Tests

#! @Section Dg quivers

LoadPackage( "DgCategoriesForCAP" );;
LoadPackage( "LinearAlgebraForCAP" );;

#! This example is taken from:
#! DG categories and derived categories of coherent sheaves
#! (Agnieszka Bodzenta-Skibińska)
#! 2.1.1. Example (page 38)
#! @Example
arrows :=
"gamma:1->2,\
gamma_bar:1->2,\
delta_bar:2->3,\
epsilon1:2->4,\
epsilon2:2->4,\
alpha1:3->4,\
alpha2:3->4,\
alpha3:3->4,\
beta1:4->5,\
beta2:4->5,\
beta3:4->5";;
#
underlying_quiver := 
    LeftQuiver( Concatenation( "BlBlP2(5)[", arrows, "]" ) );;
#
arrows := Arrows( underlying_quiver );;
#
kQ := PathAlgebra( HomalgFieldOfRationals(), underlying_quiver );;
#
gamma := PathAsAlgebraElement( kQ, arrows[1] );;
gamma_bar := PathAsAlgebraElement( kQ, arrows[2] );;
delta_bar := PathAsAlgebraElement( kQ, arrows[3] );;
epsilon1 := PathAsAlgebraElement( kQ, arrows[4] );;
epsilon2 := PathAsAlgebraElement( kQ, arrows[5] );;
alpha1 := PathAsAlgebraElement( kQ, arrows[6] );;
alpha2 := PathAsAlgebraElement( kQ, arrows[7] );;
alpha3 := PathAsAlgebraElement( kQ, arrows[8] );;
beta1 := PathAsAlgebraElement( kQ, arrows[9] );;
beta2 := PathAsAlgebraElement( kQ, arrows[10] );;
beta3 := PathAsAlgebraElement( kQ, arrows[11] );;
#
relations := [
    beta1 * alpha2 - beta2 * alpha1,
    beta1 * alpha3 - beta3 * alpha1,
    beta2 * alpha3 - beta3 * alpha2,
    beta2 * epsilon1 - beta1 * epsilon2,
    delta_bar * gamma_bar,
    epsilon1 * gamma_bar,
    epsilon2 * gamma_bar - alpha3 * delta_bar * gamma 
];;
#
A := kQ/ relations;;
gamma := PathAsAlgebraElement( A, arrows[1] );;
gamma_bar := PathAsAlgebraElement( A, arrows[2] );;
delta_bar := PathAsAlgebraElement( A, arrows[3] );;
epsilon1 := PathAsAlgebraElement( A, arrows[4] );;
epsilon2 := PathAsAlgebraElement( A, arrows[5] );;
alpha1 := PathAsAlgebraElement( A, arrows[6] );;
alpha2 := PathAsAlgebraElement( A, arrows[7] );;
alpha3 := PathAsAlgebraElement( A, arrows[8] );;
beta1 := PathAsAlgebraElement( A, arrows[9] );;
beta2 := PathAsAlgebraElement( A, arrows[10] );;
beta3 := PathAsAlgebraElement( A, arrows[11] );;
#
degrees := [
    0,
    1,
    0,
    -1,
    -1,
    0,
    0,
    0,
    0,
    0,
    0
];;
#
differential := [
    Zero( A ),
    Zero( A ),
    Zero( A ),
    alpha1 * delta_bar,
    alpha2 * delta_bar,
    Zero( A ),
    Zero( A ),
    Zero( A ),
    Zero( A ),
    Zero( A ),
    Zero( A )
];;
#
dgA := DgQuiver( A, degrees, differential );;
arrows := ArrowsOfDgQuiver( dgA );;
gamma := arrows[1];;
gamma_bar := arrows[2];;
delta_bar := arrows[3];;
epsilon1 := arrows[4];;
epsilon2 := arrows[5];;
alpha1 := arrows[6];;
alpha2 := arrows[7];;
alpha3 := arrows[8];;
beta1 := arrows[9];;
beta2 := arrows[10];;
beta3 := arrows[11];;
#
IsDgZeroForMorphisms( PostCompose( delta_bar, gamma_bar ) );
#! true
DgDegree( PostCompose( epsilon1, gamma_bar ) );
#! 0
IsCongruentForMorphisms(
    DgDifferential( PostCompose( [ beta1, epsilon1, gamma ] ) ),
    PostCompose( [ beta1, DgDifferential( epsilon1 ), gamma ] )
);
#! true
pc := PreCompose( [ gamma, delta_bar, alpha1, beta1 ] );;
IsDgZeroForMorphisms( pc );
#! false
IsDgZeroForMorphisms( DgDifferential( pc ) );
#! true
objects := ObjectsOfDgQuiver( dgA );;
t1 := DgAdditionForMorphisms( epsilon1, epsilon2 );;
IsCongruentForMorphisms(
    InterpretMorphismFromDinstinguishedObjectToHomomorphismStructureAsMorphism( 
        Source( epsilon1 ), 
        Range( epsilon1 ),
        InterpretMorphismAsMorphismFromDinstinguishedObjectToHomomorphismStructure( t1 )
    ),
    t1
);
#! true
t2 := PostCompose( alpha1, delta_bar );;
t3 := PreCompose( [ gamma_bar, t2, beta1 ] );; 
IsCongruentForMorphisms(
    t3,
    InterpretMorphismFromDinstinguishedObjectToHomomorphismStructureAsMorphism(
        Source( t3 ),
        Range( t3 ),
        PreCompose( 
            InterpretMorphismAsMorphismFromDinstinguishedObjectToHomomorphismStructure( t2 ),
            HomomorphismStructureOnMorphisms( gamma_bar, beta1 )
        )
    )
);
#! true
t4 := PostCompose( alpha1, delta_bar );;
IsCongruentForMorphisms(
    t4,
    DgDifferential( DgWitnessForExactnessOfMorphism( t4 ) )
);
#! true
DgWitnessForExactnessOfMorphism( PostCompose( alpha3, delta_bar ) );
#! fail
IsDgZeroForMorphisms( epsilon2 - epsilon2 );
#! true
IsCongruentForMorphisms(
    DgAdditionForMorphisms( DgAdditionForMorphisms( alpha1, alpha2 ), alpha3 ),
    alpha1 + alpha2 + alpha3
);
#! true
IsCongruentForMorphisms(
    -gamma_bar,
    DgZeroMorphism( Source( gamma_bar ), Range( gamma_bar ), DgDegree( gamma_bar ) ) - gamma_bar
);
#! true
#! @EndExample