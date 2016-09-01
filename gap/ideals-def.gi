#############################################################################
##
#W  ideals-def.gi           Manuel Delgado <mdelgado@fc.up.pt>
#W                          Pedro Garcia-Sanchez <pedro@ugr.es>
#W                          Jose Morais <josejoao@fc.up.pt>
##
##
#Y  Copyright 2005 by Manuel Delgado,
#Y  Pedro Garcia-Sanchez and Jose Joao Morais
#Y  We adopt the copyright regulations of GAP as detailed in the
#Y  copyright notice in the GAP manual.
##
#############################################################################


#############################################################################
#####################        Defining Ideals           ######################
#############################################################################
##
#F IdealOfNumericalSemigroup(l,S)
##
## l is a list of integers and S a numerical semigroup
##
## returns the ideal of S generated by l.
##
#############################################################################
InstallGlobalFunction(IdealOfNumericalSemigroup, function(l,S)
  local  I;
      if not (IsNumericalSemigroup(S) and IsListOfIntegersNS(l)) then
        Error("The arguments of IdealOfNumericalSemigroup must be a numerical semigroup and a nonempty list of integers.");
    fi;
    I := rec();
    ObjectifyWithAttributes(I, IdealsOfNumericalSemigroupsType,
        UnderlyingNSIdeal, S,
        Generators, Set(l)
        );
    return I;
end );


##############################################################################
## L is a list of integers and S a numerical semigroup
## L + S is an abbreviation for IdealOfNumericalSemigroup(L, S)
##
InstallOtherMethod( \+, "for a list and a numerical semigroup", true,
        [IsList and IsAdditiveElement,
         IsNumericalSemigroup], 0,
        function( L,S )
    return(IdealOfNumericalSemigroup(L, S));
end);

##############################################################################
## n is an integer and S a numerical semigroup
## n + S is an abbreviation for IdealOfNumericalSemigroup([n], S)
##
InstallOtherMethod( \+, "for an integer and a numerical semigroup", true,
        [IsInt and IsAdditiveElement,
         IsNumericalSemigroup], 0,
        function( n,S )
    return(IdealOfNumericalSemigroup([n], S));
end);

#############################################################################
##
#M  PrintObj(S)
##
##  This method for ideals of numerical semigroups.
##
#############################################################################

InstallMethod( PrintObj,
        "prints an Ideal of a Numerical Semigroup",
        [ IsIdealOfNumericalSemigroup],
        function( I )
    Print(Generators(I)," + NumericalSemigroup( ", GeneratorsOfNumericalSemigroup(UnderlyingNSIdeal(I)), " )\n");
end);

#############################################################################
##
#M  ViewString(S)
##
##  This method for ideals of numerical semigroups.
##
#############################################################################

InstallMethod( ViewString,
        "prints an Ideal of a Numerical Semigroup",
        [ IsIdealOfNumericalSemigroup],
        function( I )
    return ("Ideal of numerical semigroup");
end);

#############################################################################
##
#M  ViewObj(S)
##
##  This method for ideals of numerical semigroups.
##
#############################################################################

InstallMethod( ViewObj,
        "prints an Ideal of a Numerical Semigroup",
        [ IsIdealOfNumericalSemigroup],
        function( I )
    Print("<Ideal of numerical semigroup>");
end);

#############################################################################
##
#M  DisplayObj(S)
##
##  This method for ideals of numerical semigroups.
##
#############################################################################
InstallMethod( Display,
        "displays an ideal of a numerical semigroup",
    [IsIdealOfNumericalSemigroup],
        function( I )
    local   condensed,  L,  M,  u;

    condensed := function(L)
        local   C,  bool,  j,  c,  search;

        C := [];
        bool := true;
        j := 0;
        c := L[1];
        search := function(n) # searches the greatest subinterval starting in n
            local i, k;
            k := 0;
            for i in [Position(L,n).. Length(L)-1] do
                if not (L[i]+1 = L[i+1]) then
                    c := L[i+1];
                    return [n..n+k];
                fi;
                k := k+1;
            od;
            bool := false;
            return [n..L[Length(L)]];
        end;
        while bool do
            Add(C,search(c));
        od;
        return C;
    end;
    ##  End of condensed()  --

    L := SmallElementsOfIdealOfNumericalSemigroup(I);
    M := condensed(L);
    u := [M[Length(M)][1],"->"];
    M[Length(M)] := u;
    return M;
end);


