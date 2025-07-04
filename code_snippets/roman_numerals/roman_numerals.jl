const Str = String
const Vec = Vector

roman2arabic::Vec{Tuple{Str, Int}} = [
    ("M", 1000), ("CM", 900),
    ("D", 500), ("CD", 400),
    ("C", 100), ("XC", 90),
    ("L", 50), ("XL", 40),
    ("X", 10), ("IX", 9), ("V", 5), ("IV", 4), ("I", 1)
]

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

arabicTest = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
              11, 12, 39, 246, 789, 2421, 160, 207, 1009, 1066,
              3999, 1776, 1918, 1944, 2025]
romanTest = ["I", "II", "III", "IV", "V",
             "VI", "VII", "VIII", "IX", "X",
             "XI", "XII", "XXXIX", "CCXLVI", "DCCLXXXIX",
             "MMCDXXI", "CLX", "CCVII", "MIX", "MLXVI",
             "MMMCMXCIX", "MDCCLXXVI", "MCMXVIII", "MCMXLIV", "MMXXV"]

getRoman.(arabicTest) == romanTest
