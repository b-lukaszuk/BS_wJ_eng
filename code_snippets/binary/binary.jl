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