############################################################################
##
#M Methods for the comparison of ideals of a numerical semigroup.
##
InstallMethod( \=,
        "for two ideals of a numerical semigroup",
        [IsIdealOfNumericalSemigroup,
         IsIdealOfNumericalSemigroup],
        function(I, J )

    if not AmbientNumericalSemigroupOfIdeal(I)
       = AmbientNumericalSemigroupOfIdeal(J) then
        Error("The ambient numerical semigroup must be the same for both ideals.");
    fi;
    if HasMinimalGeneratingSystemOfIdealOfNumericalSemigroup(I) and HasMinimalGeneratingSystemOfIdealOfNumericalSemigroup(J) then
        return MinimalGeneratingSystemOfIdealOfNumericalSemigroup(I)
               = MinimalGeneratingSystemOfIdealOfNumericalSemigroup(J);
    fi;
    return SmallElementsOfIdealOfNumericalSemigroup(I)
           = SmallElementsOfIdealOfNumericalSemigroup(J);
end);

InstallMethod( \<,
        "for two ideals of a numerical semigroups",
        [IsIdealOfNumericalSemigroup,IsIdealOfNumericalSemigroup],
        function(I, J )
    if not AmbientNumericalSemigroupOfIdeal(I)
       = AmbientNumericalSemigroupOfIdeal(J) then
        Error("The ambient numerical semigroup must be the same for both ideals.");
    fi;
    return(SmallElementsOfIdealOfNumericalSemigroup(I) < SmallElementsOfIdealOfNumericalSemigroup(J));
end );


#############################################################################
##
#A  Generators(I)
#A  GeneratorsOfIdealOfNumericalSemigroup(I)
##
##  Returns a set of generators of the ideal I.
##  If a minimal generating system has already been computed, this
##  is the set returned.
############################################################################
InstallMethod(GeneratorsOfIdealOfNumericalSemigroup,
        "Returns the minimal generating system of an ideal",
        [IsIdealOfNumericalSemigroup],
        function(I)
    if HasMinimalGenerators(I) then
       return (MinimalGenerators(I));
    fi;
    return(Generators(I));   
end);


#############################################################################
##
#F  GeneratorsOfIdealOfNumericalSemigroupNC(I)
##
##  Returns a set of generators of the ideal I.
############################################################################
# InstallGlobalFunction(GeneratorsOfIdealOfNumericalSemigroupNC, function(I)
#     if not IsIdealOfNumericalSemigroup(I) then
#         Error("The argument must be an ideal of a numerical semigroup.");
#     fi;
#     return(GeneratorsIdealNS(I));
# end);

#############################################################################
##
#F AmbientNumericalSemigroupOfIdeal(I)
##
##  Returns the ambient semigroup of the ideal I.
############################################################################
InstallGlobalFunction(AmbientNumericalSemigroupOfIdeal, function(I)
    if not IsIdealOfNumericalSemigroup(I) then
        Error("The argument must be an ideal of a numerical semigroup.");
    fi;
    return(UnderlyingNSIdeal(I));
end);

#############################################################################
##
#F  IsIntegralIdealOfNumericalSemigroup(i)
##
##  Detects if the ideal i is contained in its ambient semigroup
##
#############################################################################
InstallGlobalFunction("IsIntegralIdealOfNumericalSemigroup",function(I)
     local s;

     s:=AmbientNumericalSemigroupOfIdeal(I);

     return IsSubset(s,MinimalGeneratingSystemOfIdealOfNumericalSemigroup(I));
end);


#############################################################################
##
#A SmallElementsOfIdealOfNumericalSemigroup
##
##  Returns the list of elements in the ideal I up to the last gap + 1.
##
#############################################################################
InstallMethod(SmallElementsOfIdealOfNumericalSemigroup,
        "Returns the list of elements in the ideal not greater that the last gap",
        [IsIdealOfNumericalSemigroup ],
        function(I)
    local   smallS,  g,  gI,  l,  min,  l2,  maxgap;

    # if not (IsIdealOfNumericalSemigroup(I)) then
    #     Error("The argument must be an ideal of a numerical semigroup");
    # fi;

    smallS := SmallElementsOfNumericalSemigroup(AmbientNumericalSemigroupOfIdeal(I));
    g := smallS[Length(smallS)]; #Frobenius number + 1
    gI := GeneratorsOfIdealOfNumericalSemigroup(I);

    l := Union(List(gI, i -> i+ smallS));

    min := Minimum(gI);

    l := Intersection(l,[min .. min+g]);

    l2 := Difference([min..min+g],l);
    if l2 = [] then
        return([min]);
    else
        maxgap := Maximum(Difference(l2,l));
        return(Intersection(l,[min..maxgap+1]));
    fi;
end);

