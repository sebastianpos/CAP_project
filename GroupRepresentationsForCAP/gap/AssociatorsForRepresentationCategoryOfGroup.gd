#############################################################################
##
##                                GroupRepresentationsForCAP package
##
##  Copyright 2016, Sebastian Posur, University of Siegen
##
#! @Chapter Associators
#!  
##
#############################################################################

#! @Section Introduction

#! Let $G$ be a finite group and let $G$-mod be a skeletal version
#! of the monoidal category of finite dimensional complex representations of $G$.
#! The purpose of these GAP methods is the computation of the
#! associators of $G$-mod.

###################################
##
## Global
##
###################################
#! @Section Quickstart

#! The following commands compute the associator of $D_8$
#! and write all data necessary for the reproducibility
#! of the computation to files with the prefix "D8".

#! @InsertChunk Quickstart_Associator_D8

DeclareGlobalVariable( "ASSOCIATORS_Setup" );



###################################
##
#! @Section Technical functions
##
###################################

#! @Description
#! The argument is an integer $l$.
#! If $l > 0$, then the functions for computing
#! associators provide information during
#! the computation. This is useful in cases
#! where the computation may take a long time.
#! @Returns nothing
#! @Arguments l
DeclareOperation( "SetInfoLevelForAssociatorComputations", [ IsInt ] );

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
#! $t^{-1} \circ e \circ t$ is a diagonal matrix.
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
#! The argument is a homalg matrx $M$.
#! The output is a string consisting of the elements
#! of $M$, seperated by commas.
#! @Returns a string
#! @Arguments M
DeclareOperation( "HomalgMatrixAsString", [ IsHomalgMatrix ] );

#! @Description
#! The argument is a list $l$ of homalg matrices. In $l$, empty entries are allowed.
#! The output is a list where each non-empty entry of $l$
#! is converted to a string using HomalgMatrixAsString.
#! @Returns a list of strings and empty entries
#! @Arguments l
DeclareOperation( "DataFromSkeletalFunctorTensorDataAsStringList", [ IsList ] );

#! @Description
#! The argument is a homalg matrix $M$.
#! The output is a vector space morphism whose underlying matrix is
#! given by $M$.
#! @Returns a vector space morphism
#! @Arguments M
DeclareAttribute( "AsVectorSpaceMorphism", IsHomalgMatrix );

## Tensor decomposition: A \otimes I -> A #TODO: or was it I \otimes A -> A?
DeclareOperation( "DecompositionFactorOfMultiplicationWithIdentity",
                  [ IsVectorSpaceMorphism, IsInt ] );
#! @Description
#! The arguments are a vector space object $V$
#! and a string $s$ consisting of $\mathrm{dim}(V)^2$ elements of the ground field of $V$.
#! The output is a vector space endomorphism $V \rightarrow V$
#! defined by $s$.
#! @Returns a vector space morphism
#! @Arguments V, s
DeclareOperation( "CreateEndomorphismFromString",
                  [ IsVectorSpaceObject, IsString ] );

###################################
##
#! @Section Read, Write, and Display
##
###################################

#! The following intermediate steps of the associator computation
#! can be read from/written to files.
#! - Irreducible representations of a finite group given by matrices (Data 1).
#! - Decomposition isomorphisms of tensor products into direct sums of irreducibles (Data 2).
#! Furthermore, the following data can be written to files.
#! - A database key for the AssociatorsDatabase/DatabaseKeys.g file.
#! - The final result, namely the associator (Data 3).
#! Data 1 and Data 2 involve choices and thus
#! are subject to changes in further versions of this package.
#! However, the process Data 2 -> Data 3 is a mathematical function
#! and thus stable. For reproducibility, it is recommended to
#! store all three data. To facilitate this task,
#! use the function WriteAssociatorComputationToFiles.

#! @Description
#! The argument is a filename $s$.
#! This operation writes the database keys computed by the last call of InitializeGroupData
#! to the corresponding file.
#! @Returns nothing
#! @Arguments s
DeclareOperation( "WriteDatabaseKeysToFile", [ IsString ] );

#! @Description
#! The argument is a filename $s$.
#! This operation writes the representations computed by the last call of InitializeGroupData
#! to the corresponding file.
#! @Returns nothing
#! @Arguments s
DeclareOperation( "WriteRepresentationsDataToFile", [ IsString ] );

