
##########################################################
#IsStable
##########################################################



with(combinat):
with(RootFinding):

TransformationMoebius:=proc(D,vars:=[op(indets(D))])
local f:
f:=numer(expand(subs({seq(v=(v-I)/(v+I),v in vars)},D))):
return([expand(coeff(f,I,0))=0,expand(coeff(f,I,1))=0]):
end:

BistritzTest:=proc(D::polynom,var:=op(indets(D)))
local i,rD,n,T,TT,cst,a,Temp;
n:=degree(D);
if subs(var=1,D)=0 then
return false;
end if;
rD:=expand(var^n*subs(var=1/var,D));
T:=D+rD;
a:=subs(var=1,T);
TT:=simplify(expand((D-rD)/(var-1)));
for i from 0 to (n-1) do
if (subs(var=0,TT)=0 or a*subs(var=1,TT)<=0) then
return false;
end if;
cst:=subs(var=0,T)/subs(var=0,TT);
Temp:=TT;
TT:=simplify(expand((cst*(1+var)*TT-T)/var));
T:=Temp;
end do;
return true;
end proc:


IsStable := proc(D::polynom)
local sys,f,vars,i,j,k,L,b,h,fconjugate,sys2,sys1,vars2,var;
b:=true;
vars:=indets(D);
for i from 0 to nops(vars)-1 do
L:={seq(subs(seq(vars[k[j]]=1, j=1..i),D),k in {op(choose(nops(vars),i))})};
## Univariate stability test
if i=nops(vars)-1 then
for f in L do
var:=op(indets(f));
if subs(var=0,f)=0 then
return false;
end if;
h:=numer(subs(var=1/var,f));
if evalb(BistritzTest(h))=false then
return false;
end if;
end do;
else
## Intersection with the poly-circle
for f in L do
vars2:=indets(f);
sys:=TransformationMoebius(f);
##fconjugate:=numer(expand(subs({seq(v=1/v,v in vars)},f))):
##sys2:=TransformationMoebius(fconjugate);
##sys:=[op(sys1),op(sys2)];
if evalb(HasRealRoots(sys,indets(sys)))=true then
#HasRealSolutions(op(sys),[op(indets(sys))]):
b:=false;
end if;
end do;
end if;
end do;
return b;
end proc:

IsStableVar := proc(D::polynom,method)
local sys,f,vars,i,j,k,L,b,h,fconjugate,sys2,sys1,vars2,var,R,u;
b:=true;
vars:=indets(D);
for i from 0 to nops(vars)-1 do
L:={seq(subs(seq(vars[k[j]]=1, j=1..i),D),k in {op(choose(nops(vars),i))})};
## Univariate stability test
if i=nops(vars)-1 then
for f in L do
var:=op(indets(f));
if subs(var=0,f)=0 then
return false;
end if;
h:=numer(subs(var=1/var,f));
if evalb(BistritzTest(h))=false then
return false;
end if;
end do;
else
## Intersection with the poly-circle
for f in L do
vars2:=indets(f);
sys:=TransformationMoebius(f);
#return sys;
##fconjugate:=numer(expand(subs({seq(v=1/v,v in vars)},f))):
##sys2:=TransformationMoebius(fconjugate);
##sys:=[op(sys1),op(sys2)];
#if evalb(HasRealRoots(sys,indets(sys)))=true then
if _params['method']='CRIT' then
HasRealSolutions(sys,[op(indets(sys))]):
else
R:=PolynomialRing([op(indets(sys))]):
u:=CylindricalAlgebraicDecompose([sys],R):
end if;
#b:=false;
#end if;
end do;
end if;
end do;
#return u;
end proc:

IsStablefactor := proc(D::polynom)
local facts,liststable,list;
facts := factors(D);
list:=map(a->a[1],facts[2]);
liststable:= map(a->IsStable(a),list);
return not(has(liststable,false));
end proc:


#############################################################
#IsStabilization
#############################################################

