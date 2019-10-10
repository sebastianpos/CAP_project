#! @Chapter Examples and Tests

#! @Section Projectivity test

LoadPackage( "LocalizationsOfRingsForCAP" );

#! @Example
R := HomalgFieldOfRationalsInMAGMA() * "a,b";;
loc_func := LocalizationAtPolynomialsNotMeetingThePolydisk( R );
LRows := CategoryOfLocalizedRows( R, loc_func );;
P := 
HomalgMatrix( 
"[[3*(2*a-5)*(2*a-1)*(8*b+6*a-15),0,-3*(2*a-1)*(8*b+6*a-15)*(-b+3*a),-(8*b+6*a-15)*(2*a-5)^2],[0,3*(2*a-5)*(2*a-1)*(8*b+\
    6*a-15),-3*(2*a-5)*(2*a-1)^2,-3*(2*a-5)*(8*b+6*a-15)*b^2]]", 2, 4, R );
mor := AsCategoryOfLocalizedRowsMorphism( P, LRows );;
M := FreydCategoryObject( mor );;
M := QuotientByTorsion( M );;
IsProjective( M );
#! true
#! @EndExample


