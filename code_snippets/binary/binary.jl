const Str = String

# the code in this file is meant to serve as a programming exercise only
# and it may not act correctly

function isBin(bin::Char)::Bool
    return bin in ['0', '1']
end

function isBin(bin::Str)::Bool
    return isBin.(collect(bin)) |> all
end

# fmt from overpayment.jl, modified
function fmtBin(bin::Str)::Str
    @assert isBin(bin) "bin is not a binary number"
    result::Str = ""
    counter::Int = 0
    padLen::Int = length(bin) % 4
    padLen = padLen == 0 ? padLen : 4 - padLen
    for binDigit in reverse(bin) # binDigit is a single digit (type Char)
        if counter == 4
            result = " " * result
            counter = 0
        end
        result = binDigit * result
        counter += 1
    end
    return "0" ^ padLen * result
end

string(15, base=2) |> fmtBin
string(113, base=2) |> fmtBin

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

tests = [dec2bin(i) == string(i, base=2) for i in 0:1024]
# or
tests = map(x -> dec2bin(x) == string(x, base=2), 0:1024)
all(tests)
# or just
dec2bin.(0:1024) == string.(0:1024, base=2)

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

tests = [bin2dec(string(i, base=2)) == i for i in 0:1024]
# or
tests = map(x -> bin2dec(string(x, base=2)) == x, 0:1024)
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

binSum1 = ""
binSum2 = ""
for a in 0:512, b in 0:512
    binSum1 = add(dec2bin(a), dec2bin(b))
    binSum2 = dec2bin(a+b)
    binSum1, binSum2 = getEqlLenBins(binSum1, binSum2)
    if binSum1 != binSum1
        println("Operation failed for ", a, " and ", b)
    end
end