# Routine IsStabilizable pour tester la stabilisabilité des systeme Nd
#restart;

# This procedure compute the number of complex roots on the unit complex circle
OnCircle:=proc(D,vars:=[op(indets(D))])
local f,p,q:
f:=numer(expand(subs({seq(v=(v-I)/(v+I),v in vars)},D))):
(p,q):=(expand(coeff(f,I,0)),expand(coeff(f,I,1))):
return nops(RootFinding:-Isolate(gcd(p,q),vars)); 
#degree(gcd(p,q));
end;

# This Procedure computes the inverse of a polynomial g modulo a polynomial f, i.e., it computes a polynomial U such that Ug+Vf=1. (f and g are supposed to be coprime)
Inverse:=proc(g::polynom,f::polynom)
local t:=0,r:=f, new_t :=1, new_r:=g,quotient,var;
var:=indets(g);
while degree(new_r)>0 do
quotient:= quo(r,new_r,op(var));
(t,new_t) := (new_t, expand(t-quotient*new_t)):
(r,new_r) := (new_r,expand(r-quotient*new_r)):
end do;
return primpart(new_t);
end proc;


# Procedure for computing from a RUR a univariate representation i.e. with coordinates given by polynomials (be carful, its substantially larger)
UnivR := proc(sys)
local RUR,g,UR,elem,var,i,coor,inv;
RUR:=Groebner[RationalUnivariateRepresentation](sys,t,output=polynomials);
inv:=Inverse(RUR[2],RUR[1],z);
UR:=[RUR[1]];
coor:=RUR[3];
for i from 1 to nops(coor) do
elem:= rhs(coor[i]);
g:=primpart(rem(inv*elem,RUR[1],t));
UR:=[op(UR),g];
end do;
return UR;
end proc;
# This procedure transformes a univariate polynomial into a system of two bivariate polynomial by decomposing its variable into real and imaginary part
Complextransform := proc(f::polynom)
local var,fbiv,h,s,a,b,sys;
var:=op(indets(f));
fbiv:=expand(subs(var=a+I*b,f));
h:=subs(I=s,fbiv);
sys:=[coeff(h,s,0),coeff(h,s,1)];
return sys;
end proc;

# Main procedure for testing the stabilizability
IsStabilizable := proc(sys)
local UR, RUR, OC,LS,i,sysbiv,vars,bivcoord,pol_circle,sign,sol,circle_sign,b,j,projection_pols,number_sol_circle, generic;
OC:=[];
vars:=indets(sys);
RUR:=Groebner[RationalUnivariateRepresentation](sys,t,output=polynomials):
projection_pols:=[seq(resultant(RUR[1],RUR[2]*lhs(RUR[3][i])-rhs(RUR[3][i]),t),i=1..nops(RUR[3]))];
number_sol_circle:=map(OnCircle,projection_pols);
generic:=true;
for i from 1 to nops(vars) do
if number_sol_circle[i]>0 then
generic:=false;
fi;
end do;
if (generic=true) then
#UR:=UnivR(sys);
sign:=[];
sol:=[fsolve(RUR[1],t,complex)];
#sol:=[fsolve(UR[1],t,complex)];
for i from 1 to nops(sol) do
sign:=[op(sign),map(a->subs(t=sol[i],rhs(a)/RUR[2]),RUR[3])];
#sign:=[op(sign),map(a->subs(t=sol[i],a),UR[2..-1])];
circle_sign:=map(a->map(a->abs(a),a),sign);
end do;
for i from 1 to nops(circle_sign) do
b:=false;
for j from 1 to nops(vars) do
 if circle_sign[i][j]>1 then
b:=true;
break;
fi;
end do;
if b=false then 
return false;
fi;
end do;
return true;
else
return "Il existe des coordonees sur le cercle unite";
fi;
end:
#sysbiv:=Complextransform(UR[1]);
#bivcoord:= Complextransform(UR[i+1]);
#pol_circle:=primpart(bivcoord[1]^2+bivcoord[2]^2-1);
#OC:= [op(OC),pol_circle];
#RootFinding[Isolate](sysbiv,[op(indets(sysbiv))],constraints=OC):