#############################################################################
##
#F  ConductorOfIdealOfNumericalSemigroup(I)
##
##  Returns the conductor of I, the largest element in SmallElements(I)
##
#############################################################################
InstallMethod(Conductor, 
        "Returns the conductor of I, the largest element in SmallElements(I)",
        [IsIdealOfNumericalSemigroup ],
        function(I)
     local seI;

     # if not IsIdealOfNumericalSemigroup(I) then
     #     Error("The argument must be an ideal of a numerical semigroup");
     # fi;
     seI:=SmallElementsOfIdealOfNumericalSemigroup(I);

     return seI[Length(seI)];
end);

#############################################################################
##
#F  BelongsToIdealOfNumericalSemigroup(n,I)
##
##  Tests if the integer n belongs to the ideal I.
##
#############################################################################
InstallGlobalFunction(BelongsToIdealOfNumericalSemigroup, function(x, I)
    local gI, S, small;

    if not (IsIdealOfNumericalSemigroup(I) and IsInt(x)) then
        Error("The arguments must be an integer and an ideal of a numerical semigroup");
    fi;
    if HasSmallElementsOfIdealOfNumericalSemigroup(I) then
        small := SmallElementsOfIdealOfNumericalSemigroup(I);
        return( (x in small) or (x > Maximum(small)));
    fi;

    S := AmbientNumericalSemigroupOfIdeal(I);
    gI := GeneratorsOfIdealOfNumericalSemigroup(I);

    return(First(gI, n -> (BelongsToNumericalSemigroup(x-n,S))) <> fail);
end);
###########################################################
## n in I means BelongsToIdealOfNumericalSemigroup(n,I)
##########
InstallMethod( \in,
        "for ideals of numerical semigroups",
        [ IsInt, IsIdealOfNumericalSemigroup ],
        function( x, I )
    return BelongsToIdealOfNumericalSemigroup(x,I);
end);

#############################################################################
##
#A MinimalGenerators(I)
#A MinimalGeneratingSystem(I)
#A MinimalGeneratingSystemOfIdealOfNumericalSemigroup(I)
##
## The argument I is an ideal of a numerical semigroup
## returns the minimal generating system of I.
##
#############################################################################
InstallMethod(MinimalGeneratingSystemOfIdealOfNumericalSemigroup,
        "Returns the minimal generating system of an ideal",
        [IsIdealOfNumericalSemigroup],
        function(I)
  local  S, m, mingens;

    S := AmbientNumericalSemigroupOfIdeal(I);
    m := MaximalIdealOfNumericalSemigroup(S);
    mingens := DifferenceOfIdealsOfNumericalSemigroup(I,m+I);
#    Setter(Generators)(I,mingens); #does not work
    return mingens;
  end);
  
#############################################################################
##
#F SumIdealsOfNumericalSemigroup(I,J)
##
## returns the sum of the ideals I and J (in the same ambient semigroup)
#############################################################################
InstallGlobalFunction(SumIdealsOfNumericalSemigroup, function(I, J)
    local   l1,  l2,  l;

    if not (IsIdealOfNumericalSemigroup(I) and IsIdealOfNumericalSemigroup(J))
       or not AmbientNumericalSemigroupOfIdeal(I)
       = AmbientNumericalSemigroupOfIdeal(J) then
        Error("The arguments must be ideals of the same numerical semigroup.");
    fi;

    l1:=GeneratorsOfIdealOfNumericalSemigroup(I);
    l2:=GeneratorsOfIdealOfNumericalSemigroup(J);
    l := Set(Cartesian(l1,l2),n -> Sum(n));
    return(IdealOfNumericalSemigroup(l,AmbientNumericalSemigroupOfIdeal(I)));
end);

###########################################################
## I + J means SumIdealsOfNumericalSemigroup(I,J)
##########

InstallOtherMethod( \+, "for ideals of the same numerical semigroup", true,
        [IsIdealOfNumericalSemigroup,
         IsIdealOfNumericalSemigroup], 0,
        function( I, J )
    return(SumIdealsOfNumericalSemigroup( I, J ));
end);

