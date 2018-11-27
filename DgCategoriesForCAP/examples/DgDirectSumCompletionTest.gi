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
objects := ObjectsOfDgQuiver( dgA );
mors := ArrowsOfDgQuiver( dgA );
comp := DgDirectSumCompletion( dgA );
obj1 := DgDirectSumCompletionObject( [ objects[1], objects[1], objects[2] ], comp );
obj2 := DgDirectSumCompletionObject( [  ], comp );
obj3 := DgDirectSumCompletionObject( [ objects[3] ], comp );
mor12 := DgDirectSumCompletionMorphism( 
    obj1,
    [ , , [ 1 ] ],
    [ , , [ mors[2] ] ],
    obj3,
    -1
);
#! @EndExample
