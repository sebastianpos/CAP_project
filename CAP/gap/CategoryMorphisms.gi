#############################################################################
##
##                                               CAP package
##
##  Copyright 2013, Sebastian Gutsche, TU Kaiserslautern
##                  Sebastian Posur,   RWTH Aachen
##
#############################################################################

######################################
##
## Reps, types, stuff.
##
######################################

DeclareRepresentation( "IsCapCategoryMorphismRep",
                       IsAttributeStoringRep and IsCapCategoryMorphism,
                       [ ] );

BindGlobal( "TheFamilyOfCapCategoryMorphisms",
        NewFamily( "TheFamilyOfCapCategoryMorphisms" ) );

BindGlobal( "TheTypeOfCapCategoryMorphisms",
        NewType( TheFamilyOfCapCategoryMorphisms,
                IsCapCategoryMorphismRep ) );

######################################
##
## Properties logic
##
######################################
# 
# InstallTrueMethod( IsSplitMonomorphism and IsSplitEpimorphism, IsCapCategoryMorphism and IsIsomorphism );
# 
# InstallTrueMethod( IsAutomorphism, IsCapCategoryMorphism and IsOne );
# 
# InstallTrueMethod( IsIsomorphism and IsEndomorphism, IsCapCategoryMorphism and IsAutomorphism );
# 
# InstallTrueMethod( IsMonomorphism, IsCapCategoryMorphism and IsSplitMonomorphism );
# 
# InstallTrueMethod( IsEpimorphism, IsCapCategoryMorphism and IsSplitEpimorphism );
# 
# InstallTrueMethod( IsIsomorphism, IsMonomorphism and IsEpimorphism and IsAbelianCategory );#TODO: weaker?

#######################################
##
## Technical implications
##
#######################################

InstallValue( PROPAGATION_LIST_FOR_EQUAL_MORPHISMS,
              [  
                 "IsMonomorphism",
                 "IsEpimorphism",
                 "IsIsomorphism",
                 "IsEndomorphism",
                 "IsAutomorphism",
                 "IsSplitMonomorphism",
                 "IsSplitEpimorphism",
                 "IsOne",
                 "IsIdempotent",
                 "IsZero",
                 # ..
              ] );

######################################
##
## Operations
##
######################################

InstallMethod( Add,
               [ IsCapCategory, IsCapCategoryMorphism ],
               
  function( category, morphism )
    local filter;
    
    filter := MorphismFilter( category );
    
    if not filter( morphism ) then
        
        SetFilterObj( morphism, filter );
        
    fi;
    
    AddObject( category, Source( morphism ) );
    
    AddObject( category, Range( morphism ) );
    
    if category!.predicate_logic then
        
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Source", [ morphism ], Source( morphism ), category );
        
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Range", [ morphism ], Range( morphism ), category );
      
    fi;
    
    if HasCapCategory( morphism ) then
        
        if IsIdenticalObj( CapCategory( morphism ), category ) then
            
            return;
            
        else
            
            Error( "this morphism already has a category" );
            
        fi;
        
    fi;
    
    SetCapCategory( morphism, category );
    
end );

InstallMethod( AddMorphism,
               [ IsCapCategory, IsCapCategoryMorphism ],
               
  function( category, morphism )
    
    Add( category, morphism );
    
end );

InstallMethod( AddMorphism,
               [ IsCapCategory, IsObject ],
               
  function( category, morphism )
    
    SetFilterObj( morphism, IsCapCategoryMorphism );
    
    Add( category, morphism );
    
end );

##
InstallMethod( IsZero,
               [ IsCapCategoryMorphism ],
                  
IsZeroForMorphisms );

##
InstallMethod( \+,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
AdditionForMorphisms );

##
InstallMethod( \-,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
SubtractionForMorphisms );

##
InstallMethod( AdditiveInverse,
                  [ IsCapCategoryMorphism ],
                  
AdditiveInverseForMorphisms );

