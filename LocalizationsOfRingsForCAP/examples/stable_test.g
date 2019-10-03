LoadPackage( "LocalizationsOfRingsForCAP" );

R := HomalgFieldOfRationalsInMAGMA() * "x,y";

loc_func := LocalizationAtPolynomialsNotMeetingThePolydisk( R );

LRows := CategoryOfLocalizedRows( R, loc_func );

m := HomalgMatrix( "[x^2 + y^2 - 1, x^3 + y^3 - 1]", 1, 2, R );;
mor := AsCategoryOfLocalizedRowsMorphism( m, LRows );;
M := FreydCategoryObject( mor );;
IsProjective( M );