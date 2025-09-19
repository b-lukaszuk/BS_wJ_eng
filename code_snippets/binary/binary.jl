const Str = String
const Vec = Vector

# the code in this file is meant to serve as a programming exercise only
# and it may not act correctly

function getNumOfBits2codeDec(dec::Int)::Int
    @assert 0 <= dec <= 1024 "dec must be in range [0-1024]"
    dec = (dec == 0) ? 1 : dec
    for i in 1:dec
        if 2^i > dec
            return i
        end
    end
    return 0 # should never happen
end

# or
function getNumOfBits2codeDec(dec::Int)::Int
    @assert 0 <= dec <= 1024 "dec must be in range [0-1024]"
    twoPwr::Int = (dec < 2) ? 1 : ceil(Int, log2(dec))
    return (2^twoPwr > dec) ? twoPwr : twoPwr+1
end

function dec2bin(dec::Int)::Str
    @assert 0 <= dec <= 1024 "dec must be in range [0-1024]"
    nBits::Int = getNumOfBits2codeDec(dec)
    result::Vec{Char} = fill('0', nBits)
    bitDec::Int = 2^(nBits-1)
    for i in eachindex(result)
        if bitDec <= dec
            result[i] = '1'
            dec -= bitDec
        end
        bitDec = (bitDec < 2) ? 0 : bitDec/2
    end
    return join(result)
end

# or
function dec2bin(dec::Int)::Str
    @assert 0 <= dec <= 1024 "dec must be in range [0-1024]"
    rest::Int = dec
    result::Str = dec == 0 ? "0" : ""
    while dec != 0
        dec, rest = divrem(dec, 2)
        result *= string(rest)
    end
    return reverse(result)
end

tests = [dec2bin(i) == string(i, base=2) for i in 0:1024];
all(tests)
# or
tests = map(x -> dec2bin(x) == string(x, base=2), 0:1024);
all(tests)
# or just
dec2bin.(0:1024) == string.(0:1024, base=2)

function isBin(bin::Char)::Bool
    return bin in ['0', '1']
end

function isBin(bin::Str)::Bool
    return isBin.(collect(bin)) |> all
end

function bin2dec(bin::Str)::Int
    @assert isBin(bin) "bin is not a binary number"
    pwr::Int = length(bin) - 1
    result::Int = 0
    for b in bin
        result += b == '1' ? 2^pwr : 0
        pwr -= 1
    end
    return result
end

tests = [bin2dec(string(i, base=2)) == i for i in 0:1024];
# or
tests = map(x -> bin2dec(string(x, base=2)) == x, 0:1024);
all(tests)
# or just
bin2dec.(string.(0:1024, base=2)) == 0:1024

function add(bin1::Char, bin2::Char)::Tuple{Char, Char}
    @assert isBin(bin1) && isBin(bin2) "both inputs must be binary bits"
    if bin1 == '1' && bin2 == '1'
        return ('1', '0')
    elseif bin1 == '0' && bin2 == '0'
        return ('0', '0')
    else
        return ('0', '1')
    end
end

function getEqlLenBins(bin1::Str, bin2::Str)::Tuple{Str, Str}
    if length(bin1) >= length(bin2)
        return (bin1, lpad(bin2, length(bin1), "0"))
    else
        return getEqlLenBins(bin2, bin1)
    end
end

function isZero(bin::Char)::Bool
    return bin == '0'
end

function isZero(bin::Str)::Bool
    return isZero.(collect(bin)) |> all
end

function add(bin1::Str, bin2::Str)::Str
    @assert isBin(bin1) && isBin(bin2) "both inputs must be binary numbers"
    bin1, bin2 = getEqlLenBins(bin1, bin2)
    cb::Char = '0' # carry bit
    rb::Char = '0' # running bit, or right bit
    runningBits::Str = ""
    carryBits::Str = "0"
    for (b1, b2) in zip(reverse(bin1), reverse(bin2))
        cb, rb = add(b1, b2)
        runningBits = rb * runningBits
        carryBits = cb * carryBits
    end
    if isZero(carryBits)
        return runningBits
    else
        return add(runningBits, carryBits)
    end
end

# binFn(Str, Str) -> Str, decFn(Int, Int) -> Int
function doesBinFnWork(n1::Int, n2::Int,
                       binFn::Function, decFn::Function)::Bool
    bin1::Str = binFn(dec2bin(n1), dec2bin(n2))
    bin2::Str = string(decFn(n1, n2), base=2)
    bin1, bin2 = getEqlLenBins(bin1, bin2)
    return bin1 == bin2
end

# running this test may take a few seconds (513x513 matrix)
tests = [doesBinFnWork(a, b, add, +) for a in 0:512, b in 0:512];
all(tests)

function multiply(bin1::Char, bin2::Char)::Char
    @assert isBin(bin1) && isBin(bin2) "both inputs must be binary bits"
    if bin1 == '1' && bin2 == '1'
        return '1'
    else
        return '0'
    end
end

function multiply(bin1::Str, bin2::Str)::Str
    @assert isBin(bin1) && isBin(bin2) "both inputs must be binary numbers"
    total::Str = "0"
    curProd::Str = "1"
    zerosToPad::Int = 0
    for b in reverse(bin2)
        curProd = multiply.(b, collect(bin1)) |> join
        total = add(total, curProd * "0"^zerosToPad)
        zerosToPad += 1
    end
    return total
end

# 33x33 matrix
tests = [doesBinFnWork(a, b, multiply, *) for a in 0:32, b in 0:32];
all(tests)
