#
# CAP: Categories, Algorithms, Programming
#
# Declarations
#
#! @Chapter Finalize

DeclareGlobalVariable( "CAP_INTERNAL_FINAL_DERIVATION_LIST" );


DeclareGlobalFunction( "AddFinalDerivation" );


DeclareProperty( "IsFinalized",
                  IsCapCategory );

DeclareOperation( "Finalize",
                  [ IsCapCategory ] );

