# Molar Mass {#sec:molar_mass}

In this chapter I did not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/molar_mass)
(without explanations).

## Problem {#sec:molar_mass_problem}

I remember that when I was in high-school we used to have a lot of chemistry
classes filled with problem solving. The key part of them was to calculate molar
masses of different molecules. That segment, although essential, was rather
boring. So I always wanted to have something that would speed up the
calculations for me.

This time your job is to write a solver that will calculate a molar mass of a
chemical formula. Make sure your solution works by using it on the following
input:

- $CH_{4}$ (methane, natural gas, fossil fuel),
- $H_{2}O$ (water),
- $HCl$ (hydrochloric acid produced in your stomach),
- $CO_{2}$ (carbon dioxide, breath it out),
- $C_{3}H_{8}$ (propane, natural gas, fossil fuel),
- $C_{2}H_{5}OH$ (ethanol, is it time to quit drinking?),
- $(CH_{3})_{2}CO$ (acetone, nail polish remover),
- $NaCl$ (sodium chloride, kitchen salt),
- $CH_{3}COOH$ (acetic acid, vinegar),
- $H_{2}CO_{3}$ (carbonic acid present in your blood),
- $C_{6}H_{12}O_{6}$ (glucose, it gives you energy),
- $C_{11}H_{12}N_{2}O_{2}$ (tryptophan, amino acid, builds proteins),
- $CH_{3}(CH_{2})_{14}COOH$ (palmitic acid, builds fat),
- $C_{34}H_{32}O_{4}N_{4}Fe$ (heme B, located in your red blood cells)
- $Ca_{10}(PO_{4})_{6}(OH)_{2}$ (calcium hydroxyapatite found in your bones)
- $C_{169719}H_{270466}N_{45688}O_{52238}S_{911}$ (titin, a protein that builds your muscles)

Below I paste the formulas and their masses for testing purposes.

```jl
s = """
formulas = ["CH4", "H2O", "HCl", "CO2", "C3H8", "C2H5OH", "(CH3)2CO",
            "NaCl", "CH3COOH", "H2CO3", "C6H12O6", "C11H12N2O2",
            "CH3(CH2)14COOH", "C34H32O4N4Fe", "Ca10(PO4)6(OH)2",
            "C169719H270466N45688O52238S911"]
masses = [16.043, 18.01528, 36.46, 44.01, 44.097, 46.069, 58.08, 58.443,
          60.052, 62.03, 180.156, 204.229, 256.43, 616.487, 1004.61,
          3_816_030]
"""
sc(s)
```

