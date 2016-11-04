#############################################################################
##
##                                ActionsForCAP package
##
##  Copyright 2016, Sebastian Posur, University of Siegen
##
#! @Chapter Associators
#!  
#!  Let $G$ be a finite group and let $G$-mod be a skeletal version
#!  of the monoidal category of finite complex representations of $G$.
#!  The purpose of this GAP methods is the computation of the
#!  associators of $G$-mod.
##
#############################################################################

###################################
##
## Global 
##
###################################

DeclareGlobalVariable( "ASSOCIATORS_Setup" );

###################################
##
#! @Section Technical functions
##
###################################

#! @Description
#! The arguments are an integer $n$ and a group homomorphism $f$ whose images
#! are matrices.
#! The output is true if the entries of the images of $f$ lie in
#! a cyclotomic field generated by a primitive $n$-th root of unity,
#! false otherwise.
#! @Returns a boolean
#! @Arguments n, f
DeclareOperation( "DefinedOverCyclotomicField", [ IsInt, IsGroupHomomorphism ] );

#! @Description
#! The arguments are a group $G$ with generators $g_1, \dots, g_n$ 
#! and a list $L = [ l_1, \dots, l_n ]$.
#! The output is the group homomorphism from $G$ to the group generated by
#! the elements of $L$, mapping $g_i$ to $l_i$.
#! @Returns a group homomorphism
#! @Arguments G, L
DeclareOperation( "GroupReperesentationByImages", [ IsGroup, IsList ] );

#! @Description
#! The argument is an endomorphism $e \in \mathrm{Hom}(V,V)$ of vector spaces whose minimal polynomial
#! divides $x^2 - 1$.
#! The output is an invertible endomorphism $t$ such that
#! $t^{-1} \circ e \circ e$ is a diagonal matrix.
#! @Returns an invertible endomorphism in $\mathrm{Hom}(V,V)$
#! @Arguments e
DeclareAttribute( "DiagonalizationTransformationOfBraiding", IsVectorSpaceMorphism );

#! @Description
#! The argument is a group $G$.
#! The output is a list of all irreducible representations of $G$
#! using the command IrreducibleAffordingRepresentation.
#! @Returns a list
#! @Arguments G
DeclareOperation( "AffordAllIrreducibleRepresentations", [ IsGroup ] );

#! @Description
#! The argument is a group $G$.
#! The output is a list of all irreducible representations of $G$
#! using the command IrreducibleRepresentationsDixon.
#! @Returns a list
#! @Arguments G
DeclareOperation( "AffordAllIrreducibleRepresentationsDixon", [ IsGroup ] );

#! @Description
#! The argument is a list $L$ of representations of a group $G$.
#! The output is a field over which all representations are defined simultaniously.
#! @Returns a GAP field
#! @Arguments L
DeclareOperation( "DefaultFieldForListOfRepresentations", [ IsList ] );

#! @Description
#! The arguments are a matrix $M$ and an integer $n$.
#! The output is a matrix $N$ in $Q[\epsilon]$.
#! Substituting an $n$-th root of unity for $\epsilon$ in $N$
#! yields $M$.
#! @Returns a matrix
#! @Arguments M, n
DeclareOperation( "RewriteMatrixInCyclotomicGenerator", [ IsMatrix, IsInt ] );

#! @Description
#! The argument is a group $G$.
#! This method initializes the values of the internal record ASSOCIATORS_Setup.
#! @Arguments G
DeclareOperation( "InitializeGroupData", [ IsGroup ] );

DeclareOperation( "InitializeGroupData", [ IsGroup, IsBool ] );

#! @Description
#! The argument is a group $G$.
#! This method initializes the values of the internal record ASSOCIATORS_Setup
#! affording irreducible representations using the command IrreducibleRepresentationsDixon.
#! @Arguments G
DeclareOperation( "InitializeGroupDataDixon", [ IsGroup ] );

DeclareOperation( "InitializeGroupDataDixon", [ IsGroup, IsBool ] );

#! @Description
#! The argument is a group $G$.
#! This method initializes the values of the internal record ASSOCIATORS_Setup
#! affording irreducible representations using the command IrreducibleAffordingRepresentation.
#! @Arguments G
DeclareOperation( "InitializeGroupData", [ IsGroup, IsList, IsBool ] );


## TODO: Add this to MatrixCategory
#! @Description
#! The arguments are objects $b,c$ and a morphism $g: a \rightarrow \mathrm{\underline{Hom}}(b,c)$.
#! The output is a morphism $f: a \otimes b \rightarrow c$ corresponding to $g$ under the
#! tensor hom adjunction.
#! @Returns a morphism in $\mathrm{Hom}(a \otimes b, c)$.
#! @Arguments b, c, g
DeclareOperation( "InternalHomToTensorProductAdjunctionMapTemp",
                  [ IsVectorSpaceObject, IsVectorSpaceObject, IsVectorSpaceMorphism ] );

