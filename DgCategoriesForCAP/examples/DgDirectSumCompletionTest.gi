#! @Chapter Examples and Tests

#! @Section Basics

LoadPackage( "DgCategoriesForCAP" );;
LoadPackage( "LinearAlgebraForCAP" );;

#! @Example
quiver := RightQuiver( "Q(6)[a:1->2,b:2->3]" );;
kQ := PathAlgebra( HomalgFieldOfRationals(), quiver );;
A := kQ/ [ kQ.ab ];;
deg := [ 1, -1 ];;
differential := [ Zero( A ), Zero( A )];;
dgA := DgQuiver( A, deg, differential );;
objects := ObjectsOfDgQuiver( dgA );;
mors := ArrowsOfDgQuiver( dgA );;
comp := DgDirectSumCompletion( dgA );;
obj1 := DgDirectSumCompletionObject( [ objects[1], objects[1], objects[2] ], comp );;
obj2 := DgDirectSumCompletionObject( [  ], comp );;
obj3 := DgDirectSumCompletionObject( [ objects[3] ], comp );;
mor12 := DgDirectSumCompletionMorphism( 
    obj1,
    [ , , [ 1 ] ],
    [ , , [ mors[2] ] ],
    obj3,
    -1
);;
IsWellDefinedForObjects( obj1 );
#! true
IsWellDefinedForObjects( obj2 );
#! true
IsWellDefinedForObjects( obj3 );
#! true
IsWellDefinedForMorphisms( mor12 );
#! true
IsEqualForObjects( obj1, obj2 );
#! false
IsEqualForObjects( obj2, obj3 );
#! false
mor12_2 := DgDirectSumCompletionMorphism( 
    obj1,
    [ , , [ 1 ] ],
    [ , , [ 2*mors[2] ] ],
    obj3,
    -1
);;
IsEqualForMorphisms( mor12, mor12_2 );
#! false
z_1 := DgDirectSumCompletionMorphism( 
    obj1,
    [ , , [ 1 ] ],
    [ , , [ DgZeroMorphism( objects[2], objects[3], -1 ) ] ],
    obj3,
    -1
);;
z_2 := DgDirectSumCompletionMorphism( 
    obj1,
    [  ],
    [  ],
    obj3,
    -1
);;
IsEqualForMorphisms( z_1, z_2 );
#! false
IsCongruentForMorphisms( z_1, z_2 );
#! true
A := DgDirectSumCompletionObject( [ objects[1], objects[1] ], comp );;
B := DgDirectSumCompletionObject( [ objects[1], objects[2] ], comp );;
C := DgDirectSumCompletionObject( [ objects[3] ], comp );;
alpha := DgDirectSumCompletionMorphism( 
    A,
    [ [ 2 ], [ 2 ] ],
    [ [ mors[1] ], [ mors[1] ] ],
    B,
    1
);;
beta := DgDirectSumCompletionMorphism( 
    B,
    [ , [ 1 ] ],
    [ , [ mors[2] ] ],
    C,
    -1
);;
IsWellDefinedForMorphisms( PostCompose( beta, alpha ) );
#! true
idA := IdentityMorphism( A );;
IsCongruentForMorphisms( PostCompose( alpha, idA ), alpha );
#! true
#! @EndExample