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
InstallMethod( LocalizationProblemFunctionForPrimeIdeal,
               [ IsHomalgRing, IsHomalgMatrix ],
    function( ring, column_for_ideal )
        local f;
        
        f := function( mat )
            local nr_cols, i, A;
            nr_cols := NrColumns( mat );
            
            for i in [ 1 .. nr_cols ] do
                
                A := CertainColumns( mat, [ i ] );
                
                if not IsZero( DecideZeroRows( A, column_for_ideal ) ) then
                    
                    return CertainRows( HomalgIdentityMatrix( nr_cols, ring ), [ i ] );
                    
                fi;
                
            od;
            
            return false;
            
        end;
        
        return f;
end );