###############################################################StabilizingPolynomial
##############################################################


# Exemple of utilisation
#
# > sys := GenerateDenseSystem([5,5],x, scale = 4);
# > p := StabilizingPolynomial(sys);
# >
# > G := Groebner:-Basis(sys, 'tord'):
# > Groebner:-NormalForm(p, G, tord);
# >
# > infolevel[StabilizingPolynomial] := 1;
# > sys := GenerateDenseSystem([3,3,3],x, scale = 4);
# > p := StabilizingPolynomial(sys);

# Function: CertifiedSolve
#   Isolate the complex roots of a univariate polynomial.
#
# Parameters:
#   f - a univariate polynomial with rational coefficients
#   d - an integer, the precision
#   base (optional) - an integer; the base of the denominators; default is
#                     *2*
#
# Returns:
#   A list of rationals with *base^d* as denominator; the approximations to
#   all the complex roots of *f*.
SolveCertified := proc(f ::polynom,
                       d ::integer,
                       base ::integer := 2)
    global Digits;
    local digits_old, sols, denominator;
    userinfo(1, StabilizingPolynomial, `                    -> approximate roots of the resultant`);
    digits_old := Digits;
    denominator := base^d;
    Digits := ceil(d * log(base)/log(10));
    sols := fsolve(f, complex);
    #sols := convert([sols], rational);
    sols := map(s -> round(s*denominator)/denominator, [sols]);
    Digits := digits_old;
    return sols;
end proc:


# local function for faster remainder computation
myrem := proc(f::polynom, g::polynom, v::name)
    local vars, r;
    vars := [op(indets([f,g]) minus {v})]:
    r := Groebner:-NormalForm(f, [g], lexdeg([v], vars)):
    return r;
end proc:


# Function: PolynomialUnivariateRepresentation
#   Convert a RUR to a polynomial univariate representation.
#
# Parameters:
#   f - a univariate polynomial, the minimal polynomial of *v*
#   d - a univariate polynomial, the denominator of the RUR
#   N - a list of elements of the form *name = polynomial*, the numerators of
#       the RUR
#   v (optional) - the separating indeterminate variable of the RUR
#
# Returns:
#   A list of elements of the form *name = polynomial*, the polynomial
#   parametrization of the solutions of the RUR given in input.
PolynomialUnivariateRepresentation := proc(f ::polynom,
                                           d ::polynom,
                                           N ::list(name = polynom),
                                           v ::name := op(indets(f)))
    local result, fsqrf, a, b;
    userinfo(1, StabilizingPolynomial, `-> inversion of the leading coefficient`);
    if v=NULL then
        return map(p -> lhs(p) = 0, N);
    end if;
    fsqrf := numer(f/gcd(f, diff(f,v))): #Not used
    gcdex(f, d, v, 'a', 'b'):
    result := map(p -> lhs(p) = myrem(b*rhs(p), f, v), N);
    return result;
end proc;


# Function: SeparatingForm
#   Computes the separating form of a polynomial univariate representation.
#
# Parameters:
#   f - a univariate polynomial, the minimal polynomial of *v*
#   d - a univariate polynomial, the denominator of the parametrization
#   N - a list of elements of the form *name = polynomial*, the numerators of
#       the parametrization
#   v (optional) - the separating indeterminate variable
#
# Returns:
#   A list of rational numbers *[u[1], ..., u[k]]* such that *u[1]x[1] +
#   ... + u[k]x[k] = v* where the *x[i]* are the left-hand-side variables
#   in *N*.
SeparatingForm := proc(f ::polynom,
                       d ::polynom,
                       N ::list(name=polynom),
                       v ::name := op(indets([map(rhs,N),d])))
    local n, dred, Vd, L, M, sols;
    #n := nops(N);
    n := degree(f);
    if v=NULL or n = 1 then
        return [1, 0$(n-1)];
    end if;
    dred := myrem(v*d, f, v);
    Vd := Vector(map[3](coeftayl,dred,v=0,[$0..(n-1)]));
    L := map(p -> map[3](coeftayl,rhs(p),v=0,[$0..(n-1)]), N);
    M := LinearAlgebra:-Transpose(Matrix(L));
    sols := LinearAlgebra:-LinearSolve(M, Vd); 
    return convert(sols, list);
