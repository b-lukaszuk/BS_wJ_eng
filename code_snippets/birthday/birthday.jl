import Random as Rand

const Flt = Float64
const Str = String
const Vec = Vector

# the code in this file is meant to serve as a programming exercise only
# and it may not act correctly

function getCounts(v::Vector{T})::Dict{T,Int} where T
    counts::Dict{T,Int} = Dict()
    for elt in v
        counts[elt] = get(counts, elt, 0) + 1
    end
    return counts
end

function getBdaysAtParty(nPeople::Int)::Vec{Int}
    @assert 3 < nPeople < 366 "nPeople must be in range [4-365]"
    return Rand.rand(1:365, nPeople)
end

function areAnyBornSameDay(nPeople::Int)::Bool
    @assert 3 < nPeople < 366 "nPeople must be in range [4-365]"
    peopleBdays::Vec{Int} = getBdaysAtParty(nPeople)
    counts::Dict{Int, Int} = getCounts(peopleBdays)
    sameBday::Union{Int, Nothing} = findfirst((>)(1), counts)
    return isnothing(sameBday) ? false : true
end

function getProbAny2SameBdays(nPeople::Int, nSimulations::Int=100_000)::Flt
    @assert 3 < nPeople < 366 "nPeople must be in range [4-365]"
    @assert 1e4 <= nSimulations <= 1e6 "nSimulations not in range [1e4-1e6]"
    sameBdays::Vec{Bool} = Vec{Bool}(undef, nSimulations)
    for i in 1:nSimulations
        sameBdays[i] = areAnyBornSameDay(nPeople)
    end
    return sum(sameBdays)/nSimulations
end

function anyBdayEqMyBday(nPeople::Int, myBday::Int=1)::Bool
    @assert 3 < nPeople < 366 "nPeople must be in range [4-365]"
    peopleBdays::Vec{Int} = getBdaysAtParty(nPeople)
    counts::Dict{Int, Int} = getCounts(peopleBdays)
    return haskey(counts, myBday)
end

function getProbMyBday(nPeople::Int, myBday::Int=1, nSimulations::Int=1000_000)::Flt
    @assert 3 < nPeople < 366 "nPeople must be in range [4-365]"
    @assert 1e4 <= nSimulations <= 1e6 "nSimulations not in range [1e4-1e6]"
    sameMyBdays::Vec{Bool} = Vec{Bool}(undef, nSimulations)
    for i in 1:nSimulations
        sameMyBdays[i] = anyBdayEqMyBday(nPeople, myBday)
    end
    return sum(sameMyBdays)/nSimulations
end

# getProbAny2SameBdays(23, N_SIMULATIONS)
Rand.seed!(303)
probs = map(getProbMyBday, 5:50)
probs = map(getProbAny2SameBdays, 4:50)
println(probs)
