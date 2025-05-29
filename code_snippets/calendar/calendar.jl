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
