# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

# TODO: molar mass

# simple imports from different files
# the types
include("./custom_types.jl")
# ELTS_TBL is Dict{String, Float64}, key - elt abbrev, val - molar mass
include("./elements_molar_mass_table.jl")


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

function getAtomsAndNumbers(formula::Str)::Vec{Str}
    return getPatterns(formula, "[A-Z][a-z]{0,1}[0-9]{0,}")
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

function getmasssimple(formula::Str)::Flt
    atomsNumbers::Vec{Str} = getAtomsAndNumbers(formula)
    atoms::Vec{Str} = getAtom.(atomsNumbers)
    numbers::Vec{Int} = getNumberOfAtoms.(atomsNumbers) .|> str2int
    masses::Vec{Flt} = get.(Ref(ELTS_TBL), atoms, 1.0)
    return sum(masses .* numbers )
end

map(isSameMass, getMolMassSimple.(formulas[1:5]), masses[1:5])
map(isSameMass, getmasssimple.(formulas[1:5]), masses[1:5])

function getGroups(formula::Str)::Vec{Str}
    return eachmatch(r"\(.+?\)\d{1,}", formula) |> getAllMatches
end

x = getGroups(formulas[6])

function getInsides(group::Str)::Str
    result::Vec{Str} = eachmatch(r"\((.+?)\)", group) |> getAllMatches
    return  strip(result[1], ['(', ')'])
end
x .|> getInsides

function getMultiplier(group::Str)::Str
    result::Vec{Str} = eachmatch(r"\d{1,}$", group) |> getAllMatches
    return result[1]
end
x .|> getMultiplier

function remAll(txt::Str, spares::Vec{Str})::Str
    for spare in spares
        txt = replace(txt, spare => "")
    end
    return txt
end

function getPattern(txt::Str, pattern::Str)::Vec{Str}
    eachmatch(Regex(pattern), txt) |> getAllMatches
end

function getAtomsNumbers(formula::Str)::Vec{Str}
    return getPattern(formula, "[A-Z][a-z]{0,1}[0-9]{0,}")
end

getAtomsNumbers.(formulas[1:6])

function getAtom(atomNumber::Str)::Str
    return getPattern(atomNumber, "[A-Z][a-z]{0,1}")[1]
end

function getAtomNumber(atomNumber::Str)::Str
    nAtoms::Vec{Str} = getPattern(atomNumber, "[0-9]{1,}")
    return isempty(nAtoms) ? "1" : nAtoms[1]
end

function getmasssimple(formula::Str)::Flt
    atomsNumbers::Vec{Str} = getAtomsNumbers(formula)
    atoms::Vec{Str} = getAtom.(atomsNumbers)
    numbers::Vec{Int} = getAtomNumber.(atomsNumbers) .|> str2int
    masses::Vec{Flt} = get.(Ref(ELTS_TBL), atoms, 1.0)
    return sum(masses .* numbers )
end

map(isSameMass, getMolMassSimple.(formulas[1:5]), masses[1:5])
map(isSameMass, getmasssimple.(formulas[1:5]), masses[1:5])

function getmass(formula::Str)::Flt
    groupFormulas::Vec{Str} = getGroups(formula)
    groupInsides::Vec{Str} = getInsides.(groupFormulas)
    groupMultipliers::Vec{Int} = getMultiplier.(groupFormulas) .|> str2int
    formula = remAll(formula, groupFormulas)
    push!(groupInsides, formula)
    push!(groupMultipliers, 1)
    masses::Vec{Flt} = map(getMolMassSimple, groupInsides)
    return sum(masses .* groupMultipliers)
end

map(isSameMass, getMolMassSimple.(formulas[1:5]), masses[1:5])
map(isSameMass, getmasssimple.(formulas[1:5]), masses[1:5])

map(isSameMass, getMolMass.(formulas), masses)
map(isSameMass, getmass.(formulas), masses)


# methane, hydrochloric acid, propane, vinegar, acetate, palmitic acid,
# tryptophane, hemeB, titin
xs = ["CH4", "HCl", "C3H8", "C2H5OH", "CH3COOH", "CH3(CH2)14COOH", "C11H12N2O2",
      "C34H32O4N4Fe", "C169719H270466N45688O52238S911"]
ys = [16.043, 36.46, 44.097, 46.069, 60.052, 256.430, 204.229,
      616.487, 3_816_030]

map(isSameMass, getMolMass.(xs), ys)
map(isSameMass, getmass.(xs), ys)