end proc;

# Function: VanishingPolynomials
#   Computes stable polynomials vanishing on a set of rational points
#   outside the unit polydisk.
#
# Parameters:
#   V - a list of rational numbers, the values of the separating variable
#   f - a univariate polynomial, the minimal polynomial of *v*
#   d - a univariate polynomial, the denominator of the parametrization
#   N - a list of the form *[x[1] = p[1], ..., x[k] = p[k]]*, the
#       parametrization
#   S (optional) - the list of the rational coefficients of the separating
#                  form
#   v (optional) - the separating indeterminate variable
#
# Returns:
#   A list of stable linear polynomials *[q[1], ..., q[n]]* in *x[1], ...,
#   x[k]* such that for each value *v[0]* of *V* with *|v[0]| > 1*, there
#   is a polynomial *q[i]* satisfying *q[i](p[1](V[0]), ..., p[k](V[0])) =
#   0*.
VanishingPolynomials := proc(V ::list(complex(rational)),
                             f ::polynom,
                             d ::polynom,
                             N ::list(name=polynom),
                             S ::list(rational) := SeparatingForm(f, d, N, v),
                             v ::name := op(indets(map(rhs,N))))
    local F, msep, psep, Vstable, Vunstable, L, i;
    userinfo(1, StabilizingPolynomial, `              -> product of linear polynomials`);
    msep := add(abs(s), s in S);
    psep := add(S[i]*lhs(N[i]), i=1..nops(N));
    Vstable, Vunstable := selectremove(c -> abs(c)^2 > msep^2, V);
    #F := map(c -> psep - c, Vstable);
    F := map(c -> psep - subs(v=c, eval(psep, N)/d), Vstable);
    for i from 1 to nops(N) do
        Vstable, Vunstable :=
            selectremove(c -> abs(subs(v = c, rhs(N[i])/d))^2 > 1, Vunstable);
        F := [op(F), op(map(c -> lhs(N[i]) - subs(v = c, rhs(N[i])/d),
                            Vstable))];
    end do;
    if nops(F) < nops(V) then
        print("Some solutions don't have a module greater than one");
        F := [op(F), op(map(c -> psep - subs(v=c, eval(psep, N)/d), Vunstable))];
    end if;
    return F;
end proc;


