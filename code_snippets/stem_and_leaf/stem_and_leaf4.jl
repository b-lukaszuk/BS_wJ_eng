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
nums3 = [44, 46, 47, 49, 63, 64, 66, 68, 68, 72, 72, 75, 76, 81, 84, 88, 106]
nums4 = getPrimes(100)
nums5 = [44, 46, 47, 49, 63, 64, 66, 68, 68, 72, 72, 75, 76, 81, 84, 88, 106, 1234]
nums6 = [44, 46, 47, -29, 63, 64, -16, 68, 68, 72, 72, 75, 76, 81, 84, 88, 106]
nums7 = [44, 46, 47, -29, 63, 64, -16, 68, 68, 72, 72, 75, 76, 81, 84, 88, 106, -106]
nums8 = [−23.678758, −12.45, −3.4, 4.43, 5.5, 5.678, 16.87, 24.7, 56.8]

function getStemAndLeaf(num::Int, stemLen::Int)::Tuple{Str, Str}
    numStr::Str = lpad(abs(num), stemLen, "0")
    stem, leaf = "$(numStr[1:end-1])", "$(numStr[end])"
    stem = parse(Int, stem)
    stem = num < 0 ? "-" * string(stem) : string(stem)
    stem = lpad(stem, stemLen, " ")
    return (stem, leaf)
end

# returns Dict{Stem, [Leafs]}
function getLeafCounts(nums::Vec{Int})::Dict{Str, Vec{Str}}
    @assert length(Set(nums)) > 1 "numbers musn't be the same"
    counts::Dict{Str, Vec{Str}} = Dict()
    stemUnitLen::Int = map(length ∘ string, nums) |> maximum
    stemUnitLen = stemUnitLen == 1 ? stemUnitLen + 1 : stemUnitLen
    stem::Str = ""
    leaf::Str = ""
    for num in nums
        stem, leaf = getStemAndLeaf(num, stemUnitLen)
        if haskey(counts, stem)
            counts[stem] = push!(counts[stem], leaf)
        else
            counts[stem] = [leaf]
        end
    end
    return counts
end

function getStemAndLeafRow(num::Int,
                           maxLen::Int,
                           leafCounts::Dict{Str, Vec{Str}})::Str
    row::Str = ""
    negZero::Str = lpad("-0", maxLen, " ")
    key::Str = lpad(num, maxLen, " ")
    if num == 0 && haskey(leafCounts, negZero)
        row *= negZero * "|"
        row *= sort(leafCounts[negZero]) |> join
        row *= "\n"
    end
    row::Str *= key * "|"
    if haskey(leafCounts, key)
        row *= sort(leafCounts[key]) |> join
    end
    return row * "\n"
end

function getStemAndLeafPlot(nums::Vec{Int})::Str
    counts::Dict{Str, Vec{Str}} = getLeafCounts(nums)
    result::Str = ""
    rStart::Int, rEnd::Int = extrema(parse.(Int, keys(counts)))
    maxLen::Int = map(length ∘ string, nums) |> maximum
    maxLen = maxLen == 1 ? maxLen + 1 : maxLen
    for i in rStart:rEnd
        result *=  getStemAndLeafRow(i, maxLen, counts)
    end
    return result
end

function getStemAndLeafPlot(nums::Vec{Float64})::Str
	return getStemAndLeafPlot(round.(Int, nums))
end

function printStemAndLeafPlot(nums::Vec{<:Real})
    getStemAndLeafPlot(nums) |> print
end

# tests
printStemAndLeafPlot(nums)
# nums2 compare https://en.wikipedia.org/wiki/Stem-and-leaf_display
# section construction (but without 106)
printStemAndLeafPlot(nums2)
# nums3 compare https://en.wikipedia.org/wiki/Stem-and-leaf_display
# section construction (with 106)
printStemAndLeafPlot(nums3)
# nums4 compare with: https://en.wikipedia.org/wiki/File:Stemplot_primes.svg
# figure for prime numbers under 100
printStemAndLeafPlot(nums4)
printStemAndLeafPlot(nums5)
printStemAndLeafPlot(nums6)
printStemAndLeafPlot(nums7)
# nums8 compare https://en.wikipedia.org/wiki/Stem-and-leaf_display
# section construction (example with floats)
printStemAndLeafPlot(nums8)
printStemAndLeafPlot(-9:1:9 |> collect)
printStemAndLeafPlot(0:1:9 |> collect)
printStemAndLeafPlot(0:1:10 |> collect)
printStemAndLeafPlot(0:1:20 |> collect)
printStemAndLeafPlot(rand(10))
