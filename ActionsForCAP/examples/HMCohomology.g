LoadPackage( "ActionsForCAP" );

RepG := RepresentationCategoryZGraded( 1000, 93 );

irr := Irr( UnderlyingGroupForRepresentationCategory( RepG ) );

v := RepresentationCategoryZGradedObject( -1, irr[6], RepG );

h := RepresentationCategoryZGradedObject( 0, irr[5], RepG );

cat := InternalExteriorAlgebraModuleCategory( v );

F := FreeInternalExteriorAlgebraModule( h, cat );

chi := Support( ActionDomain( F ) )[7];

c := ComponentInclusionMorphism( ActionDomain( F ), chi );

u := UniversalMorphismFromFreeModule( F, c );