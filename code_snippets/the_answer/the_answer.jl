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

# toInd0 and toInd1 assume correct inputs/outputs w/o checks
toIndBased0(oneBasedInd::Int)::Int = oneBasedInd - 1
toIndBased1(zeroBasedInd::Int)::Int = zeroBasedInd + 1

function dec2baseN(dec::Int, n::Int)::Str
    @assert MIN_BASE <= n <= MAX_BASE "n not in [$MIN_BASE - $MAX_BASE]"
    @assert 0 <= dec <= 1024 "dec must be in range [0-1024]"
    result::Str = ""
    while dec != 0
        result *= CHARS[(dec % n) |> toIndBased1]
        dec = div(dec, n)
    end
    return isempty(result) ? "0" : reverse(result)
end

# test against Julia's built-it  functionality
[dec2baseN(i, b) == string(i, base=b)
 for b in 2:16 for i in 0:1024] |> all

# returns (crried num, running num)
function add(num1::Char, num2::Char, numsBase::Int)::Tuple{Char, Char}
    @assert isBaseN(num1, numsBase) "$num1 is not a num of numsBase $numsBase"
    @assert isBaseN(num2, numsBase) "$num2 is not a num of numsBase $numsBase"
    @assert MIN_BASE <= numsBase <= MAX_BASE "$numsBase not in [$MIN_BASE - $MAX_BASE]"
    base0ind1::Int = findfirst(num1, join(CHARS)) |> toIndBased0
    base0ind2::Int = findfirst(num2, join(CHARS)) |> toIndBased0
    base0sumInds::Int = base0ind1 + base0ind2
    if base0sumInds >= numsBase
        carry::Char = '1'
        base0runningInd::Int = (base0sumInds % numsBase)
        return (carry, CHARS[base0runningInd |> toIndBased1])
    else
        return ('0', CHARS[base0sumInds |> toIndBased1])
    end
end

# tests
# with printout
for base in 2:16
    println("\n---base = $base---")
    for dec1 in 0:(base-1), dec2 in 0:(base-1)
        n1 = dec2baseN(dec1, base)[1]
        n2 = dec2baseN(dec2, base)[1]
        println("add($n1, $n2, base=$base) = ",
                "$(add(n1, n2, base)) = $(dec2baseN(dec1+dec2, base))")
    end
end

# without printout
tests = Bool[]
for base in 2:16
    for dec1 in 0:(base-1), dec2 in 0:(base-1) # dec - decimal
        num1 = dec2baseN(dec1, base)[1]
        num2 = dec2baseN(dec2, base)[1]
        result = join(add(num1, num2, base))
        result = result == "00" ? "0" : lstrip(result, '0')
        push!(tests, result == dec2baseN(dec1+dec2, base))
    end
end
all(tests)

function getEqlLenNums(num1::Str, num2::Str)::Tuple{Str, Str}
    if length(num1) >= length(num2)
        return (num1, lpad(num2, length(num1), '0'))
    else
        return getEqlLenNums(num2, num1)
    end
end

function isZero(num::Char)::Bool
    return num == '0'
end

function isZero(num::Str)::Bool
    return isZero.(collect(num)) |> all
end