#! @Description
#! The argument is a filename $s$.
#! This operation writes the skeletal functor data computed
#! by the last call of SkeletalFunctorTensorData to the corresponding file.
#! @Returns nothing
#! @Arguments s
DeclareOperation( "WriteSkeletalFunctorDataToFile", [ IsString ] );

#! @Description
#! The argument is a filename $s$.
#! This operation writes the associator data of the initialized group to
#! the corresponding file. You have to call AssociatorForSufficientlyManyTriples first.
#! @Returns nothing
#! @Arguments s
DeclareOperation( "WriteAssociatorDataToFile", [ IsString ] );

#! @Description
#! Only call this function if you did a whole associator computation first
#! (e.g. using ComputeAssociator).
#! The argument is a string $s$.
#! This function writes 4 files:
#! * $s$Key.g: A file for the database key of the associator computation.
#! * $s$Reps.g: A file containing the irreducible representations used for the associator computation.
#! * $s$Dec.g: A file for the tensor decompositions used for the associator computation.
#! * $s$Ass.g or $s$AssD.g: A file containing the computed associator. The suffix $D$ is used if the associator was not computed for all triples. 
#! @Returns nothing
#! @Arguments s
DeclareOperation( "WriteAssociatorComputationToFiles", [ IsString ] );

#! @Description
#! The argument is a filename $s$ of a file written by WriteDatabaseKeysToFile.
#! The output is a list
#! [ group, conductor, position of trivial character, field, category ].
#! @Returns a list
#! @Arguments s
DeclareOperation( "ReadDatabaseKeys", [ IsString ] );

#! @Description
#! The arguments are a filename $s_1$ of a file written by WriteDatabaseKeysToFile,
#! and a filename $s_2$ of a file written by WriteRepresentationsDataToFile.
#! The output is a list
#! [ ,number of irreducibles, irreducibles, representations given by images of generators, inverses of these images, 
#! vector space objects for the irreducibles ].
#! @Returns a list
#! @Arguments s_1, s_2
DeclareOperation( "ReadRepresentationsData", [ IsString, IsString ] );

#! @Description
#! The arguments are a filename $s_1$ of a file written by WriteDatabaseKeysToFile,
#! and a filename $s_2$ of a file written by WriteSkeletalFunctorDataToFile.
#! The output is a list
#! [ irreducibles, skeletal functor tensor data, vector space objects for the irreducibles ].
#! @Returns a list
#! @Arguments s_1, s_2
DeclareOperation( "ReadSkeletalFunctorData", [ IsString, IsString ] );

DeclareOperation( "DisplaySkeletalFunctorTensorData", [ ] );

DeclareOperation( "DisplayInitializedGroupData", [ ] );

###################################
##
#! @Section Computing associators
##
###################################

#! @Description
#! The argument is a group $G$.
#! This method calls InitializeGroupData( G, false ).
#! @Returns a list
#! @Arguments G
DeclareOperation( "InitializeGroupData", [ IsGroup ] );

#! @Description
#! The arguments are a group $G$ and a boolean $b$.
#! The output is a list
#! [ generators of $G$ ,number of irreducibles, irreducibles, representations given by images of generators, inverses of these images, 
#! vector space objects for the irreducibles ].
#! Furthermore, this method stores the database key,
#! which can be written using WriteDatabaseKeysToFile.
#! If $b$ is true, then the id of the group in the database key is given by its string,
#! otherwise it is given by its id in the SmallGroupLibrary.
#! @Returns a list
#! @Arguments G, b
DeclareOperation( "InitializeGroupData", [ IsGroup, IsBool ] );

#! @Description
#! The argument is a group $G$.
#! This method calls InitializeGroupDataDixon( G, false ).
#! @Returns a list
#! @Arguments G
DeclareOperation( "InitializeGroupDataDixon", [ IsGroup ] );

#! @Description
#! The arguments are a group $G$ and a boolean $b$.
#! This method does the same as InitializeGroupData, but uses IrreducibleRepresentationsDixon
#! for affording irreducible representations.
#! @Returns a list
#! @Arguments G, b
DeclareOperation( "InitializeGroupDataDixon", [ IsGroup, IsBool ] );

#!
DeclareOperation( "InitializeGroupData", [ IsGroup, IsList, IsBool ] );

