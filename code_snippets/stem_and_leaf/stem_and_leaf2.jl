const Str = String
const Vec = Vector

# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
function getPrimes(maxIncl::Int)
    @assert maxIncl >= 2 "maxIncl must be >= 2"
    maybePrimes::Vec{Bool} = ones(Bool, maxIncl)
    maybePrimes[1] = false # first prime is: 2
    for num in 2:maxIncl
        for multiple in (num*2):num:maxIncl
            maybePrimes[multiple] = false
        end
    end
    return collect(1:maxIncl)[maybePrimes]
end

nums = rand(0:99, 10)
nums2 = [44, 46, 47, 49, 63, 64, 66, 68, 68, 72, 72, 75, 76, 81, 84, 88]
nums3 = getPrimes(100)
nums4 = [44, 46, 47, 49, 63, 64, 66, 68, 68, 72, 72, 75, 76, 81, 84, 88, 106]
nums5 = [44, 46, 47, 49, 63, 64, 66, 68, 68, 72, 72, 75, 76, 81, 84, 88, 106, 1234]

function getCounts(nums::Vec{Int})::Dict{Int, Vec{Int}}
    counts::Dict{Int, Vec{Int}} = Dict()
    maxValLen::Int = maximum(nums) |> string |> length
    stemUnit::Int = maxValLen - 1
    for num in nums
        numStr::Str = lpad(num, maxValLen, "0")
        stem, leaf = numStr[1:stemUnit], numStr[end]
        stem, leaf = parse.(Int, (stem, leaf))
        if haskey(counts, stem)
            counts[stem] = push!(counts[stem], leaf)
        else
            counts[stem] = [leaf]
        end
    end
    return counts
end

function getStemAndLeaf(nums::Vec{Int})::Str
    counts::Dict{Int, Vec{Int}} = getCounts(nums)
    result::Str = ""
    rStart::Int, rEnd::Int = extrema(keys(counts))
    for i in rStart:rEnd
        result *=  string(i, "|")
        if haskey(counts, i)
            result *= map(string, sort(counts[i])) |> join
        end
        result *= "\n"
    end
    return result
end

print(getStemAndLeaf(nums))
print(getStemAndLeaf(nums2))
# compare with: https://en.wikipedia.org/wiki/File:Stemplot_primes.svg
print(getStemAndLeaf(nums3))
print(getStemAndLeaf(nums4))
