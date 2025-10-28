import Random as Rnd

const Flt = Float64
const Str = String
const Vec = Vector

# the code in this file is meant to serve as a programming exercise only
# and it may not act correctly

function getBdaysAtParty(nPeople::Int)::Vec{Int}
    @assert 3 < nPeople < 366 "nPeople must be in range [4-365]"
    return Rnd.rand(1:365, nPeople)
end

function getCounts(v::Vector{T})::Dict{T,Int} where T
    counts::Dict{T,Int} = Dict()
    for elt in v
        counts[elt] = get(counts, elt, 0) + 1
    end
    return counts
end

function anySameBdays(counts::Dict{Int, Int})::Bool
    return isnothing(findfirst((>)(1), counts)) ? false : true
end

function anyMyBday(counts::Dict{Int, Int}, myBday::Int=1)::Bool
    return haskey(counts, myBday)
end

# isEventFn(Dict{Int, Int}) -> Bool
function getProbSuccess(nPeople::Int, isEventFn::Function,
                        nSimulations::Int=100_000)::Flt
    @assert 3 < nPeople < 366 "nPeople must be in range [4-365]"
    @assert 1e4 <= nSimulations <= 1e6 "nSimulations not in range [1e4-1e6]"
    successes::Vec{Bool} = Vec{Bool}(undef, nSimulations)
    for i in 1:nSimulations
        peopleBdays::Vec{Int} = getBdaysAtParty(nPeople)
        counts::Dict{Int, Int} = getCounts(peopleBdays)
        eventOccured::Bool = isEventFn(counts)
        successes[i] = eventOccured
    end
    return sum(successes)/nSimulations
end

# running a simulation may take a while
# reducing nSimulations will shorten the time and lower the precision of prob. estimation
Rnd.seed!(101)
probsAnySameBdays = Dict(i => getProbSuccess(i, anySameBdays) for i in 5:30)
probsMyBday = Dict(i => getProbSuccess(i, anyMyBday) for i in 5:30)
