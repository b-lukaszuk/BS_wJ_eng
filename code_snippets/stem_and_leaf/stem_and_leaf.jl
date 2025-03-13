const Str = String
const Vec = Vector

# numbers for testing our stem-and-leaf plot
# prime numbers below 100
stemLeafTest1 = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37,
                41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
# example from the Construction section
stemLeafTest2 = [44, 46, 47, 49, 63, 64, 66, 68, 68, 72, 72, 75,
                76, 81, 84, 88, 106]
# another example from the Construction section
stemLeafTest3 = [-23.678758, -12.45, -3.4, 4.43, 5.5, 5.678,
                16.87, 24.7, 56.8]

function howManyChars(num::Int)::Int
    return num |> string |> length
end

function getMaxLengthOfNum(nums::Vec{Int})::Int
    maxLen::Int = map(howManyChars, nums) |> maximum
    return max(2, maxLen)
end

function getStemAndLeaf(num::Int, maxLenOfNum::Int)::Tuple{Str, Str}
    @assert maxLenOfNum > 1 "maxLenOfNum must be greater than 1"
    @assert howManyChars(num) <= maxLenOfNum
		"character count in num must be <= maxLenOfNum"
    numStr::Str = lpad(abs(num), maxLenOfNum, "0")
    stem::Str = numStr[1:end-1] |> string
    leaf::Str = numStr[end] |> string
    stem = parse(Int, stem) |> string #1
    stem = num < 0 ? "-" * stem : stem #2
    stem = lpad(stem, maxLenOfNum-1, " ") #3
    return (stem, leaf)
end

# returns Dict{stem, [leafs]}
function getLeafCounts(nums::Vec{Int})::Dict{Str, Vec{Str}}
    @assert length(Set(nums)) > 1 "numbers musn't be the same"
    counts::Dict{Str, Vec{Str}} = Dict()
    maxLenOfNum::Int = getMaxLengthOfNum(nums)
    stem::Str, leaf::Str = "", ""
    for num in nums
        stem, leaf = getStemAndLeaf(num, maxLenOfNum)
        if haskey(counts, stem)
            counts[stem] = push!(counts[stem], leaf)
        else
            counts[stem] = [leaf]
        end
    end
    return counts
end

function getStemLeafRow(key::Str, leafCounts::Dict{Str, Vec{Str}})::Str
    row::Str = ""
    if haskey(leafCounts, key)
        row *= key * "|"
        row *= sort(leafCounts[key]) |> join
        return row * "\n"
    end
    return row
end

function lt_for_keys(key1::Str, key2::Str)::Bool
    n1::Int, n2::Int = parse.(Int, (key1, key2))
    if n1 == n2 == 0
        return contains(key1, "-") ? true : false
    end
    return n1 < n2
end

function getStemLeafPlot(nums::Vec{Int})::Str
    leafCounts::Dict{Str, Vec{Str}} = getLeafCounts(nums)
    ks::Vec{Str} = keys(leafCounts) |> collect
    sort!(ks, lt=lt_for_keys)
    return [getStemLeafRow(k, leafCounts) for k in ks] |> join
end

# testing
getStemLeafPlot(stemLeafTest1) |> print
getStemLeafPlot(stemLeafTest2) |> print