A list of chemical elements and their masses is to be found, e.g. on [this
Wikipedia page](https://en.wikipedia.org/wiki/List_of_chemical_elements#List).

For simplicity, you may assume, that a chemical formula (at least the one at a
high-school level) is composed of [ASCII](https://en.wikipedia.org/wiki/ASCII)
characters (capital/small letters + digits) and non-nested parentheses.

## Solution {#sec:molar_mass_solution}

We start by defining the elements mass table.

```jl
s = """
ELTS_MASS_TBL = Dict{Str, Flt}(
    "H" => 1.008, "He" => 4.0026, "Li" => 6.94, "Be" => 9.0122,
    "B" => 10.81, "C" => 12.011, "N" => 14.007, "O" => 15.999,
    "F" => 18.998, "Ne" => 20.18, "Na" => 22.99, "Mg" => 24.305,
    "Al" => 26.982, "Si" => 28.085, "P" => 30.974, "S" => 32.06,
    "Cl" => 35.45, "Ar" => 39.95, "K" => 39.098, "Ca" => 40.078,
    "Sc" => 44.956, "Ti" => 47.867, "V" => 50.942, "Cr" => 51.996,
    "Mn" => 54.938, "Fe" => 55.845, "Co" => 58.933, "Ni" => 58.693,
    "Cu" => 63.546, "Zn" => 65.38, "Ga" => 69.723, "Ge" => 72.63,
    "As" => 74.922, "Se" => 78.971, "Br" => 79.904, "Kr" => 83.798,
    "Rb" => 85.468, "Sr" => 87.62, "Y" => 88.906, "Zr" => 91.224,
    "Nb" => 92.906, "Mo" => 95.95, "Tc" => 96.906, "Ru" => 101.07,
    "Rh" => 102.91, "Pd" => 106.42, "Ag" => 107.87, "Cd" => 112.41,
    "In" => 114.82, "Sn" => 118.71, "Sb" => 121.76, "Te" => 127.6,
    "I" => 126.9, "Xe" => 131.29, "Cs" => 132.91, "Ba" => 137.33,
    "La" => 138.91, "Ce" => 140.12, "Pr" => 140.91, "Nd" => 144.24,
    "Pm" => 144.913, "Sm" => 150.36, "Eu" => 151.96, "Gd" => 157.25,
    "Tb" => 158.93, "Dy" => 162.5, "Ho" => 164.93, "Er" => 167.26,
    "Tm" => 168.93, "Yb" => 173.05, "Lu" => 174.97, "Hf" => 178.49,
    "Ta" => 180.95, "W" => 183.84, "Re" => 186.21, "Os" => 190.23,
    "Ir" => 192.22, "Pt" => 195.08, "Au" => 196.97, "Hg" => 200.59,
    "Tl" => 204.38, "Pb" => 207.2, "Bi" => 208.98, "Po" => 208.982,
    "At" => 209.987, "Rn" => 222.018, "Fr" => 223.02, "Ra" => 226.025,
    "Ac" => 227.028, "Th" => 232.04, "Pa" => 231.04, "U" => 238.03,
    "Np" => 237.048, "Pu" => 244.064, "Am" => 243.061, "Cm" => 247.070,
    "Bk" => 247.070, "Cf" => 251.08, "Es" => 252.083, "Fm" => 257.095,
    "Md" => 258.098, "No" => 259.101, "Lr" => 266.12, "Rf" => 267.122,
    "Db" => 268.126, "Sg" => 269.128, "Bh" => 270.133, "Hs" => 269.134,
    "Mt" => 277.154, "Ds" => 282.166, "Rg" => 282.169, "Cn" => 286.179,
    "Nh" => 286.182, "Fl" => 290.192, "Mc" => 290.196, "Lv" => 293.205,
    "Ts" => 294.211, "Og" => 295.216
)
"""
replace(sc(s), "ELTS_MASS_TBL" => "const ELTS_MASS_TBL")
```

All right, let's start with a simple formula solver, but first some helper
functions.

```jl
s = """
MASS_FALLBACK = typemin(Flt)

function getEltMass(elt::Str)::Flt
    return isempty(elt) ? 0.0 : get(ELTS_MASS_TBL, elt, MASS_FALLBACK)
end

# 1 is neutral for multiplication
function str2int(s::Str, def::Int=1)::Int
    try
        return parse(Int, s)
    catch
        return def
    end
end
"""
replace(sc(s), "MASS_FALLBACK =" => "const MASS_FALLBACK =")
```

First we define `getEltMass` that for an empty string (`isempty(elt)` - no
element at all) returns the mass equal `0.0` (no mass at all). Otherwise, it
fetches the mass out of `ELTS_MASS_TBL`. If the element (`elt`) is not there it
returns `MASS_FALLBACK` which is `typemin(Flt)`. That last expression is equal
to `-Inf`, a special value that we want to use as an indicator that something
went wrong. In general, `-Inf` propagates since almost any value added to `-Inf`
is `-Inf`.

To calculate the molar mass of a molecule we plan to proceed atom by atom. At
times an element will be followed by a number (by which we'll have to multiply
its mass). Therefore, we define `str2int` that `try`ies to transform a string
(`s`) into an integer (`parse(Int, s)`). Normally, when it fails (e.g. in the
case of an empty string) it throws an error. But we
[catch](https://docs.julialang.org/en/v1/manual/control-flow/#The-try/catch-statement)
it and `return` a default value (`def`) instead (here we go with 1 as it's
neutral for multiplication).

OK, now back to the simple formula solver.

```jl
s = """
function getMolMassSimple(formula::Str)::Flt
    mass::Flt = 0.0
    curElt::Str = ""
    curNum::Str = ""
    for c in formula
        if isuppercase(c)
            mass += getEltMass(curElt) * str2int(curNum)
            curElt = string(c)
            curNum = ""
        elseif islowercase(c)
            curElt *= c
        elseif isdigit(c)
            curNum *= c
        else # should not happen
            return MASS_FALLBACK
        end
    end
    mass += getEltMass(curElt) * str2int(curNum)
    return mass
end
"""
sc(s)
```

The algorithm is rather mundane. We start by initializing a few variables,
`mass` - to hold the result, `curElt` to keep the currently examined element,
`curNum` - that stores current number of atoms of a given element. Next, we
traverse the `formula` one character at a time (`for c in formula`). If the
examined character is a capital letter (`isuppercase(c)`) we calculate the mass
of previously stored element (`curElt` multiplied by `curNum` ) and add it to
`mass` (`mass += etc.`). Of course, we remember to reset the `curElt` and
`curNum` to their new values. If a character is a small letter (`elseif
islowercase(c)`) or a digit (`elseif isdigit(c)`) we just append it to the
previously encountered element (`curElt *= c`) or number (`curNum *= c`),
respectively. If the character (`c`) passes through all our guards (`else`) then
we return `MASS_FALLBACK`. Anyway, after leaving the `for` loop and before the
`return` statement we must do some cleanup. That's because the mass is
calculated only when we encounter a capital letter (`isuppercase(c)`), so we
need to remember to add a mass of the final element (`mass += etc.`) in a
formula before we `return` from our function.

Let's do some minimal testing.

```jl
s = """
isSameMass(x::Flt, y::Flt)::Bool = isapprox(x, y, rtol=0.0001)

map(isSameMass, getMolMassSimple.(formulas[1:6]), masses[1:6])
"""
sco(s)
```

For that we defined `isSameMass` using [single expression function
syntax](https://en.wikibooks.org/wiki/Introducing_Julia/Functions#Single_expression_functions).
Inside it relies on
[isapprox](https://docs.julialang.org/en/v1/base/math/#Base.isapprox) with
relative tolerance (`rtol`) set to `0.0001`. The function is used to account for
any rounding errors in `ELTS_MASS_TBL` or `masses`. It considers two numbers
equal if they differ by no more than 1/10,000th (i.e. `isSameMass(10_000.0,
9_999.0` is `true`, but `isSameMass(10_000.0, 9_998.9)` is `false`)). Anyway,
all the masses of all the tested simple formulas were roughly equal to those in
the `masses` vector (`1` is an abbreviated printout for `true`, `0` would be an
abbreviated printout for `false`).

OK, time for more complicated formulas.

```jl
s = """
function isInSimpleChemFormula(c::Char)::Bool
    return isuppercase(c) || islowercase(c) || isdigit(c)
end

function getMolMass(formula::Str)::Flt
    curGroup::Str = ""
    curMultiplier::Str = ""
    bracketEnded::Bool = false
    groups::Vec{Str} = []
    multipliers::Vec{Int} = []
    for c in formula
        if isInSimpleChemFormula(c) && !bracketEnded
            curGroup *= c
        elseif isdigit(c) && bracketEnded
            curMultiplier *= c
        elseif isAtoZ(c) && bracketEnded
            bracketEnded = false
            push!(groups, curGroup)
            push!(multipliers, str2int(curMultiplier))
            curGroup = string(c)
            curMultiplier = ""
        elseif c == '('
            push!(groups, curGroup)
            push!(multipliers, str2int(curMultiplier))
            curGroup = ""
            curMultiplier = ""
        elseif c == ')'
            bracketEnded = true
        else # should never happen
            # no chem elt abbrev as J
            curGroup = "J" # triggers fallback in getMolMassSimple
        end
    end
    push!(groups, curGroup)
    push!(multipliers, str2int(curMultiplier))
    return sum(getMolMassSimple.(groups) .* multipliers)
end
"""
sco(s)
```

Here, we decided to split a complicated `formula` into `group`s of simple
formulas that we already can solve correctly. We also added `multipliers ` for
our `group`s and `bracketEnded`, a flag that tells us whether the previous
character (`c`) was an end of a parenthesized group (`c == ')'`). Just like in
`getMolMassSimple` we move one character at a time (`for c in formula`) and do
some checks. If a character belongs to a simple formula (`if
isInSimpleChemFormula(c)`) and (`&&`) it is not right after the parentheses
(`!bracketEnded`) then we just append it to the current group (`curGroup *= c`).
If it is a digit (`elseif isdigit(c)`) right after the bracket end (`&&
bracketEnded`) we append it to the multiplier for the current group
(`curMultiplier`). Else, if it is a capital letter (`elseif isAtoZ(c)`) that
follows the closing bracket (`&& bracketEnded`) then we start a new group
(`curGroup = string(c)`) and multiplier (`curMultiplier = ""`). Additionally, we
do some cleanup (reset `bracketEnded` and `push` previous group and multiplier
to the appropriate collections). Likewise, if the parentheses just started
(`elseif c == '('`) we push the previous group and multiplier to the collections
and reset the current values (`curGroup = ""` and `curMultiplier = ""`). Of
course we must remember to set the `bracketEnded` flag to `true` when the
parentheses end (`elseif c == ')'`). Once again, before we `return` our result
we `push` the last group and multiplier (cleanup). Our final result is just a
`sum` of masses of all groups (`getMolMassSimple.(groups)`) multiplied by the
appropriate numbers (`.* multipliers`).

Let's see how we did.

```jl
s = """
map(isSameMass, getMolMass.(formulas), masses)
"""
sco(s)
```

Apparently, we did just fine.