##
InstallMethod( IsEqualForCacheForMorphisms,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
  IsEqualForCache );


InstallMethod( AddMorphismRepresentation,
               [ IsCapCategory, IsObject ],
               
  function( category, representation )
    
    category!.morphism_representation := representation;
    category!.morphism_type := NewType( TheFamilyOfCapCategoryMorphisms, representation and MorphismFilter( category ) and IsCapCategoryMorphismRep );
    
end );

InstallGlobalFunction( ObjectifyMorphismForCAPWithAttributes,
                       
  function( arg_list... )
    local category, morphism;
    
    category := arg_list[ 2 ];
    arg_list[ 2 ] := category!.morphism_type;
    Append( arg_list, [ CapCategory, category ] );
    CallFuncList( ObjectifyWithAttributes, arg_list );
    
    if category!.predicate_logic then
        morphism := arg_list[ 1 ];
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Source", [ morphism ], Source( morphism ), category );
        INSTALL_TODO_FOR_LOGICAL_THEOREMS( "Range", [ morphism ], Range( morphism ), category );
    fi;
    
end );

######################################
##
## Morphism equality functions
##
######################################

##
InstallMethod( \=,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
  function( morphism_1, morphism_2 )
    
    if not IsEqualForObjects( Source( morphism_1 ), Source( morphism_2 ) ) or not IsEqualForObjects( Range( morphism_1 ), Range( morphism_2 ) ) then
        
        return false;
        
    fi;
    
    return IsCongruentForMorphisms( morphism_1, morphism_2 );
    
end );

##
InstallGlobalFunction( INSTALL_TODO_LIST_FOR_EQUAL_MORPHISMS,
                       
  function( morphism_1, morphism_2 )
    local category, i, entry;
    
    category := CapCategory( morphism_1 );
    
    for i in PROPAGATION_LIST_FOR_EQUAL_MORPHISMS do
        
        AddToToDoList( ToDoListEntryForEqualAttributes( morphism_1, i, morphism_2, i ) );
        
    od;
    
    if IsBound( category!.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS ) then
        
        for i in category!.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS do
            
            AddToToDoList( ToDoListEntryForEqualAttributes( morphism_1, i, morphism_2, i ) );
            
        od;
        
    fi;
    
end );

##
InstallMethod( AddPropertyToMatchAtIsCongruentForMorphisms,
               [ IsCapCategory, IsString ],
               
  function( category, name )
    
    if not IsBound( category!.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS ) then
        
        category!.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS := [ ];
        
    fi;
    
    if Position( category!.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS, name ) = fail then
        
        Add( category!.PROPAGATION_LIST_FOR_EQUAL_MORPHISMS, name );
        
    fi;
    
end );


######################################
##
## Convenience method
##
######################################

## FIXME: This might be dangerous
##
# InstallMethod( Zero,
#                [ IsCapCategoryMorphism ],
#                
#   function( mor )
#     
#     return ZeroMorphism( Source( mor ), Range( mor ) );
#     
# end );

##
InstallMethod( \-,
               [ IsCapCategoryMorphism, IsCapCategoryMorphism ],
               
  function( alpha, beta )
    
    return alpha + AdditiveInverse( beta );
    
end );

##
InstallMethod( PreCompose,
               [ IsList ],
               
  function( morphism_list )
    local length, result_morphism, i;
    
    length := Length( morphism_list );
    
    if length = 0 then
      
      Error( "non-empty list expected" );
      
    fi;
    
    result_morphism := morphism_list[1];
    
    for i in [ 2 .. length ] do
      
      result_morphism := PreCompose( result_morphism, morphism_list[i] );
      
    od;
    
    return result_morphism;
    
end );

##
InstallMethod( PostCompose,
               [ IsList ],
               
  function( morphism_list )
    local length, result_morphism, i;
    
    length := Length( morphism_list );
    
    if length = 0 then
      
      Error( "non-empty list expected" );
      
    fi;
    
    result_morphism := morphism_list[1];
    
    for i in [ 2 .. length ] do
      
      result_morphism := PostCompose( result_morphism, morphism_list[i] );
      
    od;
    
    return result_morphism;
    
end );

