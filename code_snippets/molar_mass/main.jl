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

isUpLetter(c::Char)::Bool = isletter(c) && isuppercase(c)
isLowLetter(c::Char)::Bool = isletter(c) && islowercase(c)

function getMolMassSimple(formula::Str)::Flt
    mass::Flt = 0
    curElt::Str = ""
    curDigit::Str = ""
    for c in formula
        if isUpLetter(c)
            mass += (isempty(curElt) ? 0 : ELTS_TBL[curElt]) * str2int(curDigit)
            curElt = string(c)
            curDigit = ""
        elseif isLowLetter(c)
            curElt *= c
        else # digit
            curDigit *= c
        end
    end
    mass += (isempty(curElt) ? 0 : ELTS_TBL[curElt]) * str2int(curDigit)
    return mass
end

isSameMass(x::Flt, y::Flt)::Bool = isapprox(x, y, rtol=0.0001)
map(isSameMass, getMolMassSimple.(formulas[1:5]), masses[1:5])

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

function getMolMass(formula::Str)::Flt
    groupFormulas::Vec{Str} = getGroups(formula)
    groupInsides::Vec{Str} = getInsides.(groupFormulas)
    groupMultipliers::Vec{Str} = getMultiplier.(groupFormulas)
    formula = remAll(formula, groupFormulas)
    push!(groupInsides, formula)
    push!(groupMultipliers, "1")
    masses::Vec{Flt} = map(getMolMassSimple, groupInsides) .*
        map(str2int, groupMultipliers)
    return sum(masses)
end

formulas[6]
formulas[6] |> getMolMass
masses[6]

formulas[7]
formulas[7] |> getMolMass
masses[7]

map(isSameMass, getMolMass.(formulas), masses)
getMolMass.(formulas)

