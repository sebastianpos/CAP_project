#! @Chapter Examples and Tests

#! @Section Projectivity test

LoadPackage( "LocalizationsOfRingsForCAP" );

#! @Example
R := HomalgFieldOfRationalsInSingular() * "x,y,z";;
prime := HomalgMatrix( "[y]", 1, 1, R );;
loc_func := LocalizationAtPrimeIdealData( R, prime );;
LRows := CategoryOfLocalizedRows( R, loc_func );;
m := HomalgMatrix( "[x,z]", 1, 2, R );;
mor := AsCategoryOfLocalizedRowsMorphism( m, LRows );;
M := FreydCategoryObject( mor );;
IsProjective( M );
#! true
n := HomalgMatrix( "[y,y*x]", 1, 2, R );;
mor := AsCategoryOfLocalizedRowsMorphism( n, LRows );;
N := FreydCategoryObject( mor );;
IsProjective( N );
#! false
#! @EndExample