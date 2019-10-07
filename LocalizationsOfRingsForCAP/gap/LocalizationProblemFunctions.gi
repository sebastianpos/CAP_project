#############################################################################
##
##  Copyright 2019, Sebastian Posur, University of Siegen
##
#############################################################################

####################################
##
## Constructors
##
####################################

## localization_data
## a record specifying the multiplicatively closed set S
##
## Specifications of the record entries
##
## zero_in_S
## Description
## Boolean value, describes if S contains zero. If yes, one deals with modules over the zero ring.

## IntersectionIdealSWitness:
## Description
## A function.
## The argument is an $(n \times 1)$ homalg matrix $A$.
## The output is a $(1 \times n)$ row $B$ such that $B \cdot A$ is an element in $S$.
## If no such $B$ exists, the output is <C>false</C>.
#! @Arguments a column matrix
#! @Returns a row matrix or false

## IntersectionIdealSBool:
## Description
## A function.
## Like <C>IntersectionIdealSWitness</C>, but in the case where $B$ exists, the output is <C>true</C>.
#! @Arguments a column matrix
#! @Returns a boolean

##
InstallMethod( LocalizationAtPrimeIdealData,
               [ IsHomalgRing, IsHomalgMatrix ],
    function( ring, column_for_ideal )
        
        return 
            rec(
                zero_in_S := false,
                IntersectionIdealSWitness := function( mat )
                    local nr_rows, i, A;
                    nr_rows := NrRows( mat );
                    
                    for i in [ 1 .. nr_rows ] do
                        
                        A := CertainRows( mat, [ i ] );
                        
                        if not IsZero( DecideZeroRows( A, column_for_ideal ) ) then
                            
                            return CertainRows( HomalgIdentityMatrix( nr_rows, ring ), [ i ] );
                            
                        fi;
                        
                    od;
                    
                    return false;
                    
                end,
                IntersectionIdealSBool := function( mat )
                    local nr_rows, i, A;
                    nr_rows := NrRows( mat );
                    
                    for i in [ 1 .. nr_rows ] do
                        
                        A := CertainRows( mat, [ i ] );
                        
                        if not IsZero( DecideZeroRows( A, column_for_ideal ) ) then
                            
                            return true;
                            
                        fi;
                        
                    od;
                    
                    return false;
                    
                end,
        );
end );

##
InstallMethod( LocalizationAtPolynomialsNotMeetingThePolydisk,
               [ IsHomalgRing ],
    function( ring )
        local maple_stream, path;
        
        maple_stream := LaunchCAS( "HOMALG_IO_Maple" );
        
        path := PackageInfo( "LocalizationsOfRingsForCAP" )[1].InstallationPath;
        
        homalgSendBlocking( 
            Concatenation(
                "read \"",
                path,
                """/maple/IntersectionPolydisk.mpl""",
                "\" "
            ),
            maple_stream,
            "need_command" );
        
        return
            rec(
                zero_in_S := false,
                IntersectionIdealSBool := function( mat )
                    local str, output;
                    
                    ## Depending on <ring>, this string might have to be adjusted
                    str := String( EntriesOfHomalgMatrix( mat ) );
                    
                    output := homalgSendBlocking( Concatenation( "IntersectionPolydisk( ", str, ")" ), maple_stream, "need_output" );
                    
                    return output = "true";
                    
                end
            );
        
end );