######################################
##
## Morphism transport
##
######################################

## mor: x -> y
## equality_source: x -> x'
## equality_range: y -> y'
## TransportHom( mor, equality_source, equality_range ): x' -> y'
##
InstallMethodWithCacheFromObject( TransportHom,
                                  [ IsCapCategoryMorphism, IsCapCategoryMorphism, IsCapCategoryMorphism ],
                                  
  function( mor, equality_source, equality_range )
    
    return PreCompose(
             Inverse( equality_source ),
             PreCompose( mor, equality_range )
           );
    
end );

###########################
##
## IsWellDefined
##
###########################

##
InstallMethod( IsWellDefinedForMorphisms,
               [ IsCapCategoryMorphism ],
               
  IsWellDefined
);

###########################
##
## Print
##
###########################

##
InstallGlobalFunction( CAP_INTERNAL_CREATE_MORPHISM_PRINT,
                       
  function( )
    local print_graph, morphism_function;
    
    morphism_function := function( object )
      local string;
        
        string := "morphism in ";
        
        Append( string, Name( CapCategory( object ) ) );
        
        return string;
        
    end;
    
    print_graph := CreatePrintingGraph( IsCapCategoryMorphism and HasCapCategory, morphism_function );
    
    AddRelationToGraph( print_graph,
                        rec( Source := [ rec( Conditions := "IsIsomorphism",
                                              PrintString := "iso",
                                              Adjective := true,
                                              NoSepString := true ) ],
                             Range := [ rec( Conditions := "IsSplitMonomorphism",
                                             PrintString := "split mono",
                                             TypeOfView := "ViewObj",
                                             ComputeLevel := "AllWithCompute",
                                             Adjective := true,
                                              NoSepString := true ),
                                        rec( Conditions := "IsSplitEpimorphism",
                                             PrintString := "split epi",
                                             Adjective := true,
                                              NoSepString := true ) ] ) );
    
    AddRelationToGraph( print_graph,
                        rec( Source := [ rec( Conditions := "IsOne",
                                              PrintString := "identity",
                                              Adjective := true ) ],
                             Range := [ rec( Conditions := "IsAutomorphism",
                                             PrintString := "auto",
                                             Adjective := true,
                                             NoSepString := true ),
                                        "IsIsomorphism" ] ) );
    
    AddRelationToGraph( print_graph,
                        rec( Source := [ "IsAutomorphism" ],
                             Range := [ "IsIsomorphism",
                                        rec( Conditions := "IsEndomorphism",
                                             PrintString := "endo",
                                             Adjective := true,
                                             NoSepString := true) ] ) );
    
    AddRelationToGraph( print_graph,
                        rec( Source := [ "IsSplitMonomorphism" ],
                             Range := [ rec( Conditions := "IsMonomorphism",
                                             PrintString := "mono",
                                             Adjective := true,
                                             NoSepString := true ) ] ) );
    
    AddRelationToGraph( print_graph,
                        rec( Source := [ "IsSplitEpimorphism" ],
                             Range := [ rec( Conditions := "IsEpimorphism",
                                             PrintString := "epi",
                                             Adjective := true,
                                             NoSepString := true ) ] ) );
    
    AddNodeToGraph( print_graph,
                    rec( Conditions := "IsZeroForMorphisms",
                         PrintString := "zero",
                         Adjective := true ) );
    
    InstallPrintFunctionsOutOfPrintingGraph( print_graph, -1 );
    
end );

CAP_INTERNAL_CREATE_MORPHISM_PRINT( );

InstallMethod( String,
               [ IsCapCategoryMorphism and HasCapCategory ],
               
  function( morphism )
    
    return Concatenation( "A morphism in ", Name( CapCategory( morphism ) ) );
    
end );
