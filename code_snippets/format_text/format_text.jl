# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Str = String
const Vec = Vector


# https://docs.julialang.org/en/v1/base/io-network/#Base.IOStream
# https://docs.julialang.org/en/v1/base/io-network/#Base.open
function getTxtFromFile(filePath::Str)::Str
    fileTxt::Str = ""
    try
        fileTxt = open(filePath) do file
            read(file, Str)
        end
    catch
        fileTxt = "Couldn't read '$filePath', please make sure it exists."
    end
    return fileTxt
end

function alignLeft(txt::Str, lineLen::Int=60)::Str
    @assert 40 <= lineLen <= 60 "lineLen must be in range [40-60]"
    words::Vec{Str} = split(txt)
    result::Str = ""
    curLineLen::Int = 0
    wordLen::Int = 0
    for w in words
        wordLen = length(w)
        if (curLineLen + wordLen + 1) >= lineLen
            result *= '\n' * w
            curLineLen = wordLen
        else
            result *= ' ' * w
            curLineLen += wordLen + 1
        end
    end
    return result[2:end] # 1st char is ' '
end

txtFromFile = getTxtFromFile("./text2beFormatted.txt")
txtFromFile = getTxtFromFile("./test.txt")

alignLeft(txtFromFile) |> print