#############################################################################
##
#F SubtractIdealsOfNumericalSemigroup(I,J)
##
## returns the ideal I - J
#############################################################################
InstallGlobalFunction(SubtractIdealsOfNumericalSemigroup, function(I, J)
    local   s,  g,  mult,  gI,  gJ,  i,  j,  l,  l2,  maxgap,  maxl,  mingen,  
            ideal;

    if not (IsIdealOfNumericalSemigroup(I) and IsIdealOfNumericalSemigroup(J))
       or not AmbientNumericalSemigroupOfIdeal(I)
       = AmbientNumericalSemigroupOfIdeal(J) then
        Error("The arguments must be ideals of the same numerical semigroup.");
    fi;
    s := AmbientNumericalSemigroupOfIdeal(I);
    g := FrobeniusNumberOfNumericalSemigroup(s);
    mult:= MultiplicityOfNumericalSemigroup(s);
    
    gI := GeneratorsOfIdealOfNumericalSemigroup(I);
    gJ := GeneratorsOfIdealOfNumericalSemigroup(J);

    i := Minimum(gI);
    j := Minimum(gJ);

    l := Filtered([i-j..i-j+g+1], n -> ForAll(gJ, z-> BelongsToIdealOfNumericalSemigroup(z+n,I)));



    l2 := Difference([i-j..i-j+g+1],l);
    if l2 = [] then
        maxgap := i-j-1;
    else
        maxgap := Maximum(Difference(l2,l));
    fi;

    l := Intersection(l,[i-j..maxgap+1]);
    maxl:= Maximum(l);

    mingen := MinimalGeneratingSystemOfIdealOfNumericalSemigroup(
        Concatenation(l,[maxl+1..maxl+mult+1])+s);

    ideal := mingen + s;

    Setter(SmallElementsOfIdealOfNumericalSemigroup)(ideal,l);
    
    Setter(MinimalGeneratingSystemOfIdealOfNumericalSemigroup)(ideal,mingen);

    return ideal;
end);

###########################################################
## I - J means SubtractIdealsOfNumericalSemigroup(I,J)
## I can be the ambient numerical semigroup of J
##########

InstallOtherMethod( \-, "for ideals of the same numerical semigroup", true,
        [IsIdealOfNumericalSemigroup,
         IsIdealOfNumericalSemigroup], 0,
        function( I, J )
    return(SubtractIdealsOfNumericalSemigroup( I, J ));
end);

InstallOtherMethod( \-, "for a numerical semigroup and one of its ideals", true,
        [IsNumericalSemigroup,
         IsIdealOfNumericalSemigroup], 0,
        function( S, J )
    return(SubtractIdealsOfNumericalSemigroup( 0+S, J ));
end);


#############################################################################
##
#F DifferenceOfdealsOfNumericalSemigroup(I,J)
##
## returns the set difference I\J (J must be contained in I)
#############################################################################
InstallGlobalFunction(DifferenceOfIdealsOfNumericalSemigroup, function(I, J)
    local   sI,  sJ,  MI,  MJ,  M,  SI,  SJ;

    if not (IsIdealOfNumericalSemigroup(I) and IsIdealOfNumericalSemigroup(J))
       or not AmbientNumericalSemigroupOfIdeal(I)
       = AmbientNumericalSemigroupOfIdeal(J) then
        Error("The arguments must be ideals of the same numerical semigroup.");
    fi;
    sI := SmallElementsOfIdealOfNumericalSemigroup(I);
    sJ := SmallElementsOfIdealOfNumericalSemigroup(J);
    MI := Maximum(sI);
    MJ := Maximum(sJ);
    M := Maximum(MI,MJ);
    SI := Union(sI,[MI..M]);
    SJ := Union(sJ,[MJ..M]);
    if not IsSubset(SI,SJ) then
        Error("The second ideal must be contained in the first");
    fi;
    return Difference(SI,SJ);
end);