#! @Description
#! There is no argument.
#! This methods calls SkeletalFunctorTensorData with the output of the last call of InitializeGroupData
#! or InitializeGroupDataDixon.
#! @Returns a list
DeclareOperation( "SkeletalFunctorTensorData", [  ] );

#! @Description
#! The argument is a list $l$ which is the output of InitializeGroupData, InitializeGroupDataDixon,
#! or ReadRepresentationsData.
#! The output is a triple $[t_1,t_2,t_3]$. 
#! $t_1$ is the list of all characters of $G$.
#! $t_2$ is a list
#! such that the $(i,j)$-th entry, where $i,j$ range from 1 to the number of
#! irreducibles, is a pair of mutual inverse morphisms $[\alpha, \alpha^{-1}]$, and
#! $\alpha$ is a decomposition isomorphism
#! $\bigoplus_{\chi \in \mathrm{Irr}(G)}V_{\chi}^{n_{\chi}} \rightarrow V_i \otimes V_j$.
#! $t_3$ is a list of vector space objects for the irreducibles.
#! @Returns a list
#! @Arguments l
DeclareOperation( "SkeletalFunctorTensorData", [ IsList ] );

# TODO: 4th argument
#! @Description
#! The arguments are integers $a,b,c$ and a list $l$ which is the output of SkeletalFunctorTensorData.
#! The output is a list containing homalg matrices representing the components
#! of the associator of $V_a, V_b, V_c$, where the numbers correspond
#! to the enlisting of the irreducible characters given by $l$.
#! @Returns a list
#! @Arguments a,b,c,l
DeclareOperation( "AssociatorDataFromSkeletalFunctorTensorData",
                  [ IsInt, IsInt, IsInt, IsList ] );

#! @Description
#! There is no argument.
#! This methods calls AssociatorForSufficientlyManyTriples with the output of the last call of SkeletalFunctorTensorData
#! and false.
#! @Returns a list
DeclareOperation( "AssociatorForSufficientlyManyTriples", [ ] );

#! @Description
#! The arguments are a list $l$ which is the output of SkeletalFunctorTensorData,
#! and a boolean $b$.
#! The output is a list of lists $L$ such that $L[a][b][c]$ contains
#! the associator computed by AssociatorDataFromSkeletalFunctorTensorData(a,b,c).
#! If $b$ is true, then $a,b,c$ ranges through all possible triples,
#! otherwise, $a,b,c$ are computed for so many triples such that the others can be obtained using braidings.
#! @Returns a list
#! @Arguments l,b
DeclareOperation( "AssociatorForSufficientlyManyTriples", [ IsList, IsBool ] );

#! @Description
#! The arguments are a group $G$, and a boolean $b_1$.
#! The output is ComputeAssociator( G, b_1, false, true ).
#! @Returns a list
#! @Arguments G, b_1
DeclareOperation( "ComputeAssociator", [ IsGroup, IsBool ] );

#! @Description
#! The arguments are a group $G$, and two booleans $b_1$, $b_2$.
#! The output is ComputeAssociator( G, b_1, b_2, true ).
#! @Returns a list
#! @Arguments G, b_1, b_2
DeclareOperation( "ComputeAssociator", [ IsGroup, IsBool, IsBool ] );

#! @Description
#! The arguments are a group $G$, and three booleans $b_1$, $b_2$, $b_3$.
#! The output is a list $l$ whose $(a,b,c)$-th entry contains a string
#! representing the associator of the objects $V_a, V_b, V_c$ in a skeleton of
#! the representation category of $G$, where $V_{\ast}$ are irreducible
#! representations corresponding to the ordering of the irreducible characters Irr($G$).
#! If $b_1$ is true, this method uses IrreducibleRepresentationsDixon, otherwise it uses
#! IrreducibleAffordingRepresentation.
#! If $b_2$ is true, the associators are computed for all possible triples $a,b,c$,
#! otherwise only for sufficiently many such that the others can be reproduced using
#! the braiding in the representation category.
#! If $b_3$ is true, then the id of the group in the database key is given by its string,
#! otherwise it is given by its id in the SmallGroupLibrary. This last boolean is relevant
#! only if you want to write the computed associators to files (e.g. using WriteAssociatorComputationToFiles).
#! @Returns a list
#! @Arguments G, b_1, b_2, b_3
DeclareOperation( "ComputeAssociator", [ IsGroup, IsBool, IsBool, IsBool ] );
