#############################################################################
##
##  ComplexesForCAP package             Kamal Saleh 
##  2017                                University of Siegen
##
##  Chapter Functors
##
#############################################################################


####################################
#
#    Functors 
#
####################################

BindGlobal( "COKERNEL_OBJECT_AS_FUNCTOR", 
     function( cat, i, string )

     local functor, complex_cat, name, index;
     
     if string = "chains" then
     
        complex_cat := ChainComplexCategory( cat );
     
        index := -1;

        name := Concatenation( "Functor of cokernel object of the ", String( i ), "'th differential in ", Big_to_Small( Name( complex_cat ) ) );
     
     else
     
        complex_cat := CochainComplexCategory( cat );
     
        index := 1;

        name := Concatenation( "Functor of cokernel object of the ", String( i ), "'th differential in ", Big_to_Small( Name( complex_cat ) ) );
     
     fi;
     
     functor := CapFunctor( name, complex_cat, cat );

     AddObjectFunction( functor, 

     function( complex )

       return CokernelObject( complex^i );

     end );
     
     AddMorphismFunction( functor,

     function( new_source, map, new_range )

       return CokernelObjectFunctorial( Source( map )^i, map[ i + index ], Range( map )^i );

     end );
     
     return functor;

end );

BindGlobal( "KERNEL_OBJECT_AS_FUNCTOR", 
     function( cat, i, string )

     local functor, complex_cat, name, index;
     
     if string = "chains" then
     
        complex_cat := ChainComplexCategory( cat );
     
        name := Concatenation( "Functor of kernel object of the ", String( i ), "'th differential in ", Big_to_Small( Name( complex_cat ) ) );
     
     else
     
        complex_cat := CochainComplexCategory( cat );

        name := Concatenation( "Functor of kernel object of the ", String( i ), "'th differential in ", Big_to_Small( Name( complex_cat ) ) );
     
     fi;
     
     functor := CapFunctor( name, complex_cat, cat );

     AddObjectFunction( functor, 

     function( complex )

       return KernelObject( complex^i );

     end );
     
     AddMorphismFunction( functor,

     function( new_source, map, new_range )

       return KernelObjectFunctorial( Source( map )^i, map[ i ], Range( map )^i );

     end );
     
     return functor;

end );


# Homology and Cohomology functors

BindGlobal( "HOMOLOGY_OR_COHOMOLOGY_AS_FUNCTOR", 
    function( cat, i, string )
      local functor, complex_cat, name;
      
      if string = "Homology" then
        
        complex_cat := ChainComplexCategory( cat );
     
        name := Concatenation( String( i ), "-th homology functor in ", Big_to_Small( Name( cat ) ) );
      
      else
        
        complex_cat := CochainComplexCategory( cat );
        
        name := Concatenation( String( i ), "-th cohomology functor in ", Big_to_Small( Name( cat ) ) );
      fi;
     
      functor := CapFunctor( name, complex_cat, cat );

      AddObjectFunction( functor, 

      function( complex )

        return HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX( complex, i );

      end );
     
      AddMorphismFunction( functor,

      function( new_source, map, new_range )

        return HOMOLOGY_OR_COHOMOLOGY_OF_COMPLEX_FUNCTORIAL( map, i );

      end );
     
     return functor;

end );


BindGlobal( "SHIFT_AS_FUNCTOR",
    function( complex_cat, n )
   local name, shift, morphism_constructor;
   
   if IsChainComplexCategory( complex_cat ) then 

      morphism_constructor := ChainMorphism;

   elif IsCochainComplexCategory( complex_cat ) then 

      morphism_constructor := CochainMorphism;

   else 

      Error( "The category should be either chain or cochain complexes category" );

   fi;
   
   if n = 0 then 

      return IdentityFunctor( complex_cat );

   elif n>0 then 

      name := Concatenation( "Shift (", String( n ), " times to the left) functor in ", Big_to_Small( Name( complex_cat ) ) );

   else

      name := Concatenation( "Shift (", String( -n ), " times to the right) functor in ", Big_to_Small( Name( complex_cat ) ) );

   fi;
   
   shift := CapFunctor( name, complex_cat, complex_cat );
   
   AddObjectFunction( shift, 

     function( complex )

       return ShiftLazy( complex, n );

     end );
 
   AddMorphismFunction( shift, 

      function( new_source, map, new_range )

     local morphisms;

     morphisms := Morphisms( map );

     morphisms := ShiftLazy( morphisms, n );

     morphisms := morphism_constructor( new_source, new_range, morphisms );

     INSTALL_TODO_LIST_FOR_CO_CHAIN_MORPHISMS( map, morphisms );

     return morphisms;

     end );

   return shift;

end );

