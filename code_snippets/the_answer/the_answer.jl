# TODO the_answer
# https://en.wikipedia.org/wiki/Phrases_from_The_Hitchhiker%27s_Guide_to_the_Galaxy#The_Answer_to_the_Ultimate_Question_of_Life,_the_Universe,_and_Everything_is_42

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Str = String

const CHARS = "0123456789abcdef" |> collect
const MIN_BASE = 2
const MAX_BASE = 16

function dec2baseN(dec::Int, n::Int)::Str
    @assert MIN_BASE <= n <= MAX_BASE "n not in [$MIN_BASE - $MAX_BASE]"
    @assert 0 <= dec <= 1024 "dec must be in range [0-1024]"
    result::Str = ""
    while dec != 0
        result *= CHARS[(dec % n) + 1] # d ec % n - 0 based C-like indexing
        dec = div(dec, n)
    end
    return isempty(result) ? "0" : reverse(result)
end

# test against Julia's built-it  functionality
[dec2baseN(i, b) == string(i, base=b)
 for b in MIN_BASE:MAX_BASE for i in 0:1024] |> all

for base in MIN_BASE:MAX_BASE
    for dec1 in 0:(base-1), dec2 in 0:(base-1)
        n1 = dec2baseN(dec1, base)
        n2 = dec2baseN(dec2, base)
        product = dec2baseN(dec1 * dec2, base)
        if product == "42"
            println("base $base: $n1 * $n2 = $product")
        end
    end
end
