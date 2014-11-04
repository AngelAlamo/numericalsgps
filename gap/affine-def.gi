#############################################################################
##
#W  ideals-def.gi           Manuel Delgado <mdelgado@fc.up.pt>
#W                          Pedro Garcia-Sanchez <pedro@ugr.es>
#Y  Copyright ........
#############################################################################
#################        Defining Affine Semigroups           ###############
###############################################################################
##
#F AffineSemigroupByGenerators(arg)
##
## Returns the affine semigroup generated by arg.
##
## The argument arg is either a list of lists of positive integers of equal length (a matrix) or consists of lists of integers with equal length
#############################################################################
InstallGlobalFunction(AffineSemigroupByGenerators, function(arg)
  local  gens, M;
  
    
  if Length(arg) = 1 then
    gens := Set(arg[1]);
  else
    gens := Set(arg);
  fi;
  
  if not IsMatrix(gens) then
    Error("The arguments must be lists of non negative integers with the same length, or a list of such lists");
  elif not ForAll(gens, l -> ForAll(l,x -> (IsPosInt(x) or x = 0))) then
    Error("The arguments must be lists of non negative integers with the same length, or a list of such lists");
  fi;
  M:= Objectify( NewType( FamilyObj( gens ),
              IsAttributeStoringRep and IsAffineSemigroup), rec());
  
  SetGeneratorsAS(M,gens);
  
  Setter(IsAffineSemigroupByGenerators)(M,true);
  return M;
end);
#############################################################################
## Full ffine semigroups
#############################################################################
##
#F  AffineSemigroupByEquations(ls,md)
##
##  Returns the (full) affine semigroup defined by the system A X=0 mod md, where the rows
## of A are the elements of ls.
##
#############################################################################
InstallGlobalFunction(AffineSemigroupByEquations, function(ls,md)
  local  basis, M;
  
  basis := HilbertBasisOfSystemOfHomogeneousEquations(ls,md);
  
  M := AffineSemigroupByGenerators(basis);
  SetEquationsAS([ls,md]);
  Setter(IsAffineSemigroupByEquations)(M,true);
  Setter(IsFullAffineSemigroup)(M,true);
  return M;
end);


#############################################################################
##
#F  AffineSemigroupByInequalities(ls)
##
##  Returns the (full) affine semigroup defined by the system  ls*X>=0 over the nonnegative 
## integers
##
#############################################################################
InstallGlobalFunction(AffineSemigroupByInequalities, function(ls)
  local  basis, M;

  basis := HilbertBasisOfSystemOfHomogeneousInequalities(ls);
  
  M := AffineSemigroupByGenerators(basis);
  SetInequalitiesAS(ls);
  Setter(IsAffineSemigroupByEquations)(M,true);
  Setter(IsFullAffineSemigroup)(M,true);
  return M;
end);


#############################################################################

#############################################################################
##
#F  AffineSemigroup(arg)
##
##  This function's first argument may be one of:
##  "generators", "minimalgenerators", 
## UNDER CONSTRUCTION: equations...
##
##  The following arguments must conform to the arguments of
##  the corresponding function defined above.
##  By default, the option "generators" is used, so,
##  gap> AffineSemigroup([1,3],[7,2],[1,5]);
##  <Affine semigroup in 3-dimensional space, with 3 generators>
##
##
#############################################################################
 InstallGlobalFunction(AffineSemigroup, function(arg)

   if IsString(arg[1]) then
     if arg[1] = "generators" then
       return AffineSemigroupByGenerators(arg{[2..Length(arg)]});
     elif arg[1] = "minimalgenerators" then
       return AffineSemigroupByMinimalGenerators(arg{[2..Length(arg)]});
     else
       Error("Invalid first argument, it should be one of: \"generators\", \"minimalgenerators\" ");
     fi;
   elif Length(arg) = 1 and IsList(arg[1]) then
     return AffineSemigroupByGenerators(arg[1]);
   else
     return AffineSemigroupByGenerators(arg);
   fi;
 end);
 
#############################################################################
##
#P  IsAffineSemigroupByGenerators(S)
##
##  Tests if the affine semigroup S was given by generators.
##
#############################################################################
 InstallMethod(IsAffineSemigroupByGenerators,
         "Tests if the affine semigroup S was given by generators",
         [IsAffineSemigroup],
         function( S )
   return(HasIsAffineSemigroupByGenerators( S ));
 end);
