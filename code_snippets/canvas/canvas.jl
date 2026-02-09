# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

# TODO
const Pt = Tuple{Int, Int} # (x, y)
const Vec = Vector
const Str = String

# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
function getGrayBg(s::Str)::Str
    # "\x1b[100m" sets background color to gray
    # "\x1b[0m" resets background color to default value
    return "\x1b[100m" * s * "\x1b[0m"
end

canvas = fill(getGrayBg(" "), 20, 40) # top-left corner (1, 1)

function printCanvas(cvs::Matrix{Str}=canvas)::Nothing
    nRows, _ = size(cvs)
    for r in 1:nRows
        println(cvs[r, :] |> join)
    end
    return nothing
end

function clearCanvas!(cvs::Matrix{Str}=canvas)::Nothing
    cvs .= getGrayBg(" ")
    return nothing
end

printCanvas()

function isOutsideGrid(pt::Pt, cvs::Matrix{Char}=canvas)::Bool
    nRows, nCols = size(cvs)
    x, y = pt
    return (x > nCols || x < 1) || (y > nRows || y < 1)
end

function isWithinGrid(pt::Pt, cvs::Matrix{Char}=canvas)::Bool
    return !isOutsideGrid(pt, cvs)
end

function isSamePt(pt1::Pt, pt2::Pt)::Bool
    return pt1 .- pt2 == (0, 0)
end

function getHorizontalLine(pt1::Pt, pt2::Pt)::Vec{Pt}
    x1, y1 = pt1
    x2, y2 = pt2
    @assert y1 == y2 "the ys are not equal"
    return [(i, y1) for i in x1:x2]
end

function getVerticalLine(pt1::Pt, pt2::Pt)::Vec{Pt}
    x1, y1 = pt1
    x2, y2 = pt2
    @assert x1 == x2 "the xs are not equal"
    return [(x1, i) for i in y1:y2]
end

function addPoints!(line::Vec{Pt}, cvs::Matrix{Char}=canvas)
    for pt in line
        col, row = pt
        cvs[row, col] = '*'
    end
    return nothing
end

function getRectangle(topLeft::Pt, width::Int, height::Int)::Vec{Pt}
    @assert width >= 2 "width must be >= 2"
    @assert height >= 2 "height must be >= 2"
    x::Int, y::Int = topLeft
    rectangle::Vec{Pt} = [
        getHorizontalLine(topLeft, (x+width, y))...,
        getVerticalLine(topLeft, (x, y+height))...,
        getHorizontalLine((x, y+height), (x+width, y+height) )...,
        getVerticalLine((x+width, y), (x+width, y+height))...
    ]
    return rectangle
end
