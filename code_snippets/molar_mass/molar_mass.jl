# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Flt = Float64
const Str = String
const Vec = Vector

# https://en.wikipedia.org/wiki/List_of_chemical_elements#List
# mass table elt_abbrev => g_per_mol
const ELTS_MASS_TBL = Dict{Str, Flt}(
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
const MASS_FALLBACK = typemin(Flt)

# for testing purposes
formulas = ["CH4", "H2O", "HCl", "CO2", "C3H8", "C2H5OH", "(CH3)2CO",
            "NaCl", "CH3COOH", "H2CO3", "C6H12O6", "C11H12N2O2",
            "CH3(CH2)14COOH", "C34H32O4N4Fe", "Ca10(PO4)6(OH)2",
            "C169719H270466N45688O52238S911"]
masses = [16.043, 18.01528, 36.46, 44.01, 44.097, 46.069, 58.08, 58.443,
          60.052, 62.03, 180.156, 204.229, 256.43, 616.487, 1004.61,
          3_816_030]
# for curiosity
names = ["methane", "water", "hydrochloric acid", "carbon dioxide", "propane",
         "ehtanol", "acetone", "sodium chloride", "acetic acid",
         "carbonic acid", "glucose", "tryptophane", "palmitic acid",
         "hemeB", "calcium hydroxyapatite", "titin"]

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

function getEltMass(elt::Str, def::Flt=0.0)::Flt
    return isempty(elt) ? def : get(ELTS_MASS_TBL, elt, MASS_FALLBACK)
end

function getMolMassSimple(formula::Str)::Flt
    mass::Flt = 0.0
    curElt::Str = ""
    curNum::Str = ""
    for c in formula
        if isAtoZ(c)
            mass += getEltMass(curElt) * str2int(curNum)
            curElt = string(c)
            curNum = ""
        elseif isatoz(c)
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

isSameMass(x::Flt, y::Flt)::Bool = isapprox(x, y, rtol=0.0001)
map(isSameMass, getMolMassSimple.(formulas[1:6]), masses[1:6])

function isInSimpleChemFormula(c::Char)::Bool
    return isAtoZ(c) || isatoz(c) || isdigit(c)
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

map(isSameMass, getMolMass.(formulas), masses)

function getPatternsInTxt(pattern::Regex, txt::Str)::Vec{Str}
    matches::Vec{RegexMatch} = collect(eachmatch(pattern, txt))
    return isempty(matches) ? [] : [regMatch.match for regMatch in matches]
end

function getAtomsAndNumbers(simpleFormula::Str)::Vec{Str}
    return getPatternsInTxt(r"[A-Z][a-z]{0,1}[0-9]{0,}", simpleFormula)
end

formulas[1:6]
getAtomsAndNumbers.(formulas[1:6])

function getAtom(atomAndNumber::Str)::Str
    return getPatternsInTxt(r"[A-Z][a-z]{0,1}", atomAndNumber)[1]
end

function getNumberOfAtoms(atomAndNumber::Str)::Str
    nAtoms::Vec{Str} = getPatternsInTxt(r"[0-9]{1,}", atomAndNumber)
    return isempty(nAtoms) ? "1" : nAtoms[1]
end

function getmolmasssimple(formula::Str)::Flt
    atomsNumbers::Vec{Str} = getAtomsAndNumbers(formula)
    atoms::Vec{Str} = getAtom.(atomsNumbers)
    numbers::Vec{Int} = getNumberOfAtoms.(atomsNumbers) .|> str2int
    masses::Vec{Flt} = get.(Ref(ELTS_MASS_TBL), atoms, 1.0)
    return sum(masses .* numbers )
end

map(isSameMass, getmolmasssimple.(formulas[1:6]), masses[1:6])

function getGroups(formula::Str)::Vec{Str}
    return getPatternsInTxt(r"\(.+?\)\d{1,}", formula)
end

x = getGroups(formulas[7])

function getInsidesOfGroup(group::Str)::Str
    result::Vec{Str} = getPatternsInTxt(r"\((.+?)\)", group)
    return  strip(result[1], ['(', ')'])
end
x .|> getInsidesOfGroup

function getMultiplierForGroup(group::Str)::Str
    result::Vec{Str} = getPatternsInTxt(r"\d{1,}$", group)
    return result[1]
end
x .|> getMultiplierForGroup

function remAll(txt::Str, spares::Vec{Str})::Str
    for spare in spares
        txt = replace(txt, spare => "")
    end
    return txt
end

function getmolmass(formula::Str)::Flt
    groupFormulas::Vec{Str} = getGroups(formula)
    groupInsides::Vec{Str} = getInsidesOfGroup.(groupFormulas)
    groupMultipliers::Vec{Int} = getMultiplierForGroup.(groupFormulas) .|> str2int
    formula = remAll(formula, groupFormulas)
    push!(groupInsides, formula)
    push!(groupMultipliers, 1)
    masses::Vec{Flt} = map(getMolMassSimple, groupInsides)
    return sum(masses .* groupMultipliers)
end

map(isSameMass, getMolMass.(formulas), masses)
map(isSameMass, getmolmass.(formulas), masses)
