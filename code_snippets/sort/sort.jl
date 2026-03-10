# TODO: sort
# https://en.wikipedia.org/wiki/Sorting_algorithm

const Vec = Vector

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

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

xs = [47, 15, 23, 99, 4]
sort(xs) == qs(xs)
