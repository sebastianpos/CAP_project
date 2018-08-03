LoadPackage( "FreydCategoriesForCAP" );;

adel := FreeAbelianCategory( "Q(3)[x:1->2,y:2->3]", [ "xy" ] );

m := FreeAbelianCategorySetOfGeneratingMorphisms( adel );;
x := m[1];;
y := m[2];;

IsZero( PreCompose( x, y ) );
#! true
IsIsomorphism( x + x );
#! false