# Function: UnroundedVanishingPolynomial
#   Deform a polynomial from vanishing on a set of rational points to
#   vanishing on a set of algebraic points.
#
# Parameters:
#   V - a list of rational numbers, the rational values of *v*
#   L - a list of vanishing linear polynomials
#   f - a univariate polynomial, the minimal polynomial of *v*
#   d - a univariate polynomial, the denominator of the parametrization
#   N - a list of elements of the form *[x[1] = p[1], ..., x[k] = p[k]]*,
#       the parametrization
#   S (optional) - the list of the rational coefficients of the separating
#                  form
#   v (optional) - the separating indeterminate variable
#   noreduce=b (optional) - *b* is a boolean, if true, the result is not
#                           reduced modulo a degree ordering groebner
#                           bases; default is false
#
# Returns:
#   A polynomial that vanishes on all the roots of the parametrization
#   given by *(f, d, N)*, near the polynomial *mul(p, p in L)*.
UnroundedVanishingPolynomial := proc(V ::list(complex(rational)),
                                     L ::list(polynom),
                                     f ::polynom,
                                     d ::polynom,
                                     N ::list(name=polynom),
                                     S ::list(rational) :=
                                                 SeparatingForm(f, d, N, v),
                                     v ::name := op(indets(f)),
                                     { reduce ::truefalse := false })
    local Nb, Lsubs, ftilde, fftilde, a, b, ared, anum, aden, vars, G, sep, result;
    userinfo(1, StabilizingPolynomial, `      -> snap the curve to the algebraic curve`);
    vars := map(lhs,N);
    ftilde := expand(mul(v-c, c in V));
    fftilde := numer(f*ftilde);
    gcdex(fftilde, d, v, 'a', 'b'):
    Nb := map(e-> lhs(e) = rhs(e)*b, N);
    Lsubs := map(eval, L, Nb);
    a := foldl( (x,y) -> myrem(x*y, fftilde, v), op(Lsubs));
    a := normal(quo(a, ftilde, v));
    if not reduce then
        ared := a;
    else
        anum := numer(a);
        aden := denom(a);
        G := [f, op(map(e -> numer(lhs(e)-rhs(e)), N))];
        #G := Groebner:-FGLM(G, lexdeg(vars, [v]), tdeg(v, op(vars)));
        G := Groebner:-Basis(G, tdeg(v, op(vars)));
        ared := Groebner:-NormalForm(anum, G, tdeg(v, op(vars)))/aden;
    end if;
    result := expand(mul(p, p in L)) + ared*(f/lcoeff(f) - ftilde); 
    sep := add(S[i]*lhs(N[i]), i=1..nops(N));
    result := subs(v = sep, result);
    return result;
end proc;

# local function to compute a rational lower bound to an algebraic number
myfloor := proc(e)
    local d, result;
    if ceil(e) <= 0 then return 0; end if;
    d := ceil(-log[2](e));
    result := floor(2^(d+1)*e)/2^(d+1);
    return result;
end proc;


# Function: IsNearSplitPolynomialStable
#   Checks if a structured polynomial is stable.
#
# Parameters:
#   L - a list of linear factors
#   p - a polynomial close to the product of the linear factors
#
# Returns:
#   True implies that the zeroes of *p* do not intersect the unit polydisk.
#   False implies that the stability of *p* is unknown.
IsNearSplitPolynomialStable := proc(L ::list(polynom),
                                    p ::polynom)
    local m1, m2, vars, zero, cst, abscoeffs;
    vars := [op(indets(L))];
    zero := [ 0 $ nops(vars) ];
    cst := f -> coeftayl(f, vars = zero, zero);
    abscoeffs := f -> map(abs, [coeffs(f-cst(f))]);
    m1 := mul(myfloor(abs(cst(f)) - add(c, c in abscoeffs(f))), f in L);
    m2 := add(c, c in map(abs, [coeffs(expand(p - mul(l, l in L)))]));
    if m1 > m2 then
        return true;
    else
        return false;
    end if;
end proc;


# Function: StabilizingPolynomial
#   Compute a stable polynomial vanishing on a 0-dimensional algebraic set.
#
# Parameters:
#   sys - a list of polynomial equations defining a 0-dimensional system
#   precision (optional) - integer, sets the initial precision of the root
#                          approximations; default to the Bezout bound of
#                          *sys* (product of the degrees)
#   reduce (optional) - boolean, if true, intermediate result is reduced
#                       modulo a degree ordering groebner bases; default
#                       is false
#   noloop (optional) - boolean, if true, the precision is not increased
#                       when the stability criterion fails
#
# Returns:
#   A polynomial *p* in the radical of the ideal generated by sys, such
#   that *p* does not vanish in the unit polydisk
StabilizingPolynomial := proc(sys ::list(polynom),
                              { precision ::integer := mul(d, d in map(degree,sys)),
                                reduce ::truefalse := false,
                                noloop ::truefalse := false,
                                rur ::truefalse    := false,
                                linear ::truefalse := false })
    local f, d, N, v, S, V, F, p, prec, stable;
    f, d, N := Groebner:-RationalUnivariateRepresentation(sys, v,
                                                        output = polynomials):
    if not rur then
        N := PolynomialUnivariateRepresentation(f, d, N, v):
        d := 1:
    end if;
    S := SeparatingForm(f, d, N, v);
    stable := false;
    prec := precision;
    while not stable do
        userinfo(1, StabilizingPolynomial, `             -> binary precision set to`, prec);
        V := SolveCertified(f, prec);
        F := VanishingPolynomials(V, f, d, N, S, v);
        p := UnroundedVanishingPolynomial(V, F, f, d, N, S, v, ':-reduce' = reduce);
        if noloop or IsNearSplitPolynomialStable(F, p) then
            stable := true;
        elif linear then
            prec := prec+1;
        else
            prec := 2*prec;
        end if
    end do;
    return primpart(p);
