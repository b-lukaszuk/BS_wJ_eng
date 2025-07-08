const Str = String

# https://en.wikipedia.org/wiki/English_numerals
unitsAndTeens = Dict(0 => "zero", 1 => "one",
                     2 => "two", 3 => "three", 4 => "four",
                     5 => "five", 6 => "six", 7 => "seven",
                     8 => "eight", 9 => "nine", 10 => "ten",
                     11 => "eleven", 12 => "twelve",
                     13 => "thirteen", 14 => "fourteen",
                     15 => "fifteen", 16 => "sixteen",
                     17 => "seventeen", 18 => "eighteen",
                     19 => "nineteen")

tens = Dict(20 => "twenty", 30 => "thrity",
            40 => "forty", 50 => "fifty", 60 => "sixty",
            70 => "seventy", 80 => "eigthy", 90 => "ninety")

function getEngNumeralUpto99(n::Int)::Str
    @assert 0 <= n <= 99 "n must be in range [0-90]"
    if n < 20
        return unitsAndTeens[n]
    else
        u::Int = rem(n, 10) # u - units
        return tens[n-u] * (u == 0 ? "" : "-" * unitsAndTeens[u])
    end
end

getEngNumeralUpto99.([0, 5, 9, 11, 13, 21, 25, 32, 58, 64, 79, 83, 99])
