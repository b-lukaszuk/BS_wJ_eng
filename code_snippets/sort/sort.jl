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