#############################################################################
##
#F MultipleOfIdealOfNumericalSemigroup(n,I)
##
## n is a non negative integer and I is an ideal
## returns the multiple nI (I+...+I n times) of I
#############################################################################
InstallGlobalFunction(MultipleOfIdealOfNumericalSemigroup, function(n,I)
    local i, II;
     if not (IsInt(n) and n >=0 and IsIdealOfNumericalSemigroup(I)) then
         Error("The arguments must be a non negative integer and an ideal.");
     fi;
     if n=0 then
         return [0]+AmbientNumericalSemigroupOfIdeal(I);
     elif n=1 then
         return I;
     fi;
     II:=I;
     for i in [1..n-1] do
         II := II+I;
     od;
     return II;
end);
###########################################################
## n is an integer and S a numerical semigroup
## n * I is an abbreviation for MultipleOfIdealOfNumericalSemigroup(n,I)
##########
InstallOtherMethod( \*, "for a non negative integer and an ideal of a numerical semigroup", true,
        [IsInt and IsMultiplicativeElement,
         IsIdealOfNumericalSemigroup], 999999990,
        function( n,I )
    return(MultipleOfIdealOfNumericalSemigroup(n, I));
end);


#############################################################################
##
#F HilbertFunctionOfIdealOfNumericalSemigroup(n,I)
##
## returns the value of the Hilbert function associated to I in n,
## that is, nI\(n+1)I. I must be an ideal included in its ambient semigroup.
#############################################################################
InstallGlobalFunction(HilbertFunctionOfIdealOfNumericalSemigroup, function(n,I)
    if not (IsInt(n) and n >=0 and IsIdealOfNumericalSemigroup(I)) then
        Error("The arguments must be a non negative integer and an ideal.");
    fi;
    return Length(DifferenceOfIdealsOfNumericalSemigroup(n*I,(n+1)*I));
end);

#############################################################################
##
#F IsMonomialNumericalSemigroup
## Tests if a numerical semigroup is a monomial semigroup ring
##
#############################################################################
InstallGlobalFunction(IsMonomialNumericalSemigroup, function(s)
    local l,c,gen,gaps;

    gen:=MinimalGeneratingSystemOfNumericalSemigroup(s);
    gaps:=GapsOfNumericalSemigroup(s);
    l:=List(gen,g->Filtered(gaps-g,x->x>0));
    c:=Filtered(Cartesian([1..Length(l)],[1..Length(l)]),x->x[1]<x[2]);
    return First(c,x->Intersection(l[x[1]],l[x[2]])<>[])=fail;
end);


#############################################################################
##
#F BlowUpIdealOfNumericalSemigroup(I)
##
##
#############################################################################
InstallGlobalFunction(BlowUpIdealOfNumericalSemigroup, function(I)
    local r;
    if not IsIdealOfNumericalSemigroup(I) then
        Error("The argument must be an ideal.");
    fi;

    r:=ReductionNumberIdealNumericalSemigroup(I);

    return r*I-r*I;
end);



#############################################################################
##
#F  MaximalIdealOfNumericalSemigroup(S)
##
##  Returns the maximal ideal of S.
##
#############################################################################
InstallGlobalFunction(MaximalIdealOfNumericalSemigroup, function(S)
    if not IsNumericalSemigroup(S) then
        Error("The argument must be a numerical semigroup.");
    fi;
    return MinimalGeneratingSystemOfNumericalSemigroup(S)+S;
end);


#############################################################################
##
#F  BlowUpOfNumericalSemigroup(s)
##
##  Computes the Blow Up (of the maximal ideal) of
##  the numerical semigroup <s>.
##
#############################################################################
InstallGlobalFunction(BlowUpOfNumericalSemigroup, function(s)
    local gen, genbu, m;

    if not IsNumericalSemigroup(s) then
        Error("The argument must be a numerical semigroup.");
    fi;


    gen:=MinimalGeneratingSystemOfNumericalSemigroup(s);
    m:=MultiplicityOfNumericalSemigroup(s);
    genbu:=gen-m;
    genbu:=genbu+[m];

    return NumericalSemigroup(genbu);
end);
#############################################################################
##
#F MultiplicitySequenceOfNumericalSemigroup(s)
##
##  Computes the multiplicity sequence of the numerical semigroup <s>.
##
#############################################################################
InstallGlobalFunction(MultiplicitySequenceOfNumericalSemigroup, function(s)
      local msg, m;

    if not(IsNumericalSemigroup(s)) then
      Error("The argument must be a numerical semigroup");
    fi;

    if (1 in s) then
      return [1];
    fi;

    msg:=MinimalGenerators(s);
    m:=MultiplicityOfNumericalSemigroup(s);
    msg:=Union(Difference(msg-m,[0]),[m]);
    return Concatenation([m],MultiplicitySequenceOfNumericalSemigroup(NumericalSemigroup(msg)));
end);


