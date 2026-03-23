# TODO the_answer
# https://en.wikipedia.org/wiki/Phrases_from_The_Hitchhiker%27s_Guide_to_the_Galaxy#The_Answer_to_the_Ultimate_Question_of_Life,_the_Universe,_and_Everything_is_42

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Str = String
const Vec = Vector

const CHARS = "0123456789abcdef" |> collect
const MIN_BASE = 2
const MAX_BASE = 16

function isBaseN(num::Char, n::Int)::Bool
    @assert MIN_BASE <= n <= MAX_BASE "n not in [$MIN_BASE - $MAX_BASE]"
    return num in CHARS[1:n]
end

function isBaseN(num::Str, n::Int)::Bool
    return isBaseN.(collect(num), n) |> all
end

function getNumOfSlots2codeDec(dec::Int, nBase::Int)::Int
    @assert MIN_BASE <= nBase <= MAX_BASE "n not in [$MIN_BASE - $MAX_BASE]"
    @assert 0 <= dec <= 1024 "dec must be in range [0-1024]"
    dec = (dec == 0) ? 1 : dec
    for i in 1:dec
        if nBase^i > dec
            return i
        end
    end
    return 0 # should never happen
end

getNumOfSlots2codeDec(12, 2)
getNumOfSlots2codeDec(12, 3)
getNumOfSlots2codeDec(12, 16)

function dec2baseN(dec::Int, n::Int)::Str
    @assert MIN_BASE <= n <= MAX_BASE "n not in [$MIN_BASE - $MAX_BASE]"
    @assert 0 <= dec <= 1024 "dec must be in range [0-1024]"
    result::Str = ""
    while dec != 0
        result *= CHARS[(dec % n) + 1]
        dec = div(dec, n)
    end
    return isempty(result) ? "0" : reverse(result)
end

# test against Julia's built-it  functionality
all([dec2baseN(i, b) == string(i, base=b)
     for b in 2:16 for i in 0:1024]
    )
