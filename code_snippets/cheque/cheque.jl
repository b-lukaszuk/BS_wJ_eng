const Str = String

# https://en.wikipedia.org/wiki/English_numerals
units = Dict(0 => "zero", 1 => "one",
             2 => "two", 3 => "three", 4 => "four",
             5 => "five", 6 => "six", 7 => "seven",
             8 => "eight", 9 => "nine")

function getUnis(u::Int)::Str
    @assert 0 <= u < 10 "u must be in range [0-9]"
    return units[u]
end

teens = Dict(10 => "ten", 11 => "eleven",
             12 => "twelve", 13 => "thirteen", 14 => "fourteen",
             15 => "fifteen", 16 => "sixteen", 17 => "seventeen",
             18 => "eighteen", 19 => "nineteen")

function getTeens(t::Int)::Str
    @assert 9 < t < 20 "t must be in range [10-19]"
    return teens[t]
end

tens = Dict(20 => "twenty", 30 => "thrity",
            40 => "forty", 50 => "fifty", 60 => "sixty",
            70 => "seventy", 80 => "eigthy", 90 => "ninety")

function getTens(t::Int)::Str
    @assert 20 <= t <= 99 "t must be in range [20-90]"
    # t - tens, u - units
    units::Int = rem(t, 10)
    return tens[t-units] * (units == 0 ? "" : "-" * getUnis(units))
end

function getEngNumeral0upto99(n::Int)::Str
    @assert 0 <= n <= 99
    if n < 10
        return getUnis(n)
    elseif n < 20
        return getTeens(n)
    else
        return getTens(n)
    end
end

getEngNumeral0upto99.([0, 5, 9, 11, 13, 21, 25, 32, 58, 64, 79, 83, 99])
