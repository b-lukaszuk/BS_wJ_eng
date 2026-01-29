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

function getLines(txt::Str, targetLineLen::Int=60)::Vec{Str}
    words::Vec{Str} = split(txt)
    lines::Vec{Str} = []
    curLine::Str = ""
    totalLineLen::Int = 0
    for word in words
        totalLineLen = length(curLine) + length(word)
        if totalLineLen < targetLineLen
            curLine *= word * " "
        end
        if totalLineLen == targetLineLen
            curLine *= word
        end
        if totalLineLen > targetLineLen
            push!(lines, strip(curLine))
            curLine = word * " "
        end
    end
    if strip(curLine) != ""
        push!(lines, strip(curLine))
    end
    return lines
end

function padLine(line::Str, pad::Char, lPadLen::Int, rPadLen::Int)::Str
    return pad ^ lPadLen * line * pad ^ rPadLen
end

function alignLeft(txt::Str, targetLineLen::Int=60)::Str
    @assert 40 <= targetLineLen <= 60 "lineLen must be in range [40-60]"
    lines::Vec{Str} = getLines(txt, targetLineLen)
    diffs::Vec{Int} = map(l -> targetLineLen - length(l), lines)
    lines = [padLine(l, ' ', 0, d) for (d, l) in zip(diffs, lines)]
    return join(lines, "\n")
end

function alignRight(txt::Str, targetLineLen::Int=60)::Str
    @assert 40 <= targetLineLen <= 60 "lineLen must be in range [40-60]"
    lines::Vec{Str} = getLines(txt, targetLineLen)
    diffs::Vec{Int} = map(l -> targetLineLen - length(l), lines)
    lines = [padLine(l, ' ', d, 0) for (d, l) in zip(diffs, lines)]
    return join(lines, "\n")
end

function center(txt::Str, targetLineLen::Int=60)::Str
    @assert 40 <= targetLineLen <= 60 "lineLen must be in range [40-60]"
    lines::Vec{Str} = getLines(txt, targetLineLen)
    diffs::Vec{Int} = map(l -> targetLineLen - length(l), lines)
    lDiffs::Vec{Int} = map(d -> div(d, 2), diffs)
    rDiffs::Vec{Int} = diffs .- lDiffs
    lines = [padLine(l, ' ', ld, rd) for (ld, rd, l) in zip(lDiffs, rDiffs, lines)]
    return join(lines, "\n")
end

txtFromFile = getTxtFromFile("./text2beFormatted.txt")
txtFromFile = getTxtFromFile("./test.txt")

alignLeft(txtFromFile) |> print
alignRight(txtFromFile) |> print
center(txtFromFile) |> print
