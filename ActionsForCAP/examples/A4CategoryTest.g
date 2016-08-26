LoadPackage( "ActionsForCAP" );

G := AlternatingGroup( 4 );

RepG := RepresentationCategory( G );

irr := Irr( G );

v1 := RepresentationCategoryObject( irr[1] );

v2 := RepresentationCategoryObject( irr[2] );

v3 := RepresentationCategoryObject( irr[3] );

v4 := RepresentationCategoryObject( irr[4] );

L := [ v1, v2, v3, v4 ];
