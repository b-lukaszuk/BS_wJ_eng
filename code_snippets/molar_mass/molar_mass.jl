# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

# TODO: molar mass

# custom type definitions
const Flt = Float64
const Str = String
const Vec = Vector

# mass table elt_abbrev => g_per_mol
const ELTS_TBL = Dict{Str, Flt}(
    "H" => 1.008, "He" => 4.0026, "Li" => 7, "Be" => 9.012183,
    "B" => 10.81, "C" => 12.011, "N" => 14.007, "O" => 15.999,
    "F" => 18.99840316, "Ne" => 20.18, "Na" => 22.9897693,
    "Mg" => 24.305, "Al" => 26.981538, "Si" => 28.085, "P" => 30.973762,
    "S" => 32.07, "Cl" => 35.45, "Ar" => 39.9, "K" => 39.0983,
    "Ca" => 40.08, "Sc" => 44.95591, "Ti" => 47.867, "V" => 50.9415,
    "Cr" => 51.996, "Mn" => 54.93804, "Fe" => 55.84, "Co" => 58.93319,
    "Ni" => 58.693, "Cu" => 63.55, "Zn" => 65.4, "Ga" => 69.723,
    "Ge" => 72.63, "As" => 74.92159, "Se" => 78.97, "Br" => 79.9,
    "Kr" => 83.8, "Rb" => 85.468, "Sr" => 87.62, "Y" => 88.90584,
    "Zr" => 91.22, "Nb" => 92.90637, "Mo" => 95.95, "Tc" => 96.90636,
    "Ru" => 101.1, "Rh" => 102.9055, "Pd" => 106.42, "Ag" => 107.868,
    "Cd" => 112.41, "In" => 114.818, "Sn" => 118.71, "Sb" => 121.76,
    "Te" => 127.6, "I" => 126.9045, "Xe" => 131.29, "Cs" => 132.905452,
    "Ba" => 137.33, "La" => 138.9055, "Ce" => 140.116, "Pr" => 140.90766,
    "Nd" => 144.24, "Pm" => 144.91276, "Sm" => 150.4, "Eu" => 151.964,
    "Gd" => 157.2, "Tb" => 158.92535, "Dy" => 162.5, "Ho" => 164.93033,
    "Er" => 167.26, "Tm" => 168.93422, "Yb" => 173.05, "Lu" => 174.9668,
    "Hf" => 178.49, "Ta" => 180.9479, "W" => 183.84, "Re" => 186.207,
    "Os" => 190.2, "Ir" => 192.22, "Pt" => 195.08, "Au" => 196.96657,
    "Hg" => 200.59, "Tl" => 204.383, "Pb" => 207, "Bi" => 208.9804,
    "Po" => 208.98243, "At" => 209.98715, "Rn" => 222.01758,
    "Fr" => 223.01973, "Ra" => 226.02541, "Ac" => 227.02775,
    "Th" => 232.038, "Pa" => 231.03588, "U" => 238.0289, "Np" => 237.048172,
    "Pu" => 244.0642, "Am" => 243.06138, "Cm" => 247.07035, "Bk" => 247.07031,
    "Cf" => 251.07959, "Es" => 252.083, "Fm" => 257.09511, "Md" => 258.09843,
    "No" => 259.101, "Lr" => 266.12, "Rf" => 267.122, "Db" => 268.126,
    "Sg" => 269.128, "Bh" => 270.133, "Hs" => 269.1336, "Mt" => 277.154,
    "Ds" => 282.166, "Rg" => 282.169, "Cn" => 286.179, "Nh" => 286.182,
    "Fl" => 290.192, "Mc" => 290.196, "Lv" => 293.205, "Ts" => 294.211,
    "Og" => 295.216
)

# sodium chloride, carbon dioxide, water, carbonic acid, acetate, calcium hydroxyapatate
formulas = ["NaCl", "CO2", "H2O", "H2CO3", "C6H12O6", "(CH3)2CO", "Ca10(PO4)6(OH)2"]
masses = [58.443, 44.01, 18.01528, 62.03, 180.156, 58.08, 1004.61]

function str2int(s::Str)::Int
    try
        return parse(Int, s)
    catch
        return 1
    end
end

function getMolMassSimple(formula::Str)::Flt
    mass::Flt = 0.0
    curElt::Str = ""
    curDigit::Str = ""
    for c in formula
        if c in 'A':'Z'
            mass += get(ELTS_TBL, curElt, 0) * str2int(curDigit)
            curElt = string(c)
            curDigit = ""
        elseif c in 'a':'z'
            curElt *= c
        elseif c in '0':'9'
            curDigit *= c
        else # should not happen
            return typemin(Flt)
        end
    end
    mass += get(ELTS_TBL, curElt, 0) * str2int(curDigit)
    return mass
