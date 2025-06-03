# the Gregorian Calendar was introduced in 1582
# that year: 4th October, was followed by 15th October
# before there was the Julian calendar
function isLeap(yr::Int)::Bool
    @assert 0 < yr < 4001
    divisibleBy4::Bool = yr % 4 == 0
    gregorianException::Bool = (yr % 100 == 0) && (yr % 400 != 0)
    if !divisibleBy4
        return false
    else
        return !gregorianException
    end
end

function isLeap(yr::Int)::Bool
    @assert 0 < yr < 4001
    divisibleBy4::Bool = yr % 4 == 0
    gregorianException::Bool = (yr % 100 == 0) && (yr % 400 != 0)
    return divisibleBy4 && !gregorianException
end

yrs = [1792, 1859, 1900, 1918, 1974, 1985, 2000, 2012]
isLeap.(yrs)
filter(isLeap, yrs)

# simple test suite
# for proper testing see: https://docs.julialang.org/en/v1/stdlib/Test/

# in the Gregorian calendar in every 400 years time span
# there are 303 regular years and 97 leap years
function runTest()::Int
    startYr::Int = 0
    endYr::Int = 0
    numLeapYrs::Int = 0
    for i in 1:3601
        startYr = i
        endYr = i + 400 - 1
        numLeapYrs = filter(isLeap, startYr:endYr) |> length
        if numLeapYrs != 97
            return 1
        end
    end
    return 0
end

runTest()
