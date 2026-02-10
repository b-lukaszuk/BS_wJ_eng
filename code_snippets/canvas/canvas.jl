# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

# TODO
const Pt = Tuple{Int, Int} # (x, y)
const Vec = Vector
const Str = String

# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
# "\x1b[XXXm" sets background color to XXX color code
const BG_COLORS = Dict(
    :gray => "\x1b[100m",
    :white => "\x1b[107m",
    :red => "\x1b[41m",
    :yellow => "\x1b[43m",
    :blue => "\x1b[44m"
)

# "\x1b[0m" resets background color to default value
function getBgColor(s::Str, color::Symbol, colors::Dict{Symbol, Str}=BG_COLORS)::Str
    return get(colors, color, :gray) * s * "\x1b[0m"
end

canvas = fill(getBgColor(" ", :gray), 20, 40) # top-left corner (1, 1)

function printCanvas(cvs::Matrix{Str}=canvas)::Nothing
    nRows, _ = size(cvs)
    for r in 1:nRows
        println(cvs[r, :] |> join)
    end
    return nothing
end

function clearCanvas!(cvs::Matrix{Str}=canvas)::Nothing
    cvs .= getBgColor(" ", :gray)
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

function addPoints!(line::Vec{Pt}, color::Symbol, cvs::Matrix{Str}=canvas)::Nothing
    for pt in line
        if isWithinGrid(pt)
            cvs[pt...] = getBgColor(" ", color)
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

function getCircle(radius::Int)::Vec{Pt}
    @assert radius > 1 "radius must be > 1"
    cols::Vec{Vec{Int}} = [collect((9-r):(10+r)) for r in 0:(radius-1)]
    cols = [cols..., reverse(cols)...]
    triangle::Vec{Pt} = []
    for row in 1:(radius*2)
        for col in cols[row]
            push!(triangle, (row, col))
        end
    end
    return triangle
end

clearCanvas!()
addPoints!(getRectangle(16, 8), :white)
addPoints!(getTriangle(10), :red)
addPoints!(getCircle(2), :yellow)
addPoints!(getCircle(3), :yellow)
printCanvas()
