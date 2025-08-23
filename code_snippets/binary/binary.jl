# TODO: the solution goes here

const Str = String

# built-ins
# decimal to binary
string(113, base=2)
# binary to decimal
parse(Int, string(113, base=2), base=2)


# fmt from overpayment, modified
function fmtBin(binNum::Str)::Str
    result::Str = ""
    counter::Int = 0
    padLen::Int = length(binNum) % 4
    padLen = padLen == 0 ? padLen : 4 - padLen
    for binDigit in reverse(binNum) # binDigit is a single binDigit (type Char)
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

for i in 0:1024
    if dec2bin(i) != string(i, base=2)
        print("failed for ", i)
        break;
    end
end
print("all tests passed")

tests = [dec2bin(i) == string(i, base=2) for i in 0:1024]
all(tests)
