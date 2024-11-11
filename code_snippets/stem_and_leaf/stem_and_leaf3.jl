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
nums6 = [44, 46, 47, -29, 63, 64, -16, 68, 68, 72, 72, 75, 76, 81, 84, 88, 106]
nums7 = [44, 46, 47, -29, 63, 64, -16, 68, 68, 72, 72, 75, 76, 81, 84, 88, 106, -106]
nums8 = [−23.678758, −12.45, −3.4, 4.43, 5.5, 5.678, 16.87, 24.7, 56.8]

function getCounts(nums::Vec{Int})::Dict{Str, Vec{Str}}
    @assert length(Set(nums)) > 1 "numbers musn't be the same"
    counts::Dict{Str, Vec{Str}} = Dict()
    stemUnitLen::Int = abs.(nums) |> maximum |> string |> length
    stemUnitLen = stemUnitLen == 1 ? stemUnitLen + 1 : stemUnitLen
    for num in nums
        numStr::Str = lpad(abs(num), stemUnitLen, "0")
        stem, leaf = numStr[1:end-1], string(numStr[end])
        stem = parse(Int, stem)
        stem = num < 0 ? string("-", stem) : string(stem)
        if haskey(counts, stem)
            counts[stem] = push!(counts[stem], leaf)
        else
            counts[stem] = [leaf]
        end
    end
    return counts
end

function getStemAndLeaf(nums::Vec{Int})::Str
    counts::Dict{Str, Vec{Str}} = getCounts(nums)
    result::Str = ""
    rStart::Int, rEnd::Int = extrema(parse.(Int, keys(counts)))
    maxLen::Int = length.(string.([rStart, rEnd])) |> maximum
    for i in rStart:rEnd
        k = string(i)
        if i == 0 && haskey(counts, "-" * k)
            result *=  lpad(string("-", i), maxLen, " ") * "|"
            if haskey(counts, "-" * k)
                result *= sort(counts["-" * k]) |> join
            end
            result *= "\n"
        end
        result *=  lpad(i, maxLen, " ") * "|"
        if haskey(counts, k)
            result *= sort(counts[k]) |> join
        end
        result *= "\n"
    end
    return result
end

function getStemAndLeaf(nums::Vec{Float64})::Str
    @assert all(abs.(nums) .> 1) "all numbers must be greater than abs(1)"
	return getStemAndLeaf(round.(Int, nums))
end

function printStemAndLeaf(nums::Vec{<:Real})
    getStemAndLeaf(nums) |> print
end

# tests
printStemAndLeaf(nums)
# nums2 compare https://en.wikipedia.org/wiki/Stem-and-leaf_display
# section construction (but without 106)
printStemAndLeaf(nums2)
# nums3 compare with: https://en.wikipedia.org/wiki/File:Stemplot_primes.svg
# figure for prime numbers under 100
printStemAndLeaf(nums3)
# nums4 compare https://en.wikipedia.org/wiki/Stem-and-leaf_display
# section construction (with 106)
printStemAndLeaf(nums4)
printStemAndLeaf(nums5)
printStemAndLeaf(nums6)
printStemAndLeaf(nums7)
# nums8 compare https://en.wikipedia.org/wiki/Stem-and-leaf_display
# section construction (example with floats)
printStemAndLeaf(nums8)
printStemAndLeaf(-9:1:9 |> collect)
printStemAndLeaf(0:1:9 |> collect)
printStemAndLeaf(0:1:10 |> collect)
printStemAndLeaf(0:1:20 |> collect)
