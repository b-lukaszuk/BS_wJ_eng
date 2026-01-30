# the code in this file is meant to serve as a programming exercise only
# it may not act correctly
import Random as Rnd

const Str = String
const Vec = Vector

const PAD = " "

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
            curLine *= word * PAD
        end
        if totalLineLen == targetLineLen
            curLine *= word
        end
        if totalLineLen > targetLineLen
            push!(lines, strip(curLine))
            curLine = word * PAD
        end
    end
    if strip(curLine) != ""
        push!(lines, strip(curLine))
    end
    return lines
end

function padLine(line::Str, lPadding::Str, lPaddingLen::Int,
                 rPadding::Str, rPaddingLen::Int)::Str
    return lPadding ^ lPaddingLen * line * rPadding ^ rPaddingLen
end

function addBorder(lines::Vec{Str}, targetLineLen::Int=60)::Vec{Str}
    lMargin::Str = "|  "
    rMargin::Str = reverse(lMargin)
    padLen::Int = length(lMargin) + length(rMargin)
    result = map(l -> padLine(l, lMargin, 1, rMargin, 1), lines)
    pushfirst!(result, "-" ^ (targetLineLen + padLen))
    push!(result, "-" ^ (targetLineLen + padLen))
    return result
end

function alignLeft(txt::Str, targetLineLen::Int=60, border::Bool=true)::Str
    @assert 40 <= targetLineLen <= 60 "lineLen must be in range [40-60]"
    lines::Vec{Str} = getLines(txt, targetLineLen)
    diffs::Vec{Int} = map(l -> targetLineLen - length(l), lines)
    lines = [padLine(l, PAD, 0, PAD, d) for (d, l) in zip(diffs, lines)]
    if border
        lines = addBorder(lines)
    end
    return join(lines, "\n")
end

function alignRight(txt::Str, targetLineLen::Int=60, border::Bool=true)::Str
    @assert 40 <= targetLineLen <= 60 "lineLen must be in range [40-60]"
    lines::Vec{Str} = getLines(txt, targetLineLen)
    diffs::Vec{Int} = map(l -> targetLineLen - length(l), lines)
    lines = [padLine(l, PAD, d, PAD, 0) for (d, l) in zip(diffs, lines)]
    if border
        lines = addBorder(lines)
    end
    return join(lines, "\n")
end

function center(txt::Str, targetLineLen::Int=60, border::Bool=true)::Str
    @assert 40 <= targetLineLen <= 60 "lineLen must be in range [40-60]"
    lines::Vec{Str} = getLines(txt, targetLineLen)
    diffs::Vec{Int} = map(l -> targetLineLen - length(l), lines)
    lDiffs::Vec{Int} = map(d -> div(d, 2), diffs)
    rDiffs::Vec{Int} = diffs .- lDiffs
    lines = [padLine(l, PAD, ld, PAD, rd) for (ld, rd, l) in zip(lDiffs, rDiffs, lines)]
    if border
        lines = addBorder(lines)
    end
    return join(lines, "\n")
end

function intercalate(v1::Vec{Str}, v2::Vec{Str})::Str
    result::Str = ""
    for i in eachindex(v2)
        result *= v1[i] * v2[i]
    end
    return result * v1[end]
end

function justifyLine(line::Str, targetLineLen::Int=60)::Str
    words::Vec{Str} = split(line)
    nWords::Int = length(words)
    wordsLen::Int = map(length, words) |> sum
    allSepsLen::Int = targetLineLen - wordsLen
    nSpaces::Int = nWords - 1
    sepLen::Int = floor(Int,  allSepsLen / nSpaces)
    spaces::Vec{Str} = fill(" " ^ sepLen, nSpaces)
    nExtras::Int = allSepsLen - nSpaces * sepLen
    spaces[Rnd.shuffle(eachindex(spaces))[1:nExtras]] .*= " "
    result::Str = intercalate(words, spaces)
    return result
end

function justifyTxt(txt::Str, targetLineLen::Int=60, border::Bool=true)::Str
    @assert 40 <= targetLineLen <= 60 "lineLen must be in range [40-60]"
    lines::Vec{Str} = getLines(txt, targetLineLen)
    lines = map(l -> justifyLine(l, targetLineLen), lines)
    if border
        lines = addBorder(lines)
    end
    return join(lines, "\n")
end

txtFromFile = getTxtFromFile("./text2beFormatted.txt")
txtFromFile = getTxtFromFile("./test.txt")

alignLeft(txtFromFile) |> print
alignRight(txtFromFile) |> print
center(txtFromFile) |> print
justifyTxt(txtFromFile) |> print
