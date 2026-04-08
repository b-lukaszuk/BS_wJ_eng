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
# 1 is neutral for multiplication
function str2int(s::Str, def::Int=1)::Int
    try
        return parse(Int, s)
    catch
        return def
    end
end

isAtoZ(c::Char)::Bool = c in 'A':'Z'
isatoz(c::Char)::Bool = c in 'a':'z'
"""
sc(s)
```

Calculating molar weight of a molecule will require us to proceed atom by
atom. At times an element will be followed by a number (by which we'll have to
multiply its mass). Therefore, we define `str2int` that transforms a string (`s`)
into an integer (`parse(Int, s)`) and if it fails (e.g. in the case of an empty
string) it returns a default (`def`) value (here we go with 1 as it's neutral
for multiplication). Next, we will need to discern between capital (beginning of
a new element) and small letters (continuation of an element that started
previously). For that we define `isAtoZ` and `isatoz`. The above are one-liners,
hence they are defined as [single expression
functions](https://en.wikibooks.org/wiki/Introducing_Julia/Functions#Single_expression_functions). We
could go wit the built-it `isuppercase` and `islowercase` but I prefer it may
way since our custom functions will allow us to detect incorrectly typed
elements, e.g. `"Cą"` instead `"Ca"`.
