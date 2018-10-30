#! @Chapter Examples and Tests

#! @Section Basics

LoadPackage( "DgCategoriesForCAP" );;
LoadPackage( "LinearAlgebraForCAP" );;

#! @Example
k := HomalgFieldOfRationals();;
vec := MatrixCategory( k );;
CapCategorySwitchLogicOff( vec );;
DeactivateCachingOfCategory( vec );;
V1 := TensorUnit( vec );;
V2 := DirectSum( V1, V1 );;
d_0 := InjectionOfCofactorOfDirectSum( [ V1, V1, V1 ], 1 );;
d_1 := ProjectionInFactorOfDirectSum( [ V1, V2 ], 2 );;
IsZero( PreCompose( d_0, d_1 ) );
#! true
dg_cochain := DgBoundedCochainComplexCategory( vec );;
DeactivateCachingOfCategory( dg_cochain );;
com1 := DgBoundedCochainComplex( [ [ 0, d_0 ], [ 1, d_1 ] ], dg_cochain );;
IsWellDefinedForObjects( com1 );
#! true
IsEqualForObjects( com1[0], Source( d_0 ) );
#! true
IsEqualForObjects( com1[1], Source( d_1 ) );
#! true
IsEqualForObjects( com1[2], Range( d_1 ) );
#! true
V0 := ZeroObject( vec );;
IsEqualForObjects( com1[-1], V0 );
#! true
IsEqualForObjects( com1[-2], V0 );
#! true
IsEqualForObjects( com1[3], V0 );
#! true
IsEqualForObjects( com1[4], V0 );
#! true
IsEqualForMorphisms( com1^0, d_0 );
#! true
IsEqualForMorphisms( com1^1, d_1 );
#! true
IsEqualForMorphisms( com1^-1, ZeroMorphism( com1[-1], com1[0] ) );
#! true
IsEqualForMorphisms( com1^-2, ZeroMorphism( com1[-2], com1[-1] ) );
#! true
IsEqualForMorphisms( com1^2, ZeroMorphism( com1[2], com1[3] ) );
#! true
IsEqualForMorphisms( com1^3, ZeroMorphism( com1[3], com1[4] ) );
#! true
V4 := DirectSum( V2, V2 );;
V5 := DirectSum( V4, V1 );;
V8 := DirectSum( V4, V4 );;
e_0 := InjectionOfCofactorOfDirectSum( [ V4, V4, V4 ], 1 );;
e_1 := ProjectionInFactorOfDirectSum( [ V4, V8 ], 2 );;
com2 := DgBoundedCochainComplex( [ [ -3, e_0 ], [ -2, e_1 ] ], dg_cochain );;
IsWellDefinedForObjects( com2 );
#! true
V3 := DirectSum( V2, V1 );;
V11 := DirectSum( V8, V2, V1 );;
f_0 := InjectionOfCofactorOfDirectSum( [ V1, V11 ], 1 );;
f_1 := InjectionOfCofactorOfDirectSum( [ V3, V5 ], 1 );;
map := DgBoundedCochainMap( com1, [ [ 0, f_0 ], [ 1, f_1 ] ], com2, -2 );;
map2 := DgBoundedCochainMap( com1, [ [ 0, f_0 ], [ 1, f_1 ] ], com2, -2 );;
DgDegree( map );
#! -2
IsWellDefinedForMorphisms( map );
#! true
IsEqualForObjects( com1, com2 );
#! false
IsCongruentForMorphisms( map, map2 );
#! true
id_1 := IdentityMorphism( com1 );;
z_1_1 := DgZeroMorphism( com1, com1, 0 );;
IsCongruentForMorphisms( id_1, z_1_1 );
#! false
z_1_2 := DgZeroMorphism( com1, com2, 0 );;
IsCongruentForMorphisms( z_1_2, map );
#! false
IsCongruentForMorphisms( PreCompose( id_1, map ), map );
#! true
IsCongruentForMorphisms( PreCompose( id_1, z_1_2 ), z_1_2 );
#! true
IsCongruentForMorphisms( (-2/3 /k)*map, map*(-2/3 /k) );
#! true
diff := DgDifferential( map );;
DgDegree( diff );
#! -1
IsDgZeroForMorphisms( diff );
#! false
IsDgZeroForMorphisms( DgDifferential( diff ) );
#! true
IsDgZeroForMorphisms( DgDifferential( id_1 ) );
#! true
IsDgClosedMorphism( id_1 );
#! true
IsDgClosedMorphism( map );
#! false
z := DgZeroMorphism( Source( map ), Range( map ), DgDegree( map ) );;
IsCongruentForMorphisms( map,
    DgAdditionForMorphisms(
        map,
        z
    )
);
#! true
IsCongruentForMorphisms( map,
    DgSubtractionForMorphisms(
        map,
        z
    )
);
#! true
IsCongruentForMorphisms(
    z,
    DgAdditionForMorphisms(
        map,
        DgAdditiveInverseForMorphisms( map )
    )
);
#! true
into_z := DgUniversalMorphismIntoZeroObject( com1, 1 );;
from_z  := DgUniversalMorphismFromZeroObject( com2, -1 );;
IsEqualForObjects( DgZeroObject( dg_cochain ), Range( into_z ) );
#! true
IsEqualForObjects( DgZeroObject( dg_cochain ), Source( from_z ) );
#! true
IsCongruentForMorphisms(
    PreCompose( into_z , from_z ),
    DgZeroMorphism( com1, com2, 0 )
);
#! true
IsDgZeroForObjects( DgZeroObject( dg_cochain ) );
#! true
p1 := DgProjectionInFactorOfDirectSum( [ com1, com2 ], 1 );;
p2 := DgProjectionInFactorOfDirectSum( [ com1, com2 ], 2 );;
IsDgClosedMorphism( p1 );
#! true
IsDgClosedMorphism( p2 );
#! true
i1 := DgInjectionOfCofactorOfDirectSum( [ com1, com2 ], 1 );;
i2 := DgInjectionOfCofactorOfDirectSum( [ com1, com2 ], 2 );;
IsDgClosedMorphism( i1 );
#! true
IsDgClosedMorphism( i2 );
#! true
IsCongruentForMorphisms(
    IdentityMorphism( DgDirectSum( [ com1, com2 ] ) ),
    DgAdditionForMorphisms( PreCompose( p1, i1 ), PreCompose( p2, i2 ) )
);
#! true
IsCongruentForMorphisms(
    IdentityMorphism( com1 ),
    PreCompose(
        DgUniversalMorphismIntoDirectSum( [ com1, com2 ], [ IdentityMorphism( com1 ), DgZeroMorphism( com1, com2, 0 ) ] ),
        DgUniversalMorphismFromDirectSum( [ com1, com2 ], [ IdentityMorphism( com1 ), DgZeroMorphism( com2, com1, 0 ) ] )
    )
);
#! true
#! @EndExample