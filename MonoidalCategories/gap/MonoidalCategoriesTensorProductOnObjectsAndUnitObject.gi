##
InstallMethod( AddTensorUnit,
               [ IsCapCategory, IsFunction, IsInt ],
               
  function( category, func, weight )
    local wrapped_func;
    
    wrapped_func := function( cat ) return func(); end;
    
    AddTensorUnit( category, [ [ wrapped_func, [ ] ] ], weight );
    
end );

##
InstallMethod( TensorProductOp,
               [ IsList, IsCapCategoryObject ],
               
  function( list, object )
    local size, i;
    
    size := Size( list );
    
    if size = 1 then
        
        return object;
        
    else
        
        for i in [ 2 .. size ] do
            
            object := TensorProductOnObjects( object, list[i] );
            
        od;
        
    fi;
    
    return object;
    
end );

##
InstallMethod( TensorProductOp,
               [ IsList, IsCapCategoryMorphism ],
               
  function( list, morphism )
    local size, i;
    
    size := Size( list );
    
    if size = 1 then
        
        return morphism;
        
    else
        
        for i in [ 2 .. size ] do
            
            morphism := TensorProductOnMorphisms( morphism, list[i] );
            
        od;
        
    fi;
    
    return morphism;
    
end );
