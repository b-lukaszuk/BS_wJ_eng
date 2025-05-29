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
x = getDaysInRectangle(30, 3)
reshapeVec(x, Int(length(x) / 7), 7, true)

# May 2025
x = getDaysInRectangle(31, 5)
reshapeVec(x, Int(length(x) / 7), 7, true)

# June 2025
x = getDaysInRectangle(30, 1)
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
function getFmtMonth(nMonth::Int, nDays::Int, firstDay::Int)::Str
    @assert 1 <= nMonth <= 12 "nMonth must be in range [1-12]"
    @assert 28 <= nDays <= 31 "nDays must be in range [28-31]"
    @assert 1 <= firstDay <= 7 "firstDay must be in range [1-7]"
    daysVerbs::Str = join(["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], " ")
    days::Vec{Str} = string.(getDaysInRectangle(nDays, firstDay))
    days = replace(days, "0" =>" ")
    m::Matrix{Str} = reshapeVec(days, Int(length(days)/7), 7, true)
    fmtDay(day) = lpad(day, 2)
    fmtRow(row) = join(map(fmtDay, row), " ")
    result::Str = ""
    for r in eachrow(m)
        result *= fmtRow(r) * "\n"
    end
    return  center(get(months, nMonth, 1), length(daysVerbs)) * "\n" *
        daysVerbs * "\n" * result
end
