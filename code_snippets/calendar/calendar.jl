import Dates as Dt

const Str = String
const Vec = Vector

# the code in this file is meant to serve as a programming exercise only
# and it may not act correctly

const daysPerWeek::Int = 7
const daysPerMonth::Vec{Int} = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
const daysPerMonthLeap::Vec{Int} = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
const shiftYr::Int = 365
const shiftYrLeap::Int = 366
const weekdaysNames::Vec{Str} = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
const monthsNum2Name::Dict{Int, Str} = Dict(
    1 => "January", 2 => "February", 3 => "March",
    4 => "April", 5 => "May", 6 => "June", 7 => "July",
    8 => "August", 9 => "September", 10 => "October",
    11 => "November", 12 => "December")
const monthsName2Num::Dict{Str, Int} = Dict(
     "Jan" => 1, "Feb" => 2, "Mar" => 3,
    "Apr" => 4, "May" => 5, "Jun" => 6, "Jul" => 7,
    "Aug" => 8, "Sep" => 9, "Oct" => 10,
    "Nov" => 11, "Dec" => 12)

# returns multiple of y that is >= x
function getMultOfYGtEqX(x::Int, y::Int=daysPerWeek)::Int
    @assert x > 0 && y > 0 "x and y must be > 0"
    @assert x >= y "x must be >= y"
    if x % y == 0
        return x
    else
        return round(Int, ceil(x / y)) * y
    end
end

# or

# returns multiple of y that is >= x
function getMultOfYGtEqX(x::Int, y::Int=daysPerWeek)::Int
    @assert x > 0 && y > 0 "x and y must be > 0"
    @assert x >= y "x must be >= y"
    q::Int, r::Int = divrem(x, y) # quotient, reminder
    if r == 0
        return x
    else
        return (q + 1) * y
    end
end

# 1 - Sunday, 7 - Saturday
function getPaddedDays(nDays::Int, fstDay::Int)::Vec{Int}
    daysFront::Int = fstDay - 1
    days::Vec{Int} = zeros(getMultOfYGtEqX(nDays+daysFront, daysPerWeek))
    days[fstDay:(fstDay+nDays-1)] = 1:nDays
    return days
end

function vec2matrix(v::Vec{T}, r::Int, c::Int, byRow::Bool)::Matrix{T} where T
    @assert (r > 0 && c > 0) "r and c must be positive integers"
    @assert (length(v) == r*c) "length(v) must be equal to r*c"
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

jan2025 = getPaddedDays(31, 4)
vec2matrix(jan2025, Int(length(jan2025) / daysPerWeek), daysPerWeek, true)

jun2025 = getPaddedDays(30, 1)
vec2matrix(jun2025, Int(length(jun2025) / daysPerWeek), daysPerWeek, true)

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
function getFmtMonth(fstDayMonth::Int, nDaysMonth::Int,
                     month::Int, year::Int)::Str
    @assert 1 <= fstDayMonth <= 7 "fstDayMonth must be in range [1-7]"
    @assert 28 <= nDaysMonth <= 31 "nDaysMonth must be in range [28-31]"
    @assert 1 <= month <= 12 "month must be in range [1-12]"
    @assert 1 <= year <= 4000 "year must be in range [1-4000]"
    topRow2::Str = join(weekdaysNames, " ")
    topRow1::Str = center(
        string(monthsNum2Name[month], " ", year), length(topRow2))
    days::Vec{Str} = string.(getPaddedDays(nDaysMonth, fstDayMonth))
    days = replace(days, "0" => " ")
    m::Matrix{Str} = vec2matrix(
        days, Int(length(days)/daysPerWeek), daysPerWeek, true)
    fmtDay(day) = lpad(day, 2)
    fmtRow(row) = join(map(fmtDay, row), " ")
    result::Str = ""
    for r in eachrow(m)
        result *= fmtRow(r) * "\n"
    end
    return topRow1 * "\n" * topRow2 * "\n" * result
end

getFmtMonth(4, 31, 1, 2025) |> print
getFmtMonth(1, 30, 6, 2025) |> print

# 1 - Sunday, 7 - Saturday
function getShiftedDay(curDay::Int, by::Int)::Int
    @assert 1 <= curDay <= 7 "curDay not in range [1-7]"
    newDay::Int = curDay
    shift::Int = abs(by) % daysPerWeek
    move::Int = by < 0 ? -1 : 1
    for _ in 1:shift
        newDay += move
        newDay = newDay < 1 ? 7 : (newDay > 7 ? 1 : newDay)
    end
    return newDay
end

# assumes the Gregorian Calendar for yr [1 - 4000]
function isLeap(yr::Int)::Bool
    @assert 0 < yr < 4000
    divisibleBy4::Bool = yr % 4 == 0
    gregorianException::Bool = (yr % 100 == 0) && (yr % 400 != 0)
    return divisibleBy4 && !gregorianException
end

# 1 - Sunday, 7 - Saturday
# returns (1st day of month, num of days in this month)
function getMonthData(dayJan1::Int, month::Int, leap::Bool)::Tuple{Int, Int}
    @assert 1 <= dayJan1 <= 7 "day not in range [1-7]"
    @assert 1 <= month <= 12 "month not in range [1-12]"
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
    curDay::Int = 4 # 1st Jan 2025 was Wednesday
    start::Int = yr <= 2025 ? 2025-1 : 2025+1
    step::Int = yr <= 2025 ? -1 : 1
    yrShift::Int = 0
    for y in start:step:yr
        yrShift = isLeap(y) ? shiftYrLeap : shiftYr
        curDay = getShiftedDay(curDay,  yrShift * step)
    end
    return getMonthData(curDay, month, isLeap(yr))
end

function getCal(month::Int, yr::Int)::Str
    # ... - unpacks tuple into separate values
    getFmtMonth(getMonthData(yr, month)..., month, yr)
end

function getCal(month::Str, yr::Int)::Str
    m::Int = monthsName2Num[month]
    getCal(m, yr)
end

getCal("Jan", 2025) |> print
d = Dt.Date(2025, 1, 1)
Dt.dayname(d)

# Jesus's birth
getCal("Dec", 1) |> print
d = Dt.Date(1, 12, 25)
Dt.dayname(d)

# the end of the world (one of many)
getCal("Dec", 2012) |> print
d = Dt.Date(2012, 12, 21)
Dt.dayname(d)

# start of the next millennium
getCal("Jan", 3000) |> print
d = Dt.Date(3000, 1, 1)
Dt.dayname(d)