#! @Description
#! The arguments are a homalg matrix $M$ and two integers $i,j$.
#! The output is the $(i,j)-th$ entry of $M$.
#! @Returns an element of a homalg ring
#! @Arguments M, i, j
DeclareOperation( "EntryOfHomalgMatrix",
                  [ IsHomalgMatrix, IsInt, IsInt ] );

#! @Description
#! The argument is a list $L$ which was the output of the operation SkeletalFunctorTensorData.
#! This operations displays all the matrices (without inverses) within $L$.
#! @Returns nothing
#! @Arguments L
DeclareOperation( "DisplaySkeletalFunctorTensorData", [ IsList ] );

#! @Description
#! The argument is a vector space morphism $\alpha$.
#! The output is a string containing a Gap command that creates $\alpha$
#! when executed.
#! @Returns a string
#! @Arguments alpha
DeclareOperation( "VectorSpaceMorphismAsStringCommand", [ IsVectorSpaceMorphism ] );

DeclareOperation( "HomalgMatrixAsStringCommand", [ IsHomalgMatrix ] );

DeclareOperation( "HomalgMatrixAsStringCommand", [ IsList ] );

DeclareOperation( "WriteDataFromSkeletalFunctorTensorDataAsStringList", [ IsList ] );

#! @Description
#! The argument is a homalg matrix $M$.
#! The output is a vector space morphism whose underlying matrix is
#! given by $M$.
#! @Returns a vector space morphism
#! @Arguments M
DeclareAttribute( "AsVectorSpaceMorphism", IsHomalgMatrix );

#! @Description
#! The argument is a filename $s$.
#! This operation writes the log of the skeletal functor data
#! to the file given by $s$.
#! @Returns nothing
#! @Arguments s
DeclareOperation( "WriteSkeletalFunctorDataLogToFile", [ IsString ] );


#! @Description
#! The argument is a filename $s$.
#! This operation writes the log of the associator data
#! to the file given by $s$.
#! @Returns nothing
#! @Arguments s
DeclareOperation( "WriteAssociatorLogToFile", [ IsString ] );

##
DeclareOperation( "WriteAssociatorAsStringlistToFile", [ IsString ] );

##
DeclareOperation( "WriteDatabaseKeysToFile", [ IsString ] );


##
DeclareOperation( "DecompositionFactorOfMultiplicationWithIdentity",
                  [ IsVectorSpaceMorphism, IsInt ] );

###################################
##
#! @Section Computing associators
##
###################################

#! @Description
#! There is no argument.
#! Run the InitializeGroupData( group ) command first.
#! The output is a list consisting of triples $[ n, [ i,j ], \alpha ]$,
#! where $n,i,j$ are integers ranging from $1$ to the number of irreducible representations
#! of the group and $\alpha$ is a monomorphism
#! $V_n^{m_n} \rightarrow V_i \otimes V_j$
#! which is $G$-equivariant with repect to the initialized data and where $m_n$ is maximal.
#! @Returns a list
DeclareOperation( "SkeletalFunctorTensorData", [  ] );

DeclareOperation( "SkeletalFunctorTensorData", [ IsList, IsList ] );

#! @Description
#! This method can only be called if SkeletalFunctorTensorData was called before.
#! The arguments are integers $a,b,c$.
#! The output is a list containing homalg matrices representing the components
#! of the associator of $V_a, V_b, V_c$, where the numbers correspond
#! to the enlisting of the irreducible characters in Gap.
#! @Returns a list
#! @Arguments a,b,c
DeclareOperation( "AssociatorDataFromSkeletalFunctorTensorData",
                  [ IsInt, IsInt, IsInt ] );

#! @Description
#! There is no argument.
#! The output is a list of lists $L$ such that $L[a][b][c]$ contains
#! the associator computed by AssociatorDataFromSkeletalFunctorTensorData(a,b,c),
#! but only for so many triples such that the others can be obtained using braidings.
#! @Returns a list
DeclareOperation( "AssociatorForSufficientlyManyTriples", [ ] );

DeclareOperation( "AssociatorForSufficientlyManyTriples", [ IsBool ] );

#! @Description
#! The argument is a group $G$ and a boolean $b$
#! The output is data for an associator of that group, using
#! irreducible representations constructed with IrreducibleAffordingRepresentation.
#! If b is true, then the associator includes all triples of irreducibles,
#! otherwise only suffiently many to recompute the others.
#! @Returns a list
DeclareOperation( "ComputeAssociator", [ IsGroup, IsBool ] );

#! @Description
#! The argument is a group $G$ and a boolean $b$
#! The output is data for an associator of that group, using
#! irreducible representations constructed with IrreducibleRepresentationsDixon.
#! If b is true, then the associator includes all triples of irreducibles,
#! otherwise only suffiently many to recompute the others.
#! @Returns a list
DeclareOperation( "ComputeAssociatorDixon", [ IsGroup, IsBool ] );

DeclareOperation( "ComputeAssociatorAfterInitialization", [ IsBool ] );
