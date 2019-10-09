#! @Chapter Examples and Tests

#! @Section Quotients by torsion parts

LoadPackage( "LocalizationsOfRingsForCAP" );

#! @Example
vars := "a,b,c,d,e,f,g,h,i,j";;
R := HomalgFieldOfRationalsInSingular() * vars;;
prime := HomalgMatrix( Concatenation( "[", vars, "]" ), 10, 1, R );;
loc_func := LocalizationAtPrimeIdealData( R, prime );;
C := CategoryOfLocalizedRows( R, loc_func );;
T := TensorUnit( C );;
R2 := DirectSum( T, T );;
R4 := DirectSum( R2, R2 );;
alpha := CategoryOfLocalizedRowsMorphism( T, HomalgMatrix( "[ a, b, c, d ]", 1, 4, R ), One( R ), R4 );;
M := FreydCategoryObject( alpha );;
IsIsomorphism( EpimorphismToQuotientByTorsion( M ) );
#! true
alpha := CategoryOfLocalizedRowsMorphism( T, HomalgMatrix( "[ a ]", 1, 1, R ), One( R ), T );;
M := FreydCategoryObject( alpha );;
IsIsomorphism( EpimorphismToQuotientByTorsion( M ) );
#! false
#! @EndExample