#############################################################################
##
#P  IsAffineSemigroupByMinimalGenerators(S)
##
##  Tests if the affine semigroup S was given by its minimal generators.
##
#############################################################################
 InstallMethod(IsAffineSemigroupByMinimalGenerators,
         "Tests if the affine semigroup S was given by its minimal generators",
         [IsAffineSemigroup],
         function( S )
   return(HasIsAffineSemigroupByMinimalGenerators( S ));
 end);
#############################################################################
##
#P  IsAffineSemigroupByEquations(S)
##
##  Tests if the affine semigroup S was given by equations.
##
 #############################################################################
 InstallMethod(IsAffineSemigroupByEquations,
         "Tests if the affine semigroup S was given by equations",
         [IsAffineSemigroup],
         function( S )
   return(HasIsAffineSemigroupByEquations( S ));
 end);

#############################################################################
##
#P  IsAffineSemigroupByInequalities(S)
##
##  Tests if the affine semigroup S was given by inequalities.
##
 #############################################################################
 InstallMethod(IsAffineSemigroupByInequalities,
         "Tests if the affine semigroup S was given by inequalities",
         [IsAffineSemigroup],
         function( S )
   return(HasIsAffineSemigroupByInequalities( S ));
 end);

#############################################################################
##
#P  IsFullAffineSemigroup(S)
##
##  Tests if the affine semigroup S has the property of being full.
 ##
 # Detects if the affine semigroup is full: the nonnegative 
# of the the group spanned by it coincides with the semigroup
# itself; or in other words, if a,b\in S and a-b\in \mathbb N^n,
# then a-b\in S
#############################################################################
 InstallMethod(IsFullAffineSemigroup,
         "Tests if the affine semigroup S has the property of being full",
         [IsAffineSemigroup],
         function( S )
   local  gens, eq, h;
   local  gens, eq, h;

   if IsFullAffineSemigroup(S) then 
     return true;
   fi;
   gens := GeneratorsOfAffineSemigroup(S);
   eq:=EquationsOfGroupGeneratedBy(gens);
   h:=HilbertBasisOfSystemOfHomogeneousEquations(eq[1],eq[2]);
   if ForAll(h, x->BelongsToAffineSemigroup(x,a)) then
     SetEquationsAS(eq);
     Setter(IsAffineSemigroupByEquations)(S,true);
     Setter(IsFullAffineSemigroup)(S,true);
     return true;
   else
     return false;
   fi;
 end);

 
#############################################################################
 ##
 #M  PrintObj(S)
 ##
 ##  This method for affine semigroups.
 ##
 #############################################################################
 InstallMethod( PrintObj,
         "Prints an Affine Semigroup",
         [ IsAffineSemigroup],
         function( S )
     if HasGeneratorsAS(S) then
         Print("AffineSemigroup( ", GeneratorsAS(S), " )\n");
     else
         Print("AffineSemigroup( ", GeneratorsOfAffineSemigroup(S), " )\n");
     fi;
 end);



 #############################################################################
 ##
 #M  ViewObj(S)
 ##
 ##  This method for affine semigroups.
 ##
 #############################################################################
 InstallMethod( ViewObj,
         "Displays an Affine Semigroup",
         [IsAffineSemigroup],
         function( S )
   if HasMinimalGeneratorsAS(S) then
         Print("<Affine semigroup in ", Length(MinimalGeneratorsAS(S)[1])," dimensional space, with ", Length(MinimalGeneratorsAS(S)), " generators>");
     elif HasGeneratorsAS(S) then
         Print("<Affine semigroup in ", Length(GeneratorsAS(S)[1])," dimensional space, with ", Length(GeneratorsAS(S)), " generators>");
     else
         Print("<Affine semigroup>");
     fi;
 end);



 #############################################################################
 ##
 #M  Display(S)
 ##
 ##  This method for affine semigroups. ## under construction... (= View)
 ##
 #############################################################################
InstallMethod( Display,
         "Displays an Affine Semigroup",
         [IsAffineSemigroup],
         function( S )
     if HasMinimalGeneratorsAS(S) then
         Print("<Affine semigroup in ", Length(MinimalGeneratorsAS(S)[1]),"-dimensional space, with ", Length(MinimalGeneratorsAS(S)), " generators>");
     elif HasGeneratorsNS(S) then
         Print("<Affine semigroup in ", Length(MinimalGeneratorsAS(S)[1]),"-dimensional space, with ", Length(MinimalGeneratorsAS(S)), " generators>");
     else
         Print("<Affine semigroup>");
     fi;
 end);



 ####################################################
 ####################################################
 