end proc;

# Function: GenerateDenseSystem
#   Random dense system generator.
#
# Parameters:
#   D - a list of integers, the degrees of the polynomials
#   x - the name of the indexed variables in the system
#   nvars = n (optional) - *n* is an integer, the number of variables; default to
#                          *nops(D)* the number of polynomials
#   scale = s (optional) - *s* is an integer, the scale of the dilatation x := x/s;
#                          default to *1*
#   opts - a sequence of options passed to the random generator
#
# Returns:
#   A list of *k = nops(D)* random polynomials in *x[1], ..., x[n]* of
#   degrees *D[1], ..., D[k]*.
GenerateDenseSystem := proc( D ::list(integer),
                             x ::name,
                             opts ::seq  := NULL,
                             { nvars ::integer := nops(D),
                               scale ::integer := 1 })
    local k, vars, sys;
    k := nops(D);
    vars := [seq(x[i], i = 1..nvars)];
    sys := [seq(randpoly(vars, degree=D[i], dense, opts), i=1..k)];
    sys := eval(sys, map(v -> v = v/scale, vars));
    sys := map(numer, sys);
    return sys;
end proc;

# Function: InterpolateSystem
#   Generate a system vanishing on a given list of points.
#
# Parameters:
#   L - a list of list of complex numbers, the list of points
#   x - the name of the indexed variables in the system
#
# Returns:
#   A list of polynomials in *x[1], ..., x[n]* that vanish simultaneously
#   exactly on the points given in *L*.
#
# Example:
#   > InterpolateSystem([[1,1],[0,1]],x);
#   > InterpolateSystem([[1,1],[1,0]],x);
InterpolateSystem := proc ( L ::list(list(radalgnum)),
                            x ::name)
    local n, sys, terms, vec, base, eqs, i;
    if nops(L) = 0 then return []; end if;
    n := nops(L[1]);
    sys := [ 0 $ n ];
    terms := table();
    sys[1] := mul(x[1] - v, v in {op(L[..,1])});
    for vec in L do
        if not assigned(terms[vec[1]]) then
            base := quo(sys[1], x[1]-vec[1], x[1])/subs(x[1]=vec[1], diff(sys[1], x[1]));
            terms[vec[1]] := [ 0, base $ n-1 ];
        end if;
        for i from 2 to n do
            terms[vec[1]][i] := terms[vec[1]][i]*(x[i] - vec[i])
        end do;
    end do;
    for eqs in entries(terms, 'nolist') do
        for i from 2 to n do
            sys[i] := sys[i] + eqs[i];
        end do;
    end do;
    return sys;
end proc;

# Function: ConjugateClosure
#   Complete a list of points with the conjugates.
#
# Parameters:
#   L - a list of list of complex numbers, the list of points
#
# Returns:
#   The minimal list of points that contains L and the conjugates of its
#   points.
#
# Example:
#   > ConjugateClosure([[I,1],[I,-1],[1+I,I],[0,1]]);
ConjugateClosure := proc ( L ::list(list(complex(numeric))) )
    local S;
    S := {op(L)} union { seq(evalc(conjugate(x)), x in L) };
    return [op(S)];
end proc;


