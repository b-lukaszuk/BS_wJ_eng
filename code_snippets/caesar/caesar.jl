const Str = String

# rotBy >= 0 - returns (alphabet, rotatedAlphabet)
# rotBy < 0 - returns (rotatedAlphabet, alphabet)
function getAlphabets(rotBy::Int, upper::Bool)::Tuple{Str, Str}
    alphabet::Str = upper ? join('A':'Z') : join('a':'z')
    rot::Int = abs(rotBy) % length(alphabet)
    rotAlphabet::Str = alphabet[(rot+1):end] * alphabet[1:rot]
    return rotBy < 0 ? (rotAlphabet, alphabet) : (alphabet, rotAlphabet)
end

function codeChar(c::Char, rotBy::Int)::Char
    outerDisc::Str, innerDisc::Str = getAlphabets(rotBy, isuppercase(c))
    ind::Union{Int, Nothing} = findfirst(c, outerDisc)
    return isnothing(ind) ? c : innerDisc[ind]
end

# rotBy > 0 - encrypting, rotBy < 0 - decrypting, rotBy = 0 - same msg
function codeMsg(msg::Str, rotBy::Int)::Str
    coderFn(c::Char)::Char = codeChar(c, rotBy)
    return map(coderFn, msg)
end

# mini-tests
codeMsg("JULIA :)", 0)
codeMsg("JULIA :)", 0) == codeMsg("JULIA :)", 26)

codeMsg("AAA :)", 1)
codeMsg("AAA :)", 1) == codeMsg("AAA :)", 26+1) == codeMsg("AAA :)", 26*2+1)
codeMsg("aaa :)", 25)

codeMsg("JULIA :)", 2)
codeMsg("Julia :)", 2)
codeMsg("Julia :)", 2) |> txt -> codeMsg(txt, -2)

# decoding trarfvf.txt
codedTxt = open("./trarfvf.txt") do file # the file is roughly 31 KiB
    read(file, Str)
end

decodedTxt = codeMsg(codedTxt, -13)
first(decodedTxt, 54)
codeMsg("trarfvf", -13)
