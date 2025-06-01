const Str = String
const Vec = Vector

const daysPerWeek::Int = 7
const daysPerMonth::Vec{Int} = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
const daysPerMonthLeap::Vec{Int} = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
const shiftYr::Int = 1 # using 365 here works the same
const shiftYrLeap::Int = 2 # using 366 here works the same
const months::Dict{Int, Str} = Dict(
    1 => "January", 2 => "February", 3 => "March",
    4 => "April", 5 => "May", 6 => "June", 7 => "July",
    8 => "August", 9 => "September", 10 => "October",
    11 => "November", 12 => "December")

# returns multiple of mult that is >= num
function getMultiple(num::Int, mult::Int=daysPerWeek)::Int
    @assert num > 0 "num must be > 0"
    @assert mult > 0 "mult must be > 0"
    if num % mult == 0
        return num
    else
        return Int(ceil(num / mult) * mult)
    end
end

# 1 - Sunday, 7 - Saturday
function getDaysInRectangle(nDays::Int, firstDay::Int)::Vec{Int}
    nDaysFront::Int = firstDay-1
    daysFront::Vec{Int} = repeat([0], nDaysFront)
    daysMid::Vec{Int} = collect(1:nDays)
    nDaysFrontMid::Int = nDaysFront + nDays
    nDaysBack::Int = getMultiple(nDaysFrontMid, daysPerWeek) - nDaysFrontMid
    daysBack::Vec{Int} = repeat([0], nDaysBack)
    days::Vec{Int} = vcat(daysFront, daysMid, daysBack)
    return days
end

function vec2matrix(v::Vec{T}, r::Int, c::Int, byRow::Bool)::Matrix{T} where T
    len::Int = length(v)
    @assert (len == r*c)
    m::Matrix{T} = Matrix{T}(undef, r, c)
    stepBegin::Int = 1
    stepSize::Int = (byRow ? c : r) - 1
    for i in 1:(byRow ? r : c)
        if byRow
            m[i, :] = v[stepBegin:(stepBegin+stepSize)]
        else
            m[:, i] = v[stepBegin:(stepBegin+stepSize)]
        end
        stepBegin += (stepSize + 1)
    end
    return m
end

# February 2025
x = getDaysInRectangle(28, 7);
vec2matrix(x, Int(length(x) / daysPerWeek), daysPerWeek, true)

# March 2025
x = getDaysInRectangle(31, 7);
vec2matrix(x, Int(length(x) / daysPerWeek), daysPerWeek, true)

# April 2025
x = getDaysInRectangle(30, 3);
vec2matrix(x, Int(length(x) / daysPerWeek), daysPerWeek, true)

# May 2025
x = getDaysInRectangle(31, 5);
vec2matrix(x, Int(length(x) / daysPerWeek), daysPerWeek, true)

# June 2025
x = getDaysInRectangle(30, 1);
vec2matrix(x, Int(length(x) / daysPerWeek), daysPerWeek, true)

# fn from chapter: Pascal's triangle
function center(sth::A, totLen::Int)::Str where A<:Union{Int, Str}
    s::Str = string(sth)
    len::Int = length(s)
    @assert totLen > 0 && len > 0 "both totLen and len must be > 0"
    @assert totLen >= len "totLen must be >= len"
    diff::Int = totLen - len
    leftSpaceLen::Int = round(Int, diff / 2)
    rightSpaceLen::Int = diff - leftSpaceLen
    return " " ^ leftSpaceLen * s * " " ^ rightSpaceLen
end

# 1 - Sunday, 7 - Saturday
function getFmtMonth(firstDayMonth::Int, nDaysMonth::Int, month::Int, year::Int)::Str
    @assert 1 <= year <= 4000 "year must be in range [1-4000]"
    @assert 1 <= month <= 12 "month must be in range [1-12]"
    @assert 28 <= nDaysMonth <= 31 "nDaysMonth must be in range [28-31]"
    @assert 1 <= firstDayMonth <= 7 "firstDayMonth must be in range [1-7]"
    daysVerbs::Str = join(["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], " ")
    days::Vec{Str} = string.(getDaysInRectangle(nDaysMonth, firstDayMonth))
    days = replace(days, "0" =>" ")
    m::Matrix{Str} = vec2matrix(days, Int(length(days)/daysPerWeek), daysPerWeek, true)
    fmtDay(day) = lpad(day, 2)
    fmtRow(row) = join(map(fmtDay, row), " ")
    result::Str = ""
    for r in eachrow(m)
        result *= fmtRow(r) * "\n"
    end
    return  center(months[month] * string(" ", year), length(daysVerbs)) *
        "\n" * daysVerbs * "\n" * result
end

getFmtMonth(7, 28, 2, 2025) |> print
getFmtMonth(7, 31, 3, 2025) |> print
getFmtMonth(3, 30, 4, 2025) |> print
getFmtMonth(5, 31, 5, 2025) |> print
getFmtMonth(2, 31, 12, 2025) |> print

# 1 - Sunday, 7 - Saturday
function getShiftedDay(curDay::Int, by::Int)::Int
    @assert 1 <= curDay <= 7 "curDay not in range [1-7]"
    @assert by > 0 "by must be positive integer"
    newDay::Int = curDay
    shift::Int = by % daysPerWeek
    for _ in 1:shift
        newDay += 1
        if newDay > daysPerWeek
            newDay = 1
        end
    end
    return newDay
end

# the Gregorian Calendar was introduced in 1582
# that year: 4th October, was followed by 15th October
# before there was the Julian calendar
function isLeap(yr::Int)::Bool
    @assert 1 <= yr <= 4001
    divisibleBy4::Bool = yr % 4 == 0
    divisibleBy100::Bool = yr % 100 == 0
    divisibleBy400::Bool = yr % 400 == 0
    gregorianException::Bool = divisibleBy100 && !divisibleBy400
    if divisibleBy4
        return !gregorianException
    else
        return false
    end
end

# 1 - Sunday, 7 - Saturday
# returns (1st day of month, num of days in this month)
function getMonthData(dayJan1::Int, month::Int, leap::Bool)::Tuple{Int, Int}
    @assert 1 <= dayJan1 <= 7 "day not in range [1-7]"
    @assert 1 <= dayJan1 <= 12 "month not in range [1-12]"
    curDay::Int = dayJan1
    daysInMonths::Vec{Int} = leap ? daysPerMonthLeap : daysPerMonth
    if month == 1
        return (dayJan1, daysInMonths[month])
    end
    for m in 2:month
        curDay = getShiftedDay(curDay, daysInMonths[m-1])
    end
    return (curDay, daysInMonths[month])
end

# 1 - Sunday, 7 - Saturday
# returns (1st day of month, num of days in this month)
function getMonthData(yr::Int, month::Int)::Tuple{Int, Int}
    @assert 1 <= yr <= 4000 "yr not in range [1-4000]"
    @assert 1 <= month <= 12 "month not in range [1-12]"
    curDay::Int = 2 # 1st Jan of year 1 was Monday
    for y in 1:(yr-1)
        curDay = getShiftedDay(curDay, isLeap(y) ? shiftYrLeap : shiftYr)
    end
    return getMonthData(curDay, month, isLeap(yr))
end

# Feb 2000
getFmtMonth(getMonthData(2000, 2)..., 2, 2000) |> print
# Sep 2001
getFmtMonth(getMonthData(2001, 9)..., 9, 2001) |> print
# Dec 2020
getFmtMonth(getMonthData(2020, 12)..., 12, 2020) |> print
