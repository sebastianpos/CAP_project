#! @Chapter Examples and Tests

#! @Section Adelman category basics

LoadPackage( "FreydCategoriesForCAP" );;
LoadPackage( "GeneralizedMorphismsForCAP" );;

#! @Example
quiver := RightQuiver( "Q(3)[a:1->2,b:1->2,c:2->3]" );;
kQ := PathAlgebra( HomalgFieldOfRationals(), quiver );;
Aoid := Algebroid( kQ );;
INSTALL_HOMOMORPHISM_STRUCTURE_FOR_BIALGEBROID( Aoid );;
mm := SetOfGeneratingMorphisms( Aoid );;
CapCategorySwitchLogicOff( Aoid );;
Acat := AdditiveClosure( Aoid );;
a := AsAdditiveClosureMorphism( mm[1] );;
b := AsAdditiveClosureMorphism( mm[2] );;
c := AsAdditiveClosureMorphism( mm[3] );;
a := AsAdelmanCategoryMorphism( a );;
b := AsAdelmanCategoryMorphism( b );;
c := AsAdelmanCategoryMorphism( c );;
A := Source( a );
B := Range( a );
C := Range( c );
HomomorphismStructureOnObjects( A, C );
HomomorphismStructureOnMorphisms( IdentityMorphism( A ), c );
mor := InterpretHomomorphismAsMorphismFromDinstinguishedObjectToHomomorphismStructure( a );
int := InterpretMorphismFromDinstinguishedObjectToHomomorphismStructureAsHomomorphism( A, B, mor );
IsCongruentForMorphisms( int, a );
#! true
#! @EndExample