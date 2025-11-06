# todo
# https://en.wikipedia.org/wiki/Pseudorandom_number_generator
# https://en.wikipedia.org/wiki/List_of_random_number_generators#Pseudorandom_number_generators_(PRNGs)

# https://en.wikipedia.org/wiki/Linear_congruential_generator
# https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform


# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

import Dates as Dt

const Flt = Float64

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

function getRand(::Type{Flt})::Flt
    return getRand() / m
end

# 0-9, uniform?
function getRand(::Type{Int})::Int
    return floor(getRand(Flt) * 10)
end

x = [getRand(Int) for i in 1:1_000_000]
getCounts(x)
