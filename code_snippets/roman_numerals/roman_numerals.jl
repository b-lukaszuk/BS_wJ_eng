const Str = String
const Vec = Vector

arabicTest = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
              11, 12, 39, 246, 789, 2421, 160, 207, 1009, 1066,
              3999, 1776, 1918, 1944, 2025,
              1900, 1912]
romanTest = ["I", "II", "III", "IV", "V",
             "VI", "VII", "VIII", "IX", "X",
             "XI", "XII", "XXXIX", "CCXLVI", "DCCLXXXIX",
             "MMCDXXI", "CLX", "CCVII", "MIX", "MLXVI",
             "MMMCMXCIX", "MDCCLXXVI", "MCMXVIII", "MCMXLIV", "MMXXV",
             "MCM", "MCMXII"]

const roman2arabic = [("M", 1000), ("CM", 900),
                ("D", 500), ("CD", 400),
                ("C", 100), ("XC", 90),
                ("L", 50), ("XL", 40),
                ("X", 10), ("IX", 9), ("V", 5),
                ("IV", 4), ("I", 1)]

function getRoman(arabic::Int)::Str
    @assert 0 < arabic < 4000
    roman::Str = ""
    for (r, a) in roman2arabic
        while(arabic >= a)
            roman *= r
            arabic -= a
        end
    end
    return roman
end

# test
getRoman.(arabicTest) == romanTest

const romanTokens = map(first, roman2arabic)

function getTokenAndRest(roman::Str)::Tuple{Str, Str}
    if length(roman) <= 1
        return (roman, "")
    elseif roman[1:2] in romanTokens
        return (roman[1:2], string(roman[3:end]))
    else
        return (string(roman[1]), string(roman[2:end]))
    end
end

function getTokens(roman::Str)::Vec{Str}
    curToken::Str = ""
    allTokens::Vec{Str} = []
    while (roman != "")
        curToken, roman = getTokenAndRest(roman)
        push!(allTokens, curToken)
    end
    return allTokens
end

# not strictly necessary, one may use, e.g.
# get(Dict(roman2arabic), key, default) to the same effect
function getVal(lookup::Vec{Tuple{Str, Int}}, key::Str, default::Int=0)::Int
    for (k, v) in lookup
        if k == key
            return v
        end
    end
    return default
end

function getArabic(roman::Str)::Int
    tokens::Vec{Str} = getTokens(roman)
    sum::Int = 0
    for curToken in tokens
        sum += getVal(roman2arabic, curToken, 0)
    end
    return sum
end

# tests
getArabic.(romanTest) == arabicTest

getArabic.(getRoman.(arabicTest)) == arabicTest

getRoman.(getArabic.(romanTest)) == romanTest