#############################################################################
##
#F  MicroInvariantsOfNumericalSemigroup(s)
##
##  Computes the microinvariants of the numerical semigroup <s>
##  using the formula given by Valentina and Ralf [BF06]. The
##  microinvariants of a numerial semigroup where introduced
##  by J. Elias in [E01].
##
#############################################################################
InstallGlobalFunction(MicroInvariantsOfNumericalSemigroup, function(s)
    local e,m;

    if not IsNumericalSemigroup(s) then
        Error("The argument must be a numerical semigroup.");
    fi;

    m:=MaximalIdealOfNumericalSemigroup(s);
    e:=MultiplicityOfNumericalSemigroup(s);
    return (-AperyListOfNumericalSemigroupWRTElement(BlowUpOfNumericalSemigroup(s),e)
            +AperyListOfNumericalSemigroupWRTElement(s,e))/e;

end);


#############################################################################
##
#F  IsGradedAssociatedRingNumericalSemigroupCM(s)
##
##  Returns true if the associated graded ring of
##  the semigroup ring algebra k[[s]] is Cohen-Macaulay.
##  This function implements the algorithm given in [BF06].
##
#############################################################################
InstallGlobalFunction(IsGradedAssociatedRingNumericalSemigroupCM, function(s)
    local ai,bi,e,m;

    if not IsNumericalSemigroup(s) then
        Error("The argument must be a numerical semigroup.");
    fi;


    m:=MaximalIdealOfNumericalSemigroup(s);
    e:=MultiplicityOfNumericalSemigroup(s);
    ai:=MicroInvariantsOfNumericalSemigroup(s);
    bi:=List(AperyListOfNumericalSemigroupWRTElement(s,e),
        w->MaximumDegreeOfElementWRTNumericalSemigroup(w,s));
    return ai=bi;
end);


#############################################################################
##
#F  CanonicalIdealOfNumericalSemigroup(s)
##
##  Computes a canonical ideal of <s> ([B06]):
##      { x in Z | g-x not in S}
##
#############################################################################
InstallGlobalFunction(CanonicalIdealOfNumericalSemigroup, function(s)

    if not IsNumericalSemigroup(s) then
        Error("The argument must be a numerical semigroup.");
    fi;

    return IdealOfNumericalSemigroup(FrobeniusNumberOfNumericalSemigroup(s)-
            PseudoFrobeniusOfNumericalSemigroup(s),s);
end);


#############################################################################
##
#F  ReductionNumberIdealNumericalSemigroup(I)
##
##  Returns the least nonnegative integer such that
##  nI-nI=(n+1)I-(n+1)I, see [B06].
##
#############################################################################
InstallGlobalFunction(ReductionNumberIdealNumericalSemigroup, function(I)

    local n, S, i;
    if not IsIdealOfNumericalSemigroup(I) then
        Error("The argument must be an ideal.");
    fi;

    i:=Minimum(SmallElementsOfIdealOfNumericalSemigroup(I));
    n := 1;
    S:=AmbientNumericalSemigroupOfIdeal(I);
    while (n+1)*I <> (i+MinimalGeneratingSystemOfIdealOfNumericalSemigroup(n*I))+S do
        n := n+1;
    od;
    return n;

end);


#############################################################################
##
#F  TranslationOfIdealOfNumericalSemigroup(k,I)
##
##  Given an ideal <I> of a numerical semigroup S and an integer <k>
##  returns an ideal of the numerical semigroup S generated by
##  {i1+k,...,in+k} where {i1,...,in} is the system of generators of <I>.
##
#############################################################################
InstallGlobalFunction(TranslationOfIdealOfNumericalSemigroup, function(k,I)
    local l;
    if not IsInt(k) then
        Error("<k> must be an integer");
    fi;
    if not IsIdealOfNumericalSemigroup(I) then
        Error("<I> must be an ideal of a numerical semigroup");
    fi;
    l := List(GeneratorsOfIdealOfNumericalSemigroup(I), g -> g+k);
    return IdealOfNumericalSemigroup(l, AmbientNumericalSemigroupOfIdeal(I));
end);



##############################################################################
##
##  <k> is an integer and <I> an ideal of a numerical semigroup.
##  k + I is an abbreviation for TranslationOfIdealOfNumericalSemigroup(k, I)
##
InstallOtherMethod( \+, "for an integer and an ideal of a numerical semigroup", true,
        [IsInt and IsAdditiveElement,
         IsIdealOfNumericalSemigroup], 0,
        function(k,I)
    return(TranslationOfIdealOfNumericalSemigroup(k, I));
end);



