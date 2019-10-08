#! @Chapter Examples and Tests

#! @Section Tensor product

LoadPackage( "LocalizationsOfRingsForCAP" );

#! @Example
vars := "a,b,c,d,e,f,g,h,i,j";;
R := HomalgFieldOfRationalsInSingular() * vars;;
prime := HomalgMatrix( Concatenation( "[", vars, "]" ), 10, 1, R );;
loc_func := LocalizationAtPrimeIdealData( R, prime );;
C := CategoryOfLocalizedRows( R, loc_func );;
T := TensorUnit( C );;
IsWellDefined( T );
#! true
#! @EndExample

#! We test the naturality of the braiding.

#! @Example
R2 := DirectSum( T, T );;
R3 := DirectSum( T, R2 );;
R4 := DirectSum( R2, R2 );;
alpha := CategoryOfLocalizedRowsMorphism( T, HomalgMatrix( "[ a, b, c, d ]", 1, 4, R ), One( R ), R4 );;
beta := CategoryOfLocalizedRowsMorphism( R2, HomalgMatrix( "[ e, f, g, h, i, j ]", 2, 3, R ),One( R ), R3 );;
# alpha := CategoryOfLocalizedRowsMorphism( T, HomalgMatrix( "[ a, b, c, d ]", 1, 4, R ), "a-1"/R, R4 );;
# beta := CategoryOfLocalizedRowsMorphism( R2, HomalgMatrix( "[ e, f, g, h, i, j ]", 2, 3, R ),"b*c*d*e+1"/R, R3 );;
IsCongruentForMorphisms(
    PreCompose( Braiding( T, R2 ), TensorProductOnMorphisms( beta, alpha ) ),
    PreCompose( TensorProductOnMorphisms( alpha, beta ), Braiding( R4, R3 ) )
);
#! true
#! @EndExample

#! We compute the torsion part of a f.p. module with the help of the induced tensor structure
#! on the Freyd category.

#! @Example
M := FreydCategoryObject( alpha );;
mu := MorphismToBidual( M );;
co := CoastrictionToImage( mu );;
IsIsomorphism( co );
#! true
#! @EndExample