BindGlobal( "UNSIGNED_SHIFT_AS_FUNCTOR",
   function( complex_cat, n )
   local name, shift, morphism_constructor;
   
   if IsChainComplexCategory( complex_cat ) then 

      morphism_constructor := ChainMorphism;

   elif IsCochainComplexCategory( complex_cat ) then 

      morphism_constructor := CochainMorphism;

   else 

      Error( "The category should be either chain or cochain complexes category" );

   fi;
   
   if n = 0 then 

      return IdentityFunctor( complex_cat );

   elif n>0 then 

      name := Concatenation( "Unsigned shift (", String( n ), " times to the left) functor in ", Big_to_Small( Name( complex_cat ) ) );

   else

      name := Concatenation( "Unsigned shift (", String( -n ), " times to the right) functor in ", Big_to_Small( Name( complex_cat ) ) );

   fi;
   
   shift := CapFunctor( name, complex_cat, complex_cat );
   
   AddObjectFunction( shift, 

     function( complex )

       return ShiftUnsignedLazy( complex, n );

     end );

   AddMorphismFunction( shift, 

     function( new_source, map, new_range )

     local morphisms;

     morphisms := Morphisms( map );

     morphisms := ShiftLazy( morphisms, n );

     morphisms := morphism_constructor( new_source, new_range, morphisms );

     INSTALL_TODO_LIST_FOR_CO_CHAIN_MORPHISMS( map, morphisms );

     return morphisms;

     end );

   return shift;

end );

BindGlobal( "CHAIN_TO_COCHAIN_OR_COCHAIN_TO_CHAIN_FUNCTOR",
   function( cat, string )

   local chain_complexes, cochain_complexes, complex_constructor, name, functor, morphism_constructor; 

   chain_complexes := ChainComplexCategory( cat );

   cochain_complexes := CochainComplexCategory( cat );

   if string = "chain_to_cochain" then

      name := Concatenation("Chain to Cochain complex functor over ", Big_to_Small( Name( cat ) ) );

      functor := CapFunctor( name, chain_complexes, cochain_complexes );

      complex_constructor := CochainComplex;

      morphism_constructor := CochainMorphism;

   elif string = "cochain_to_chain" then 

      name := Concatenation("Cochain to chain complex functor over ", Name( cat ) );

      functor := CapFunctor( name, cochain_complexes, chain_complexes );

      complex_constructor := ChainComplex;

      morphism_constructor := ChainMorphism;

   else 

      Error( "string should be either chain_to_cochain or cochain_to_chain" );

   fi;

   AddObjectFunction( functor,
     function( C )
     local diffs, complex;

       diffs := Reflection( Differentials( C ) );

       complex := complex_constructor( cat, diffs );

       AddToToDoList( ToDoListEntryForEqualAttributes( C, "IsZeroForObjects", complex, "IsZeroForObjects" ) );

       AddToToDoList( ToDoListEntry( [ [ C, "HAS_FAU_BOUND", true ] ], function( )

                                                                   if not HasFAL_BOUND( complex ) then

                                                                      SetLowerBound( complex, -FAU_BOUND( C ) );

                                                                   fi;

                                                                   end ) );

       AddToToDoList( ToDoListEntry( [ [ complex, "HAS_FAU_BOUND", true ] ], function( )

                                                                   if not HasFAL_BOUND( C ) then

                                                                      SetLowerBound( C, -FAU_BOUND( complex ) );

                                                                   fi;

                                                                   end ) );
  
      AddToToDoList( ToDoListEntry( [ [ C, "HAS_FAL_BOUND", true ] ], function( )

                                                                   if not HasFAU_BOUND( complex ) then
  
                                                                      SetUpperBound( complex, -FAL_BOUND( C ) );

                                                                   fi;

                                                                   end ) );

      AddToToDoList( ToDoListEntry( [ [ complex, "HAS_FAL_BOUND", true ] ], function( )

                                                                   if not HasFAU_BOUND( C ) then

                                                                      SetUpperBound( C, -FAL_BOUND( complex ) );

                                                                   fi;

                                                                   end ) );

     return complex;

     end );
 
   AddMorphismFunction( functor, 
      function( new_source, map, new_range )
     local morphisms;

        morphisms := Reflection( Morphisms( map ) );

        morphisms := morphism_constructor( new_source, new_range, morphisms );

        INSTALL_TODO_LIST_FOR_CO_CHAIN_MORPHISMS( map, morphisms );

        return morphisms;

     end );

   return functor;
 
end );

