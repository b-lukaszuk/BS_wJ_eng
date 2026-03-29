# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Str = String

const CHARS = vcat('0':'9', 'a':'f')
const MIN_BASE = 2
const MAX_BASE = 16
const ADD_TBL = Dict{Int, Dict{Tuple{Char, Char}, Tuple{Char, Char}}}()
const MULT_TBL = Dict{Int, Dict{Tuple{Char, Char}, Tuple{Char, Char}}}()

for base in MIN_BASE:MAX_BASE
    ADD_TBL[base] = Dict()
    MULT_TBL[base] = Dict()
    for dec1 in 0:(base-1), dec2 in 0:(base-1) # 1 digit nums only
        n1 = string(dec1, base=base)[1]
        n2 = string(dec2, base=base)[1]
        sumOfNs = string(dec1 + dec2, base=base)
        prodOfNs = string(dec1 * dec2, base=base)
        s1, s2 = lpad(sumOfNs, 2, '0')
        p1, p2 = lpad(prodOfNs, 2, '0')
        ADD_TBL[base][(n1, n2)] = (s1, s2)
        MULT_TBL[base][(n1, n2)] = (p1, p2)
    end
end

# below modificated functions from ../binary/binary.jl

function isBaseN(num::Char, n::Int)::Bool
    @assert MIN_BASE <= n <= MAX_BASE "n not in [$MIN_BASE - $MAX_BASE]"
    return num in CHARS[1:n]
end

function isBaseN(num::Str, n::Int)::Bool
    return isBaseN.(collect(num), n) |> all
end

# returns (crried num, running num)
function add(num1::Char, num2::Char, base::Int)::Tuple{Char, Char}
    @assert isBaseN(num1, base) "$num1 is not a num of base $base"
    @assert isBaseN(num2, base) "$num2 is not a num of base $base"
    @assert MIN_BASE <= base <= MAX_BASE "$base not in [$MIN_BASE - $MAX_BASE]"
    return ADD_TBL[base][(num1, num2)]
end

function getEqlLenNums(num1::Str, num2::Str)::Tuple{Str, Str}
    if length(num1) >= length(num2)
        return (num1, lpad(num2, length(num1), '0'))
    else
        return getEqlLenNums(num2, num1) # OK for addition and multiplication
    end
end

function isZero(num::Char)::Bool
    return num == '0'
end

function isZero(num::Str)::Bool
    return isZero.(collect(num)) |> all
end

function add(num1::Str, num2::Str, baseNums::Int)::Str
    num1, num2 = getEqlLenNums(num1, num2)
    carriedSlot::Char = '0'
    runningSlot::Char = '0'
    runningSlots::Str = ""
    carriedSlots::Str = "0"
    for (n1, n2) in zip(reverse(num1), reverse(num2))
        carriedSlot, runningSlot = add(n1, n2, baseNums)
        runningSlots = runningSlot * runningSlots
        carriedSlots = carriedSlot * carriedSlots
    end
    if isZero(carriedSlots)
        return isZero(runningSlots) ? "0" : lstrip(isZero, runningSlots)
    else
        return add(runningSlots, carriedSlots, baseNums)
    end
end

# baseNFn(Str, Str, Int) -> Str, decFn(Int, Int) -> Int
function doesBaseNFnWork(dec1::Int, dec2::Int,
                       baseNFn::Function, baseN::Int,
                       decFn::Function)::Bool
    num1::Str = baseNFn(
        string(dec1, base=baseN), string(dec2, base=baseN), baseN)
    num2::Str = string(decFn(dec1, dec2), base=baseN)
    return num1 == num2
end

# running this test may take some time (513x513 matrix for each base system)
for base in MIN_BASE:MAX_BASE
    tests = [doesBaseNFnWork(a, b, add, base, +) for a in 0:512, b in 0:512];
    println("base $base, tests passed? ", all(tests))
end
