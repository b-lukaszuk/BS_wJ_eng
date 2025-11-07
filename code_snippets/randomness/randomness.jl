# todo
# https://en.wikipedia.org/wiki/Pseudorandom_number_generator
# https://en.wikipedia.org/wiki/List_of_random_number_generators#Pseudorandom_number_generators_(PRNGs)

# https://en.wikipedia.org/wiki/Linear_congruential_generator
# https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

import Dates as Dt

a = 1664525
c = 1013904223
m = 2^32
seed = round(Int, Dt.now() |> Dt.datetime2unix)

function setSeed!(newSeed)
    global seed = newSeed
    return nothing
end

function getRand()::Int
    newSeed::Int = (a * seed + c) % m
    setSeed!(newSeed)
    return newSeed
end

function getCounts(v::Vector{T})::Dict{T,Int} where T
    counts::Dict{T,Int} = Dict()
    for elt in v
        counts[elt] = get(counts, elt, 0) + 1
    end
    return counts
end

function getRand(::Type{Float64})::Float64
    return getRand() / m
end

# uniform?
function getRand(uptoExcl::Int)::Int
    @assert 0 < uptoExcl "uptoExcl must be greater than 0"
    return floor(getRand(Float64) * uptoExcl)
end

# uniform?
x = [getRand(5) for i in 1:100_000]
getCounts(x)
x = [getRand(7) for i in 1:100_000]
getCounts(x)

# uniform?
function getRand(minIncl::Int, maxIncl::Int)::Int
    @assert 0 < minIncl < maxIncl "must get: 0 < minIncl < maxIncl"
    return minIncl + getRand(maxIncl-minIncl+1)
end

# uniform?
x = [getRand(1, 5) for i in 1:100_000]
getCounts(x)
x = [getRand(2, 7) for i in 1:100_000]
getCounts(x)
