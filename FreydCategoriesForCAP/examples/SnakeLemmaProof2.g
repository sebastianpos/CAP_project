#! @Chapter Examples and Tests

#! @Section Basics

LoadPackage( "FreydCategoriesForCAP" );;
LoadPackage( "GeneralizedMorphismsForCAP" );;
SwitchGeneralizedMorphismStandard( "cospan" );
snake_quiver := RightQuiver( "Q(6)[a:1->2,b:2->3,c:3->4]" );
kQ := PathAlgebra( HomalgFieldOfRationals(), snake_quiver );
Aoid := Algebroid( kQ, [ kQ.abc ] );
SetIsAbCategory( Aoid, true );
INSTALL_HOMOMORPHISM_STRUCTURE_FOR_BIALGEBROID( Aoid );
m := SetOfGeneratingMorphisms( Aoid );

a := m[1];
b := m[2];
c := m[3];

cat := Aoid;
CapCategorySwitchLogicOff( cat );
cat := AdditiveClosure( cat );
CapCategorySwitchLogicOff( cat );
cat := Opposite( cat );
CapCategorySwitchLogicOff( cat );
cat := FreydCategory( cat );
CapCategorySwitchLogicOff( cat );
cat := Opposite( cat );
CapCategorySwitchLogicOff( cat );

a := AsMorphismInFreeAbelianCategoryByFreyd( a );
b := AsMorphismInFreeAbelianCategoryByFreyd( b );
c := AsMorphismInFreeAbelianCategoryByFreyd( c );

coker_a := CokernelProjection( a );
colift := CokernelColift( a, PreCompose( b, c ) );

ker_c := KernelEmbedding( c );
lift := KernelLift( c, PreCompose( a, b ) );

p := PreCompose( [
  AsGeneralizedMorphism( KernelEmbedding( colift ) ), 
  GeneralizedInverse( coker_a ),
  AsGeneralizedMorphism( b ),
  GeneralizedInverse( ker_c ),
  AsGeneralizedMorphism( CokernelProjection( lift ) )
] );

IsHonest( p );