# the code in this file is meant to serve as a programming exercise only
# it may not act correctly
import Random as Rnd

const Str = String
const Vec = Vector

const PAD = " "
const MAX_LINE_LEN = 60

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

function getLines(txt::Str, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    words::Vec{Str} = split(txt)
    lines::Vec{Str} = []
    curLine::Str = ""
    difference::Int = 0
    for word in words
        difference = targetLineLen - length(curLine) - length(word)
        if difference >= 0
            curLine *= word * PAD
        else
            push!(lines, strip(curLine))
            curLine = word * PAD
        end
    end
    if strip(curLine) != ""
        push!(lines, strip(curLine))
    end
    return lines
end

function padLine(line::Str, lPaddingLen::Int, rPaddingLen::Int,
                 lPadding::Str=PAD, rPadding::Str=PAD)::Str
    @assert lPaddingLen >= 0 && rPaddingLen >= 0 "padding lengths must be >= 0"
    return lPadding ^ lPaddingLen * line * rPadding ^ rPaddingLen
end

function getLeftAlignedLines(txt::Str, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    @assert 40 <= targetLineLen <= 60 "lineLen must be in range [40-60]"
    lines::Vec{Str} = getLines(txt, targetLineLen)
    diffs::Vec{Int} = map(line -> targetLineLen - length(line), lines)
    return [padLine(l, 0, d) for (d, l) in zip(diffs, lines)]
end

function getRightAlignedLines(txt::Str, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    @assert 40 <= targetLineLen <= 60 "lineLen must be in range [40-60]"
    lines::Vec{Str} = getLines(txt, targetLineLen)
    diffs::Vec{Int} = map(line -> targetLineLen - length(line), lines)
    return [padLine(l, d, 0) for (d, l) in zip(diffs, lines)]
end

function getCenteredLines(txt::Str, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    @assert 40 <= targetLineLen <= 60 "lineLen must be in range [40-60]"
    lines::Vec{Str} = getLines(txt, targetLineLen)
    diffs::Vec{Int} = map(line -> targetLineLen - length(line), lines)
    lDiffs::Vec{Int} = map(d -> div(d, 2), diffs)
    rDiffs::Vec{Int} = diffs .- lDiffs
    return [padLine(l, ld, rd) for (ld, rd, l) in zip(lDiffs, rDiffs, lines)]
end

function intercalate(v1::Vec{Str}, v2::Vec{Str})::Str
    result::Str = ""
    for i in eachindex(v2)
        result *= v1[i] * v2[i]
    end
    return result * v1[end]
end

# returns random sample of v (without replacement) of length n
function getSample(v::Vec{A}, n::Int)::Vec{A} where A
    @assert 0 <= n <= length(v) "n must be in range [0-length(v)]"
    return Rnd.shuffle(v)[1:n]
end

function justifyLine(line::Str, targetLineLen::Int=MAX_LINE_LEN)::Str
    words::Vec{Str} = split(line)
    nSpacesBtwnWords::Int = length(words) - 1
    nSpacesTotal::Int = targetLineLen - sum(map(length, words))
    spaceBtwnWordsLen::Int = floor(Int,  nSpacesTotal / nSpacesBtwnWords)
    spaces::Vec{Str} = fill(PAD ^ spaceBtwnWordsLen, nSpacesBtwnWords)
    nExtraSpaces::Int = nSpacesTotal - nSpacesBtwnWords * spaceBtwnWordsLen
    spaces[getSample(collect(eachindex(spaces)), nExtraSpaces)] .*= PAD
    return intercalate(words, spaces)
end

function getJustifiedLines(txt::Str, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    @assert 40 <= targetLineLen <= 60 "lineLen must be in range [40-60]"
    lines::Vec{Str} = getLines(txt, targetLineLen)
    return map(line -> justifyLine(line, targetLineLen), lines)
end

function addBorder(lines::Vec{Str}, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    lMargin::Str = "|  "
    rMargin::Str = reverse(lMargin)
    padLen::Int = length(lMargin) + length(rMargin)
    result = map(line -> padLine(line, 1, 1, lMargin, rMargin), lines)
    pushfirst!(result, "-" ^ (targetLineLen + padLen))
    push!(result, "-" ^ (targetLineLen + padLen))
    return result
end

function printLines(lines::Vec{Str})
    join(lines, "\n") |> print
    return nothing
end

txtFromFile = getTxtFromFile("./text2beFormatted.txt")
txtFromFile = getTxtFromFile("./test.txt")

getLeftAlignedLines(txtFromFile) |> addBorder |> printLines
getRightAlignedLines(txtFromFile) |> addBorder |> printLines
getCenteredLines(txtFromFile) |> addBorder |> printLines
getJustifiedLines(txtFromFile) |> addBorder |> printLines
