const Str = String
const Vec = Vector

const daysPerWeek::Int = 7
const daysPerMonth::Vec{Int} = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
const daysPerMonthLeap::Vec{Int} = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
const shiftYr::Int = 365
const shiftYrLeap::Int = 366
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

# returns multiple of mult that is >= num
function getMultiple(num::Int, mult::Int=daysPerWeek)::Int
    @assert num > 0 && mult > 0 "num and mult must be > 0"
    if num % mult == 0
        return num
    else
        return round(Int, ceil(num / mult)) * mult
    end
end

# 1 - Sunday, 7 - Saturday
function getDaysInRectangle(nDays::Int, firstDay::Int)::Vec{Int}
    daysFront::Int = firstDay - 1
    days::Vec{Int} = zeros(getMultiple(nDays+daysFront, daysPerWeek))
    days[firstDay:(firstDay+nDays-1)] = 1:nDays
    return days
end

function reshape2matrix(v::Vec{T}, r::Int, c::Int, byRow::Bool)::Matrix{T} where T
    len::Int = length(v)
    @assert (r > 0 && c > 0) "r and c must be positive integers"
    @assert (len == r*c) "length(v) must be equal r*c"
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
reshape2matrix(x, Int(length(x) / daysPerWeek), daysPerWeek, true)

# March 2025
x = getDaysInRectangle(31, 7);
reshape2matrix(x, Int(length(x) / daysPerWeek), daysPerWeek, true)

# April 2025
x = getDaysInRectangle(30, 3);
reshape2matrix(x, Int(length(x) / daysPerWeek), daysPerWeek, true)

# May 2025
x = getDaysInRectangle(31, 5);
reshape2matrix(x, Int(length(x) / daysPerWeek), daysPerWeek, true)

# June 2025
x = getDaysInRectangle(30, 1);
reshape2matrix(x, Int(length(x) / daysPerWeek), daysPerWeek, true)

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
    m::Matrix{Str} = reshape2matrix(days, Int(length(days)/daysPerWeek), daysPerWeek, true)
    fmtDay(day) = lpad(day, 2)
    fmtRow(row) = join(map(fmtDay, row), " ")
    result::Str = ""
    for r in eachrow(m)
        result *= fmtRow(r) * "\n"
    end
    return  center(monthsNum2Name[month] *
        string(" ", year), length(daysVerbs)) *
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
    newDay::Int = curDay
    shift::Int = abs(by) % daysPerWeek
    for _ in 1:shift
        newDay += by < 0 ? -1 : 1
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
    getFmtMonth(getMonthData(yr, month)..., month, yr)
end

function getCal(month::Str, yr::Int)::Str
    m::Int = monthsName2Num[month]
    getCal(m, yr)
end

# Feb 2000
getCal("Feb", 2000) |> print
# Sep 2001
getCal("Sep", 2001) |> print
# Dec 2020
getCal("Dec", 2020) |> print
# Oct 2029
getCal("Oct", 2029) |> print
# Mar 2050
getCal("Mar", 2050) |> print
