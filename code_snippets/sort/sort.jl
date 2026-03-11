# TODO: sort
# https://en.wikipedia.org/wiki/Sorting_algorithm

const Str = String
const Vec = Vector

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

# https://en.wikipedia.org/wiki/Bubble_sort
function bs(v::Vec{Int})::Vec{Int}
    result::Vec{Int} = copy(v)
    swapped::Bool = true
    while swapped
        swapped = false
        for i in eachindex(result)[2:end]
            if result[i-1] > result[i]
                result[i-1], result[i] = result[i], result[i-1]
                swapped = true
            end
        end
    end
    return result
end

xs = [47, 15, 23, 99, 4]
bs(xs)

# https://en.wikipedia.org/wiki/Quicksort
function qs(v::Vec{Int})::Vec{Int}
    if isempty(v)
        return []
    else
        ind::Int = 1
        pivotElt::Int = v[ind]
        restV::Vec{Int} = v[ind+1:end]
        smallerElts::Vec{Int} = filter(elt -> elt < pivotElt, restV)
        greaterEqElts::Vec{Int} = filter(elt -> elt >= pivotElt, restV)
        return [qs(smallerElts); pivotElt; qs(greaterEqElts)]
    end
end

qs(xs)
sort(xs) == qs(xs)

# by - (A) -> B is applied to every elt of v before sorting
# lt - (B) -> Bool is applied to every elt of v after by was applied
function qs(v::Vec{A}, by::Function, lt::Function)::Vec{A} where A
    if isempty(v)
        return []
    else
        ind::Int = 1
        pivotElt::A = v[ind]
        restV::Vec{A} = v[ind+1:end]
        smallerElts::Vec{A} = filter(elt -> lt(by(elt), by(pivotElt)), restV)
        greaterEqElts::Vec{A} = filter(elt -> !lt(by(elt), by(pivotElt)), restV)
        return [qs(smallerElts, by, lt); pivotElt; qs(greaterEqElts, by, lt)]
    end
end

qs(xs, identity, <) == sort(xs, by=identity, lt=<)

# https://en.wikipedia.org/wiki/English_numerals
const UNITS_AND_TEENS = Dict(1 => "one",
                             2 => "two", 3 => "three", 4 => "four",
                             5 => "five", 6 => "six", 7 => "seven",
                             8 => "eight", 9 => "nine", 10 => "ten",
                             11 => "eleven", 12 => "twelve",
                             13 => "thirteen", 14 => "fourteen",
                             15 => "fifteen", 16 => "sixteen",
                             17 => "seventeen", 18 => "eighteen",
                             19 => "nineteen")

const TENS = Dict(2 => "twenty", 3 => "thrity",
                  4 => "forty", 5 => "fifty", 6 => "sixty",
                  7 => "seventy", 8 => "eigthy", 9 => "ninety")

function getEngNumeral(n::Int)::Str # uses recursion
    @assert 0 < n < 1e6 "n must be in range (0-1e6)"
    major::Int, minor::Int = 0, 0
    if n < 20
        return UNITS_AND_TEENS[n]
    elseif n < 100
        major, minor = divrem(n, 10)
        return TENS[major] * (
            minor == 0 ? "" : "-" * UNITS_AND_TEENS[minor]
        )
    elseif n < 1000
        major, minor = divrem(n, 100)
        return getEngNumeral(major) * " hundred" * (
            minor == 0 ? "" : " and " * getEngNumeral(minor)
        )
    else # < 1e6 due to @assert above
        major, minor = divrem(n, 1_000)
        return getEngNumeral(major) * " thousand" * (
            minor == 0 ? "" :
            minor < 100 ? " and " * getEngNumeral(minor) :
            ", " * getEngNumeral(minor)
        )
    end
end

qs(xs, getEngNumeral, <) == sort(xs, by=getEngNumeral, lt=<)
qs(1:100 |> collect, getEngNumeral, <) == sort(1:100 |> collect, by=getEngNumeral, lt=<)
qs(1:100 |> collect, getEngNumeral, <)