BindGlobal( "FUNCTORS_INSTALLER",
   function( )

InstallMethod( KernelObjectFunctor, 
               [ IsChainOrCochainComplexCategory, IsCapCategory, IsInt ],
  function( complex_cat, cat, i )

    if IsChainComplexCategory( complex_cat ) then 
        return KERNEL_OBJECT_AS_FUNCTOR( cat, i, "chains" );
    elif IsCochainComplexCategory( complex_cat ) then
        return KERNEL_OBJECT_AS_FUNCTOR( cat, i, "cochains" );
    else
        Error( "The input is wrong" );
    fi;

end );

InstallMethod( CokernelObjectFunctor, 
               [ IsChainOrCochainComplexCategory, IsCapCategory, IsInt ],
  function( complex_cat, cat, i )

    if IsChainComplexCategory( complex_cat ) then 
        return COKERNEL_OBJECT_AS_FUNCTOR( cat, i, "chains" );
    elif IsCochainComplexCategory( complex_cat ) then
        return COKERNEL_OBJECT_AS_FUNCTOR( cat, i, "cochains" );
    else
        Error( "The input is wrong" );
    fi;

end );


InstallMethod( HomologyFunctorAt, 
               [ IsChainComplexCategory, IsCapCategory, IsInt ],
  function( complex_cat, cat, i )

  return HOMOLOGY_OR_COHOMOLOGY_AS_FUNCTOR( cat, i, "Homology" );

end );

InstallMethod( CohomologyFunctorAt, 
               [ IsCochainComplexCategory, IsCapCategory, IsInt ],
  function( complex_cat, cat, i )

  return HOMOLOGY_OR_COHOMOLOGY_AS_FUNCTOR( cat, i, "Cohomology" );

end );

InstallMethod( ShiftFunctor, 
                [ IsChainOrCochainComplexCategory, IsInt ], 
  function( complex_cat, n )

  return SHIFT_AS_FUNCTOR( complex_cat, n );

end );

InstallMethod( UnsignedShiftFunctor, 
                [ IsChainOrCochainComplexCategory, IsInt ],
  function( complex_cat, n )

  return UNSIGNED_SHIFT_AS_FUNCTOR( complex_cat, n );

end );

InstallMethod( ChainToCochainComplexFunctor, 
               [ IsChainComplexCategory, IsCochainComplexCategory ], 
   function( cat1, cat2  )

   return CHAIN_TO_COCHAIN_OR_COCHAIN_TO_CHAIN_FUNCTOR( UnderlyingCategory( cat1 ), "chain_to_cochain" );

   end );

InstallMethod( CochainToChainComplexFunctor, 
               [ IsCochainComplexCategory, IsChainComplexCategory ], 
   function( cat1, cat2 )

   return CHAIN_TO_COCHAIN_OR_COCHAIN_TO_CHAIN_FUNCTOR( UnderlyingCategory( cat1 ), "cochain_to_chain" );

end );

InstallMethod( ExtendFunctorToChainComplexCategoryFunctor,
               [ IsCapFunctor ],
   function( F )
   local S, T, functor, name;

   S := ChainComplexCategory( AsCapCategory( Source( F ) ) );

   T := ChainComplexCategory( AsCapCategory(  Range( F ) ) );

   name := Concatenation( "Extended version of ", Big_to_Small( Name( F ) ), " from ", Big_to_Small( Name( S ) ), " to ", Big_to_Small( Name( T ) ) );

   functor := CapFunctor( name, S, T );

   AddObjectFunction( functor,
     function( C )
     local diffs, functor_C;

     diffs := MapLazy( Differentials( C ), function( d )

                                           return ApplyFunctor( F, d );

                                           end, 1 );

     functor_C := ChainComplex( AsCapCategory( Range( F ) ), diffs );

     TODO_LIST_TO_PUSH_BOUNDS( C, functor_C );

     AddToToDoList( ToDoListEntry( [ [ C, "IsZeroForObjects", true ] ], function( )

                                                              if not HasIsZeroForObjects( functor_C ) then 

                                                                 SetIsZeroForObjects( functor_C, true );

                                                              fi;

                                                              end ) );

     return functor_C;

     end );

   AddMorphismFunction( functor, 
     function( new_source, phi, new_range ) 
     local morphisms, functor_phi;

       morphisms := MapLazy( Morphisms( phi ), function( psi )

                                                return ApplyFunctor( F, psi );

                                               end, 1 );

       functor_phi := ChainMorphism( new_source, new_range, morphisms );

       TODO_LIST_TO_PUSH_BOUNDS( phi, functor_phi );

       AddToToDoList( ToDoListEntry( [ [ phi, "IsZeroForMorphisms", true ] ], function( )

                                                                  if not HasIsZeroForMorphisms( functor_phi ) then

                                                                     SetIsZeroForMorphisms( functor_phi, true );

                                                                  fi; 

                                                                  end ) );

       return functor_phi;

     end );

   return functor;

end );

InstallMethod( ExtendFunctorToCochainComplexCategoryFunctor,
               [ IsCapFunctor ],
   function( F )
   local S, T, functor, name;

   S := CochainComplexCategory( AsCapCategory( Source( F ) ) );

   T := CochainComplexCategory( AsCapCategory(  Range( F ) ) );

   name := Concatenation( "Extended version of ", Big_to_Small( Name( F ) ), " from ", Big_to_Small( Name( S ) ), " to ", Big_to_Small( Name( T ) ) );

   functor := CapFunctor( name, S, T );

   AddObjectFunction( functor,
     function( C )
     local diffs, functor_C;

     diffs := MapLazy( Differentials( C ), function( d )

                                           return ApplyFunctor( F, d );

                                           end, 1 );
 
     functor_C := CochainComplex( AsCapCategory( Range( F ) ), diffs );

     TODO_LIST_TO_PUSH_BOUNDS( C, functor_C );

     AddToToDoList( ToDoListEntry( [ [ C, "IsZeroForObjects", true ] ], function( )

                                                              if not HasIsZeroForObjects( functor_C ) then

                                                                 SetIsZeroForObjects( functor_C, true );

                                                              fi;

                                                              end ) );
     return functor_C;

     end );

   AddMorphismFunction( functor, 
     function( new_source, phi, new_range ) 
     local morphisms, functor_phi;

       morphisms := MapLazy( Morphisms( phi ), function( psi )

                                                return ApplyFunctor( F, psi );

                                               end, 1 );

       functor_phi := CochainMorphism( new_source, new_range, morphisms );

       TODO_LIST_TO_PUSH_BOUNDS( phi, functor_phi );

       AddToToDoList( ToDoListEntry( [ [ phi, "IsZeroForMorphisms", true ] ], function( )

                                                                  if not HasIsZeroForMorphisms( functor_phi ) then

                                                                     SetIsZeroForMorphisms( functor_phi, true );

                                                                  fi;

                                                                  end ) );

       return functor_phi;


     end );

   return functor;

end );

##
InstallMethod( ChainCategoryToCochainCategoryOfOppositeCategory,
                [ IsCapCategory ],
    function( cat )
    local chains, cochains, functor;
    
    chains := ChainComplexCategory( cat );
    cochains := CochainComplexCategory( Opposite( cat ) );
    
    functor := CapFunctor( "Bla Bla", chains, cochains );
    AddObjectFunction( functor,
        function( C )
        local inf_list;
        inf_list := MapLazy( Differentials( C ), Opposite, 1 );
        inf_list := ShiftLazy( inf_list, 1 );
        return CochainComplex( Opposite( cat ), inf_list );
        end );
    AddMorphismFunction( functor,
        function( obj1, phi, obj2 )
        local inf_list;
        inf_list := MapLazy( Morphisms( phi ), Opposite, 1 );
        return CochainMorphism( obj1, obj2, inf_list );
        end );
    return functor;
end );

##
InstallMethod( CochainCategoryToChainCategoryOfOppositeCategory,
                [ IsCapCategory ],
    function( cat )
    local chains, cochains, functor;
    
    cochains := CochainComplexCategory( cat );
    chains := ChainComplexCategory( Opposite( cat ) );
    
    functor := CapFunctor( "Bla Bla", cochains, chains );
    AddObjectFunction( functor,
        function( C )
        local inf_list;
        inf_list := MapLazy( Differentials( C ), Opposite, 1 );
        inf_list := ShiftLazy( inf_list, -1 );
        return ChainComplex( Opposite( cat ), inf_list );
        end );
    AddMorphismFunction( functor,
        function( obj1, phi, obj2 )
        local inf_list;
        inf_list := MapLazy( Morphisms( phi ), Opposite, 1 );
        return ChainMorphism( obj1, obj2, inf_list );
        end );
    return functor;
end );

InstallMethod( BrutalTruncationAboveFunctorOp,
        [ IsCapCategory and IsCochainComplexCategory, IsInt ],
    function( cochains, n )
    local name, F;

    name := Concatenation( "Functor of brutal truncation from above (C -> C^<= ", String( n ), ") in ", Name( cochains ) );
    F := CapFunctor( name, cochains, cochains );
    AddObjectFunction( F,
    function( C )
      return BrutalTruncationAbove( C, n );
    end );

    AddMorphismFunction( F,
    function( new_source, phi, new_range )
    local morphisms;
    morphisms := MapLazy( IntegersList, 
                            function( i ) 
                            if i <= n then 
                              return phi[ i ];
                            else
                              return ZeroMorphism( new_source[ i ], new_range[ i ] );
                            fi;
                            end, 1 );
    return CochainMorphism( new_source, new_range, morphisms );   
    end );
    return F;
end );

InstallMethod( BrutalTruncationBelowFunctorOp,
        [ IsCapCategory and IsCochainComplexCategory, IsInt ],
    function( cochains, n )
    local name, F;

    name := Concatenation( "Functor of brutal truncation from below (C -> C^> ", String( n ), ") in ", Name( cochains ) );
    F := CapFunctor( name, cochains, cochains );
    AddObjectFunction( F,
    function( C )
      return BrutalTruncationBelow( C, n );
    end );

    AddMorphismFunction( F,
    function( new_source, phi, new_range )
    local morphisms;
    morphisms := MapLazy( IntegersList, 
                            function( i ) 
                            if i > n then 
                              return phi[ i ];
                            else
                              return ZeroMorphism( new_source[ i ], new_range[ i ] );
                            fi;
                            end, 1 );
    return CochainMorphism( new_source, new_range, morphisms );
    end );
    return F;
end );

InstallMethod( BrutalTruncationAboveFunctorOp,
        [ IsCapCategory and IsChainComplexCategory, IsInt ],
    function( chains, n )
    local name, F;

    name := Concatenation( "Functor of brutal truncation from above (C -> C_< ", String( n ), ") in ", Name( chains ) );
    F := CapFunctor( name, chains, chains );
    AddObjectFunction( F,
    function( C )
      return BrutalTruncationAbove( C, n );
    end );

    AddMorphismFunction( F,
    function( new_source, phi, new_range )
    local morphisms;
    morphisms := MapLazy( IntegersList, 
                            function( i ) 
                            if i < n then 
                              return phi[ i ];
                            else
                              return ZeroMorphism( new_source[ i ], new_range[ i ] );
                            fi;
                            end, 1 );
    return ChainMorphism( new_source, new_range, morphisms );   
    end );
    return F;
end );

InstallMethod( BrutalTruncationBelowFunctorOp,
        [ IsCapCategory and IsChainComplexCategory, IsInt ],
    function( chains, n )
    local name, F;

    name := Concatenation( "Functor of brutal truncation from below (C -> C_>= ", String( n ), ") in ", Name( chains ) );
    F := CapFunctor( name, chains, chains );
    AddObjectFunction( F,
    function( C )
      return BrutalTruncationBelow( C, n );
    end );

    AddMorphismFunction( F,
    function( new_source, phi, new_range )
    local morphisms;
    morphisms := MapLazy( IntegersList, 
                            function( i ) 
                            if i >= n then 
                              return phi[ i ];
                            else
                              return ZeroMorphism( new_source[ i ], new_range[ i ] );
                            fi;
                            end, 1 );
    return ChainMorphism( new_source, new_range, morphisms );
    end );
    return F;
end );

# to do this you need to construct chain morphism between resolutions of A, B for every f : A --> B.
# InstallMethod( LeftDerivedFunctor, 
#                [ IsCapFunctor ],
#   function( F )
#   local
#   S := AsCapCategory( Source( F ) );
# 
#   T := AsCapCategory(  Range( F ) );
# 
#   name := Concatenation( "Left derived functor of ", Name( F ) );
#   
#   dF := CapFunctor( name, S, T );
#   
#   AddObjectFunction( dF, function( obj )
#                          local C;
#                          C := StalkCochainComplex( obj, 0 );
# 
#   dF := 

end );

FUNCTORS_INSTALLER( );