#############################################################################
##
#F  IntersectionIdealsOfNumericalSemigroup(I,J)
##
##  Given two ideals <I> and <J> of a numerical semigroup S
##  returns the ideal of the numerical semigroup S which is the
##  intersection of the ideals <I> and <J>.
##
#############################################################################
InstallGlobalFunction(IntersectionIdealsOfNumericalSemigroup, function(I, J)
    local l,i,j,max,mult,l1,l2;

    if not (IsIdealOfNumericalSemigroup(I) and IsIdealOfNumericalSemigroup(J))
       or not AmbientNumericalSemigroupOfIdeal(I)
       = AmbientNumericalSemigroupOfIdeal(J) then
        Error("The arguments must be ideals of the same numerical semigroup.");
    fi;

    mult:=MultiplicityOfNumericalSemigroup(AmbientNumericalSemigroupOfIdeal(I));
    
    l1:=SmallElementsOfIdealOfNumericalSemigroup(I);
    l2:=SmallElementsOfIdealOfNumericalSemigroup(J);
    i:=Maximum(l1);
    j:=Maximum(l2);
    max:=Maximum(i,j);
    l1:=Concatenation(l1,[(i+1)..max]);
    l2:=Concatenation(l2,[(j+1)..max]);
    l := Concatenation(Intersection(l1,l2),[(max+1)..(max+mult)]);
   
    return(IdealOfNumericalSemigroup(l,AmbientNumericalSemigroupOfIdeal(I)));

end);


########################################################################
##
#F AperyListOfIdealOfNumericalSemigroupWRTElement(I,n)
##
##  Computes the sets of elements x of I such that x-n not in I,
##  where n is supposed to be in the ambient semigroup of I.
##  The element in the i-th position of the output list (starting in 0) 
##  is congruent with i modulo n 
########################################################################
InstallGlobalFunction(AperyListOfIdealOfNumericalSemigroupWRTElement,function(ideal,n)
	local msg, apambient, s, ap, cand, i;

	s:=AmbientNumericalSemigroupOfIdeal(ideal);
	apambient:=AperyListOfNumericalSemigroupWRTElement(s,n);
	msg:=MinimalGeneratingSystemOfIdealOfNumericalSemigroup(ideal);
	ap:=ShallowCopy(apambient);

	cand:=Set(Cartesian(msg,apambient), p->p[1]+p[2]);
	
	for i in [0..n-1] do
		ap[i+1]:=Minimum(Filtered(cand, w-> w mod n=i));
	od;
	return ap;
end);

########################################################################
##
#F AperyTableOfNumericalSemigroup(S)
##
##  Computes the Apéry table associated to S as 
## explained in [CJZ],
##  that is, a list containing the Apéry list of S with respect to 
## its multiplicity and the Apéry lists of kM (with M the maximal 
##  ideal of S) with respect to the multiplicity of S, for k=1..r,
##  where r is the reduction number of M 
##  (see ReductionNumberIdealNumericalSemigroup).
########################################################################
InstallGlobalFunction(AperyTableOfNumericalSemigroup,function(S)
	local M,m, table, k, r;

	M:=MaximalIdealOfNumericalSemigroup(S);
	m:=MultiplicityOfNumericalSemigroup(S);
	table:=[AperyListOfNumericalSemigroupWRTElement(S,m)];
	r:=ReductionNumberIdealNumericalSemigroup(M);
	for k in [1..r] do 
		Append(table,[AperyListOfIdealOfNumericalSemigroupWRTElement(k*M,m)]);
	od;
	return table;	
end);

########################################################################
## 
#F StarClosureOfIdealOfNumericalSemigroup(i,is)
##  i is an ideal and is is a set of ideals (all from the same 
##	numerical semigroup). The output is i^{*_is}, where
## *_is is the star operation generated by is
## The implementation uses Section 3 of
##  -D. Spirito, Start Operations on Numerical Semigroups
########################################################################

InstallGlobalFunction(StarClosureOfIdealOfNumericalSemigroup, function(i,is)
	local j, s, k;

	s:=AmbientNumericalSemigroupOfIdeal(i);
	j:=s-(s-i); # i^v

	for k in is do
		j:=IntersectionIdealsOfNumericalSemigroup(j,k-(k-i));
	od;

	return j;
	
end);
