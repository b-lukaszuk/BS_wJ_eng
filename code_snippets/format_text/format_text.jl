# the code in this file is meant to serve as a programming exercise only
# it may not act correctly
import Random as Rnd

const Str = String
const Vec = Vector

const COL_SEP = "     "
const MAX_LINE_LEN = 60
const PAD = " "

function getLines(txt::Str, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    @assert 20 <= targetLineLen <= 60 "lineLen must be in range [20-60]"
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

function getLenDiffs(lines::Vec{Str}, targetLineLen::Int=MAX_LINE_LEN)::Vec{Int}
    return targetLineLen .- map(length, lines)
end

function padLine(line::Str, lPaddingLen::Int, rPaddingLen::Int,
                 lPadding::Str=PAD, rPadding::Str=PAD)::Str
    @assert(lPaddingLen >= 0 && rPaddingLen >= 0,
            "padding lengths must be >= 0")
    return lPadding ^ lPaddingLen * line * rPadding ^ rPaddingLen
end

function getPaddedLines(lines::Vec{Str},
                         lPadsLens::Vec{Int}, rPadsLens::Vec{Int})::Vec{Str}
    @assert(length(lines) == length(lPadsLens) == length(rPadsLens),
            "all vectors must be of equal lengths")
    return map(padLine, lines, lPadsLens, rPadsLens)
end

function getLeftAlignedLines(txt::Str, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    lines::Vec{Str} = getLines(txt, targetLineLen)
    diffs::Vec{Int} = getLenDiffs(lines, targetLineLen)
    return getPaddedLines(lines, zeros(Int, length(lines)), diffs)
end

function getRightAlignedLines(txt::Str, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    lines::Vec{Str} = getLines(txt, targetLineLen)
    diffs::Vec{Int} = getLenDiffs(lines, targetLineLen)
    return getPaddedLines(lines, diffs, zeros(Int, length(lines)))
end

function getCenteredLines(txt::Str, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    lines::Vec{Str} = getLines(txt, targetLineLen)
    diffs::Vec{Int} = getLenDiffs(lines, targetLineLen)
    lDiffs::Vec{Int} = map(d -> div(d, 2), diffs)
    rDiffs::Vec{Int} = diffs .- lDiffs
    return getPaddedLines(lines, lDiffs, rDiffs)
end

function intercalate(v1::Vec{Str}, v2::Vec{Str})::Str
    @assert length(v1) > length(v2) "length(v1) must be > length(v2)"
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

function justifyLine(line::Str,
                     lastLine::Bool=false, targetLineLen::Int=MAX_LINE_LEN)::Str
    words::Vec{Str} = split(line)
    if  length(words) < 2 || lastLine
        return rpad(line, targetLineLen, PAD)
    end
    nSpacesBtwnWords::Int = length(words) - 1
    nSpacesTotal::Int = targetLineLen - sum(map(length, words))
    spaceBtwnWordsLen::Int = floor(Int,  nSpacesTotal / nSpacesBtwnWords)
    spaces::Vec{Str} = fill(PAD ^ spaceBtwnWordsLen, nSpacesBtwnWords)
    nExtraSpaces::Int = nSpacesTotal - nSpacesBtwnWords * spaceBtwnWordsLen
    spaces[getSample(collect(eachindex(spaces)), nExtraSpaces)] .*= PAD
    return intercalate(words, spaces)
end

function getJustifiedLines(txt::Str, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    lines::Vec{Str} = getLines(txt, targetLineLen)
    return map(line -> justifyLine(line, line == lines[end], targetLineLen), lines)
end

function connectColumns(lines1::Vec{Str}, lines2::Vec{Str})::Vec{Str}
    @assert length(lines1) >= length(lines2) "lines1 must have >= chars than line2"
    result::Vec{Str} = []
    emptyColPad = rpad(" ", length(lines1[1]))
    for i in eachindex(lines1)
        push!(result,
              string(lines1[i], COL_SEP, get(lines2, i, emptyColPad))
              )
    end
    return result
end

function getDoubleColumn(txt::Str, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    @assert 20 <= targetLineLen <= 60 "lineLen must be in range [20-60]"
    lines::Vec{Str} = getJustifiedLines(txt, div(targetLineLen, 2) - 5)
    midPoint::Int = ceil(Int, length(lines)/2)
    return connectColumns(lines[1:midPoint], lines[(midPoint+1):end])
end

function addBorder(lines::Vec{Str})::Vec{Str}
    lMargin::Str = "|  "
    rMargin::Str = reverse(lMargin)
    padLen::Int = length(lMargin) + length(rMargin)
    totalLen::Int = length(lines[1]) + padLen
    result = map(line -> padLine(line, 1, 1, lMargin, rMargin), lines)
    pushfirst!(result, "-" ^ totalLen)
    push!(result, "-" ^ totalLen)
    return result
end

function printLines(lines::Vec{Str})
    join(lines, "\n") |> print
    return nothing
end

###############################################################################
#                               minimal testing                               #
###############################################################################
# text from file
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
txtFromFile = getTxtFromFile("./text2beFormatted.txt")

# with border
getLeftAlignedLines(txtFromFile) |> addBorder |> printLines
getRightAlignedLines(txtFromFile) |> addBorder |> printLines
getCenteredLines(txtFromFile) |> addBorder |> printLines
getJustifiedLines(txtFromFile) |> addBorder |> printLines
getDoubleColumn(txtFromFile) |> addBorder |> printLines

# without border
getLeftAlignedLines(txtFromFile) |> printLines
getRightAlignedLines(txtFromFile) |> printLines
getCenteredLines(txtFromFile) |> printLines
getJustifiedLines(txtFromFile) |> printLines
getDoubleColumn(txtFromFile) |> printLines

lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat.  Duis aute irure dolor in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

# with border
getLeftAlignedLines(lorem) |> addBorder |> printLines
getRightAlignedLines(lorem) |> addBorder |> printLines
getCenteredLines(lorem) |> addBorder |> printLines
getJustifiedLines(lorem) |> addBorder |> printLines
getDoubleColumn(lorem) |> addBorder |> printLines

# without border
getLeftAlignedLines(lorem) |> printLines
getRightAlignedLines(lorem) |> printLines
getCenteredLines(lorem) |> printLines
getJustifiedLines(lorem) |> printLines
getDoubleColumn(lorem) |> printLines
