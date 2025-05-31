const Str = String
const Vec = Vector

# returns multiple of mult that is >= num
function getMultiple(num::Int, mult::Int=7)::Int
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
    nDaysBack::Int = getMultiple(nDaysFrontMid, 7) - nDaysFrontMid
    daysBack::Vec{Int} = repeat([0], nDaysBack)
    days::Vec{Int} = vcat(daysFront, daysMid, daysBack)
    return days
end

function reshapeVec(v::Vec{T}, r::Int, c::Int, byRow::Bool)::Matrix{T} where T
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

# April 2025
x = getDaysInRectangle(30, 3);
reshapeVec(x, Int(length(x) / 7), 7, true)

# May 2025
x = getDaysInRectangle(31, 5);
reshapeVec(x, Int(length(x) / 7), 7, true)

# June 2025
x = getDaysInRectangle(30, 1);
reshapeVec(x, Int(length(x) / 7), 7, true)

# February 2025
x = getDaysInRectangle(28, 7);
reshapeVec(x, Int(length(x) / 7), 7, true)

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

const months = Dict(
    1 => "January", 2 => "February", 3 => "March",
    4 => "April", 5 => "May", 6 => "June", 7 => "July",
    8 => "August", 9 => "September", 10 => "October",
    11 => "November", 12 => "December")

# 1 - Sunday, 7 - Saturday
function getFmtMonth(firstDayMonth::Int, nDaysMonth::Int, month::Int, year::Int)::Str
    @assert 1 <= year <= 4000 "year must be in range [1-4000]"
    @assert 1 <= month <= 12 "month must be in range [1-12]"
    @assert 28 <= nDaysMonth <= 31 "nDaysMonth must be in range [28-31]"
    @assert 1 <= firstDayMonth <= 7 "firstDayMonth must be in range [1-7]"
    daysVerbs::Str = join(["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], " ")
    days::Vec{Str} = string.(getDaysInRectangle(nDaysMonth, firstDayMonth))
    days = replace(days, "0" =>" ")
    m::Matrix{Str} = reshapeVec(days, Int(length(days)/7), 7, true)
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
    shift::Int = by % 7
    for _ in 1:shift
        newDay += 1
        if newDay > 7
            newDay = 1
        end
    end
    return newDay
end

function isLeap(yr::Int)::Bool
    @assert 0 < yr < 4000
    if yr % 4 != 0
        return false
    elseif yr % 25 != 0
        return true
    elseif yr % 16 != 0
        return false
    else
        return true
    end
end

# 1 - Sunday, 7 - Saturday
# returns (1st day of month, num of days in this month)
function getMonthData(dayJan1::Int, month::Int, leap::Bool)::Tuple{Int, Int}
    @assert 1 <= dayJan1 <= 7 "day not in range [1-7]"
    @assert 1 <= dayJan1 <= 12 "month not in range [1-12]"
    curDay::Int = dayJan1
    daysPerMonth::Vec{Int} = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    if leap
        daysPerMonth[2] += 1
    end
    if month == 1
        return (dayJan1, daysPerMonth[month])
    end
    for m in 2:month
        curDay = getShiftedDay(curDay, daysPerMonth[m-1])
    end
    return (curDay, daysPerMonth[month])
end

# 1 - Sunday, 7 - Saturday
# returns (1st day of month, num of days in this month)
function getMonthData(yr::Int, month::Int)::Tuple{Int, Int}
    @assert 1 <= yr <= 4000
    @assert 1 <= month <= 12
    curDay::Int = 7 # 1st Jan of year 1 is Saturday, so 7
    for y in 1:(yr-1)
        curDay = getShiftedDay(curDay, isLeap(y) ? 366 : 365)
    end
    return getMonthData(curDay, month, isLeap(yr))
end
