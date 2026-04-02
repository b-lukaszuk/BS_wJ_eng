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
