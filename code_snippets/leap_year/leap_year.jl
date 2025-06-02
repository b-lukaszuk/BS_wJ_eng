# the Gregorian Calendar was introduced in 1582
# that year: 4th October, was followed by 15th October
# before there was the Julian calendar
function isLeap(yr::Int)::Bool
    @assert 1 <= yr <= 4001
    divisibleBy4::Bool = yr % 4 == 0
    gregorianException::Bool = (yr % 100 == 0) && (yr % 400 != 0)
    if !divisibleBy4
        return false
    else
        if yr < 1583
            return true
        else
            return !gregorianException
        end
    end
end

function isLeap(yr::Int)::Bool
    @assert 1 <= yr <= 4001
    divisibleBy4::Bool = yr % 4 == 0
    gregorianException::Bool = (yr % 100 == 0) && (yr % 400 != 0)
    if !divisibleBy4
        return false
    else
        return yr < 1582 ? true : !gregorianException
    end
end

yrs = [1792, 1859, 1900, 1918, 1974, 1985, 2000, 2012]
isLeap.(yrs)
filter(isLeap, yrs)
# in every 400 years are 303 regular years and 97 leap years
# (in the Gregorian calendar)
filter(isLeap, 1583:(1583+400-1)) |> length