# Function: GenerateComplexUnitDisk
#   Sample complex number uniformy distributed in the unit disk.
#
# Parameters:
#   d - an integer, the number of digits of the real and imaginary parts;
#       default is *Digits*.
#   real - a boolean, if *true* then the generated number will be real.
#
# Returns:
#   A complex number of module lesser or equal to 1.
GenerateComplexInUnitDisk := proc( d::integer := Digits,
                                   real::truefalse := false)
    local digits_old, randangle, randmodule, a, m, x, y;
    digits_old := Digits;
    Digits := d;
    if real then
        x := convert(rand(-1.0..1.0)(),rational);
        Digits := digits_old;
        return x;
    end if;
    randangle := rand(0..evalf(2*Pi));
    randmodule := sqrt@rand(0..1.0);
    x := 1; y := 1;
    while x^2+y^2 > 1 do
        a := randangle();
        m := randmodule();
        x := convert(m*cos(a),rational);
        y := convert(m*sin(a),rational);
    end do;
    Digits := digits_old;
    return x + I*y;
end proc;

# Function: GenerateTwistedSystem
#   Random system generator with most coordinates in the unit disk.
#
# Parameters:
#   outliers - a list of integers, the numbers of points with the
#              correponding coordinate outside the unit disk.
#   x - the name of the indexed variables in the system.
#   d - an integer, the number of digits of the real and imaginary parts of
#       the roots of the system; default is *Digits*.
#   noclosure=b (optional) - *b* is a boolean, if *false*, the generated
#                            coordinates are doubled with their conjugates,
#                            such that the genrated system has only real
#                            coefficients; default is *true*.
#   scale = s (optional)   - *s* is an integer, the scale of the dilatation
#                            of the outliers; default is *1*.
#   real=b (optional)       - *b* is a boolean, if *true*, the generated coordinates
#                 are real.
#
# Returns:
#   A list of polynomials in *x[1], ..., x[n]* such that each root has
#   exxactly one coordinate outside the unit disk. Moreover if *noclosure*
#   is true, the list of the roots of the generated system contains exactly
#   *outliers[i]* points with the coordinate *x[i]* outside the unit disk.
#   Otherwise the roots contain exactly *2*outliers[i]* points with the
#   coordinate *x[i]* outside the unit disk.
GenerateTwistedSystem := proc( outliers ::list(integer),
                               x        ::name,
                               d        ::integer := Digits,
                               { noclosure ::truefalse := false,
                                 scale     ::rational  := 1,
                                 real      ::truefalse := false } )
    local S, n, i, k, vec, v, L, sys;
    S := NULL;
    n := nops(outliers);
    for i from 1 to n do
        for k from 1 to outliers[i] do
            vec := [ GenerateComplexInUnitDisk/scale $ n ](d, real);
            v := GenerateComplexInUnitDisk(d, real);
            if v<>0 then
                vec[i] := scale / v;
            else
                vec[i] := scale;
            end if;
            S := S, vec;
        end do;
    end do;
    L := [S];
    if not noclosure then
        L := ConjugateClosure(L);
    end if;
    sys := InterpolateSystem(L, x);
    return expand(sys);
end proc;

# Function: AllOutsideUnitPolydisk
#   Checks if the approximations to a set of algebraic points are all
#   outside the unit polydisk.
#
# Parameters:
#  sys - list of polynomials
#
# Returns:
#  True if all the complex solutions of *sys* have a coordinate with module greater than one.
AllOutsideUnitPolydisk := proc(sys ::list(polynom))
    local sols, lowermod;
    sols := [evalf(solve(sys,explicit))];
    lowermod := min(map2(max@map, abs@rhs, sols));
    if lowermod > 1 then
        return true;
    else
        return false;
    end if;
end proc;



###############################################################General Intersection routine
##############################################################





IntersectionPolydisk := proc(sys)
local b;
if nops(sys)=1 then
   return IsStable(op(sys));
else
   if Groebner:-IsZeroDimensional(sys) then
   return IsStabilizable(sys)
   end if;
end if;
end proc:


# 