end

isSameMass(x::Flt, y::Flt)::Bool = isapprox(x, y, rtol=0.0001)
map(isSameMass, getMolMassSimple.(formulas[1:5]), masses[1:5])

function getMolMass(formula::Str)::Flt
    curCount::Str = ""
    curGroup::Str = ""
    bracketEnded::Bool = false
    groups::Vec{Str} = []
    counts::Vec{Int} = []
    for c in formula
        if !(c in '(':')') && !bracketEnded
            curGroup *= c
        end
        if c in '0':'9' && bracketEnded
            curCount *= c
        end
        if c in 'A':'Z' && bracketEnded
            bracketEnded = false
            push!(groups, curGroup)
            push!(counts, str2int(curCount))
            curGroup = string(c)
            curCount = ""
        end
        if  c == '('
            push!(groups, curGroup)
            push!(counts, str2int(curCount))
            curGroup = ""
            curCount = ""
        end
        if c == ')'
            bracketEnded = true
        end
    end
    push!(groups, curGroup)
    push!(counts, str2int(curCount))
    return sum(getMolMassSimple.(groups) .* counts)
end

map(isSameMass, getMolMass.(formulas), masses)

function getAllMatches(rmi::Base.RegexMatchIterator)::Vec{Str}
    allMatches::Vec{RegexMatch} = collect(rmi)
    return isempty(allMatches) ? [] :
        [regMatch.match for regMatch in allMatches]
end

function getPatterns(txt::Str, pattern::Str)::Vec{Str}
    eachmatch(Regex(pattern), txt) |> getAllMatches
end

function getAtomsAndNumbers(simpleFormula::Str)::Vec{Str}
    return getPatterns(simpleFormula, "[A-Z][a-z]{0,1}[0-9]{0,}")
end

formulas[1:5]
getAtomsAndNumbers.(formulas[1:5])

function getAtom(atomAndNumber::Str)::Str
    return getPatterns(atomAndNumber, "[A-Z][a-z]{0,1}")[1]
end

function getNumberOfAtoms(atomAndNumber::Str)::Str
    nAtoms::Vec{Str} = getPatterns(atomAndNumber, "[0-9]{1,}")
    return isempty(nAtoms) ? "1" : nAtoms[1]
end

function getmolmasssimple(formula::Str)::Flt
    atomsNumbers::Vec{Str} = getAtomsAndNumbers(formula)
    atoms::Vec{Str} = getAtom.(atomsNumbers)
    numbers::Vec{Int} = getNumberOfAtoms.(atomsNumbers) .|> str2int
    masses::Vec{Flt} = get.(Ref(ELTS_TBL), atoms, 1.0)
    return sum(masses .* numbers )
end

map(isSameMass, getMolMassSimple.(formulas[1:5]), masses[1:5])
map(isSameMass, getmolmasssimple.(formulas[1:5]), masses[1:5])

function getGroups(formula::Str)::Vec{Str}
    return eachmatch(r"\(.+?\)\d{1,}", formula) |> getAllMatches
end

x = getGroups(formulas[6])

function getInsidesOfGroup(group::Str)::Str
    result::Vec{Str} = eachmatch(r"\((.+?)\)", group) |> getAllMatches
    return  strip(result[1], ['(', ')'])
end
x .|> getInsidesOfGroup

function getMultiplierForGroup(group::Str)::Str
    result::Vec{Str} = eachmatch(r"\d{1,}$", group) |> getAllMatches
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

map(isSameMass, getMolMassSimple.(formulas[1:5]), masses[1:5])
map(isSameMass, getmolmasssimple.(formulas[1:5]), masses[1:5])

map(isSameMass, getMolMass.(formulas), masses)
map(isSameMass, getmolmass.(formulas), masses)


# methane, hydrochloric acid, propane, vinegar, acetate, palmitic acid,
# tryptophane, hemeB, titin
xs = ["CH4", "HCl", "C3H8", "C2H5OH", "CH3COOH", "CH3(CH2)14COOH", "C11H12N2O2",
      "C34H32O4N4Fe", "C169719H270466N45688O52238S911"]
ys = [16.043, 36.46, 44.097, 46.069, 60.052, 256.430, 204.229,
      616.487, 3_816_030]

map(isSameMass, getMolMass.(xs), ys)
map(isSameMass, getmolmass.(xs), ys)

map(isSameMass, getMolMassSimple.(xs[1:5]), ys[1:5])
map(isSameMass, getmolmasssimple.(xs[1:5]), ys[1:5])
