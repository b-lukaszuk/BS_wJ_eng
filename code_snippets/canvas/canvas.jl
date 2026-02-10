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

function getWhiteBg(s::Str)::Str
    return "\x1b[107m" * s * "\x1b[0m"
end

function getRedBg(s::Str)::Str
    return "\x1b[41m" * s * "\x1b[0m"
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

function isOutsideGrid(pt::Pt, cvs::Matrix{Str}=canvas)::Bool
    nRows, nCols = size(cvs)
    x, y = pt
    return (x > nCols || x < 1) || (y > nRows || y < 1)
end

function isWithinGrid(pt::Pt, cvs::Matrix{Str}=canvas)::Bool
    return !isOutsideGrid(pt, cvs)
end

function isSamePt(pt1::Pt, pt2::Pt)::Bool
    return pt1 .- pt2 == (0, 0)
end

# colorFn(Str) -> Str, returns Str with ANSI code for color
function addPoints!(line::Vec{Pt},
                    colorFn::Function,
                    cvs::Matrix{Str}=canvas)::Nothing
    for pt in line
        if isWithinGrid(pt)
            cvs[pt...] = colorFn(" ")
        end
    end
    return nothing
end

function getRectangle(width::Int, height::Int)::Vec{Pt}
    @assert width >= 2 "width must be >= 2"
    @assert height >= 2 "height must be >= 2"
    nRects::Int = width * height
    rectangle::Vec{Pt} = Vec{Pt}(undef, nRects)
    i::Int = 1
    for row in 1:height, col in 1:width
        rectangle[i] = (row, col)
        i += 1
    end
    return rectangle
end

function getTriangle(height::Int)::Vec{Pt}
    @assert height > 1 "height must be > 1"
    startCol::Int = 10
    lCol::Int = startCol
    rCol::Int = startCol
    triangle::Vec{Pt} = []
    for row in 1:height
        for c in lCol:rCol
            push!(triangle, (row, c))
        end
        lCol -= 1
        rCol += 1
    end
    return triangle
end

clearCanvas!()
addPoints!(getRectangle(16, 8), getWhiteBg)
addPoints!(getTriangle(10), getRedBg)
printCanvas()
