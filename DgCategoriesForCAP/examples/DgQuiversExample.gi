#! @Chapter Examples and Tests

#! @Section Dg quivers

LoadPackage( "DgCategoriesForCAP" );;
LoadPackage( "LinearAlgebraForCAP" );;

#! @Example
snake_quiver := RightQuiver( "Q(6)[a:1->2,b:2->3,c:3->4]" );;
vertices := Vertices( snake_quiver );;
arrows := Arrows( snake_quiver );;
v1 := vertices[1];;
v2 := vertices[2];;
kQ := PathAlgebra( HomalgFieldOfRationals(), snake_quiver );;
A := kQ/ [ kQ.abc ];;
pa := PathAsAlgebraElement( A, arrows[1] );;
deg := [];;
differential := [];;
dgA := DgQuiver( A, deg, differential );;
obj1 := DgQuiverObject( v1, dgA );;
obj2 := DgQuiverObject( v2, dgA );;
a := DgQuiverMorphism( obj1, pa, obj2, 0 );;
#! @EndExample