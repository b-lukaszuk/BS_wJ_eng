import Random as Rand

const Flt = Float64
const Str = String
const Vec = Vector

# the code in this file is meant to serve as a programming exercise only
# and it may not act correctly

const BIRTHDAYS = 1:365
const N_SIMULATIONS = 100_000

function getCounts(v::Vector{T})::Dict{T,Int} where T
    counts::Dict{T,Int} = Dict()
    for elt in v
        counts[elt] = get(counts, elt, 0) + 1
    end
    return counts
end

function getBdaysOfPeopleAtParty(nPeopleAtParty::Int)::Vec{Int}
    @assert nPeopleAtParty > 3 "at least 4 people must be at a party"
    return Rand.rand(BIRTHDAYS, nPeopleAtParty)
end

function any2peopleBornSameDay(nPeopleAtParty::Int)::Bool
    @assert nPeopleAtParty > 3 "at least 4 people must be at a party"
    peopleBdays::Vec{Int} = getBdaysOfPeopleAtParty(nPeopleAtParty)
    counts::Dict{Int, Int} = getCounts(peopleBdays)
    sameBday::Union{Int, Nothing} = findfirst((>)(1), counts)
    return isnothing(sameBday) ? false : true
end

function getProbAny2SameBdays(nPeopleAtParty::Int, nSimulations::Int=N_SIMULATIONS)::Flt
    @assert nPeopleAtParty > 3 "at least 4 people must be at a party"
    @assert 10_000 <= nSimulations <= 1_000_000 "nSimulations must be in range [1e4-1e6]"
    sameBdays::Vec{Bool} = Vec{Bool}(undef, nSimulations)
    for i in 1:nSimulations
        sameBdays[i] = any2peopleBornSameDay(nPeopleAtParty)
    end
    return sum(sameBdays)/nSimulations
end

# getProbAny2SameBdays(23, N_SIMULATIONS)
Rand.seed!(303)
probs = map(getProbAny2SameBdays, 4:50)
println(probs)
