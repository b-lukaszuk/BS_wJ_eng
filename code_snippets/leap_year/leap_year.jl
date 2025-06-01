# the Gregorian Calendar was introduced in 1582
# that year: 4th October, was followed by 15th October
# before there was the Julian calendar
function isLeap(yr::Int)::Bool
    @assert 1 <= yr <= 4001
    divisibleBy4::Bool = yr % 4 == 0
    divisibleBy100::Bool = yr % 100 == 0
    divisibleBy400::Bool = yr % 400 == 0
    gregorianException::Bool = divisibleBy100 && !divisibleBy400
    if yr <= 1582
        return divisibleBy4
    end
    if divisibleBy4
        return !gregorianException
    else
        return false
    end
end

yrs = [1792, 1859, 1900, 1918, 1974, 1985, 2000, 2012]
isLeap.(yrs)
filter(isLeap, yrs)
