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
    @assert 0 <= n <= 99 "n must be in range [0-99]"
    if n < 20
        return unitsAndTeens[n]
    end
    u::Int = rem(n, 10) # u - units
    result::Str = tens[n-u]
    if u != 0
        result *= "-" * unitsAndTeens[u]
    end
    return result
end

function getEngNumeralUpto999(n::Int)::Str
    @assert 0 <= n <= 999 "n must be in range [0-999]"
    if n < 100
        return getEngNumeralUpto99(n)
    end
    h::Int, t::Int = divrem(n, 100) # h - hundreds, t - upto tens
    result::Str = getEngNumeralUpto99(h) * " hundred"
    if t != 0
        result *= " and " * getEngNumeralUpto99(t)
    end
    return result
end

function getEngNumeralBelow1M(n::Int)::Str
    @assert 0 <= n <= 999_999 "n must be in range [0-999,999]"
    if n < 1000
        return getEngNumeralUpto999(n)
    end
    t::Int, h::Int = divrem(n, 1000) # t - thousands, h - hundreds
    result::Str = getEngNumeralUpto999(t) * " thousand"
    if h == 0
        return result
    elseif h < 100
        result *= " and "
    else
        result *= ", "
    end
    result *= getEngNumeralUpto999(h)
    return result
end

getEngNumeralUpto99.([0, 5, 9, 11, 13, 21, 25, 32, 58, 64, 79, 83, 99])
getEngNumeralUpto999.([101, 109, 110, 117, 120, 152, 200, 208, 394, 400, 999])
getEngNumeralBelow1M.([1_800, 4_547, 5_005, 10_800, 96_779,
                       108_090, 108_001, 189_014, 500_506,
                       889_308])
