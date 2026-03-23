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

function dec2baseN(dec::Int, n::Int)::Str
    @assert MIN_BASE <= n <= MAX_BASE "n not in [$MIN_BASE - $MAX_BASE]"
    @assert 0 <= dec <= 1024 "dec must be in range [0-1024]"
    result::Str = ""
    while dec != 0
        result *= CHARS[(dec % n) + 1] # 0 based to 1 based
        dec = div(dec, n)
    end
    return isempty(result) ? "0" : reverse(result)
end

# test against Julia's built-it  functionality
[dec2baseN(i, b) == string(i, base=b)
 for b in 2:16 for i in 0:1024] |> all

# returns (carried num, running num)
function add(x::Char, y::Char, base::Int)::Tuple{Char, Char}
    @assert isBaseN(x, base) "$x is not a num of base $base"
    @assert isBaseN(y, base) "$y is not a num of base $base"
    @assert MIN_BASE <= base <= MAX_BASE "$base not in [$MIN_BASE - $MAX_BASE]"
    ind1::Int = findfirst(x, CHARS |> join) - 1 # 0 based
    ind2::Int = findfirst(y, CHARS |> join) - 1 # 0 based
    sumInd::Int = ind1 + ind2 # 0 based
    if sumInd >= base
        carry::Char = '1'
        runningInd::Int = (sumInd % base) + 1 # 1 based
        return (carry, CHARS[runningInd])
    else
        return ('0', CHARS[sumInd+1]) # 1 based
    end
end

# tests
# with printout
for b in 2:16
    println("\n---base = $b---")
    for x in 0:(b-1), y in 0:(b-1)
        n1 = dec2baseN(x, b)[1]
        n2 = dec2baseN(y, b)[1]
        println("add($n1, $n2, base=$b) = $(add(n1, n2, b)) = $(dec2baseN(x+y, b))")
    end
end

# without printout
tests = Bool[]
for b in 2:16 # base
    for x in 0:(b-1), y in 0:(b-1) # nums
        n1 = dec2baseN(x, b)[1]
        n2 = dec2baseN(y, b)[1]
        result = join(add(n1, n2, b))
        result = result == "00" ? "0" : lstrip(result, '0')
        push!(tests, result == dec2baseN(x+y, b))
    end
end
all(tests)
