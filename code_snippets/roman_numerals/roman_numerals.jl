const Str = String
const Vec = Vector

roman2arabic = [("M", 1000), ("CM", 900),
                ("D", 500), ("CD", 400),
                ("C", 100), ("XC", 90),
                ("L", 50), ("XL", 40),
                ("X", 10), ("IX", 9), ("V", 5),
                ("IV", 4), ("I", 1)]
romanTokens = map(first, roman2arabic)
arabicTest = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
              11, 12, 39, 246, 789, 2421, 160, 207, 1009, 1066,
              3999, 1776, 1918, 1944, 2025]
romanTest = ["I", "II", "III", "IV", "V",
             "VI", "VII", "VIII", "IX", "X",
             "XI", "XII", "XXXIX", "CCXLVI", "DCCLXXXIX",
             "MMCDXXI", "CLX", "CCVII", "MIX", "MLXVI",
             "MMMCMXCIX", "MDCCLXXVI", "MCMXVIII", "MCMXLIV", "MMXXV"]

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

getRoman.(arabicTest) == romanTest

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
    token::Str = ""
    tokens::Vec{Str} = []
    while (roman != "")
        token, roman = getTokenAndRest(roman)
        push!(tokens, token)
    end
    return tokens
end

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
    for token in tokens
        sum += getVal(roman2arabic, token, 0)
    end
    return sum
end

getArabic.(romanTest) == arabicTest
