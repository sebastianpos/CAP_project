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

##
InstallMethod( LocalizationAtPrimeIdealData,
               [ IsHomalgRing, IsHomalgMatrix ],
    function( ring, column_for_ideal )
        
        return 
            rec(
                IntersectionIdealSWitness := function( mat )
                    local nr_cols, i, A;
                    nr_cols := NrColumns( mat );
                    
                    for i in [ 1 .. nr_cols ] do
                        
                        A := CertainColumns( mat, [ i ] );
                        
                        if not IsZero( DecideZeroRows( A, column_for_ideal ) ) then
                            
                            return CertainRows( HomalgIdentityMatrix( nr_cols, ring ), [ i ] );
                            
                        fi;
                        
                    od;
                    
                    return false;
                    
                end,
                IntersectionIdealSBool := function( mat )
                    local nr_cols, i, A;
                    nr_cols := NrColumns( mat );
                    
                    for i in [ 1 .. nr_cols ] do
                        
                        A := CertainColumns( mat, [ i ] );
                        
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
                IntersectionIdealSBool := function( mat )
                    local str, output;
                    
                    ## Depending on <ring>, this string might have to be adjusted
                    str := String( EntriesOfHomalgMatrix( mat ) );
                    
                    output := homalgSendBlocking( Concatenation( "IntersectionPolydisk( ", str, ")" ), maple_stream, "need_output" );
                    
                    return output = "true";
                    
                end
            );
        
end );
