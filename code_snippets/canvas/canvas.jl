# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Location = Tuple{Int, Int} # (row, col) in canvas
const Vec = Vector
const Str = String

const PIXEL = " " # empty string, because we set background color
const COORD_ORIGIN = (1, 1) # origin or the coordinate system (row, col)

# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
# "\x1b[48:5:XXXm" sets background color to XXX color code (256-color mode)
const BG_COLORS = Dict(
    :gray => "\x1b[48:5:8m",
    :white => "\x1b[48:5:15m",
    :red => "\x1b[48:5:160m",
    :yellow => "\x1b[48:5:11m",
    :blue => "\x1b[48:5:12m",
    :darkblue => "\x1b[48:5:20m",
    :green => "\x1b[48:5:35m",
    :black => "\x1b[48:5:0m",
    :brown => "\x1b[48:5:88m",
)

# "\x1b[0m" resets background color to default value
# default color: "\x1b[48:5:8m" - gray
function getBgColor(color::Symbol, colors::Dict{Symbol, Str}=BG_COLORS)::Str
    return get(colors, color, "\x1b[48:5:8m") * PIXEL * "\x1b[0m"
end

function printCanvas(cvs::Matrix{Str}=canvas)::Nothing
    nRows, _ = size(cvs)
    for r in 1:nRows
        println(cvs[r, :] |> join)
    end
    return nothing
end

function clearCanvas!(cvs::Matrix{Str}=canvas)::Nothing
    cvs .= getBgColor(:gray)
    return nothing
end

function isWithinCanvas(point::Location, cvs::Matrix{Str}=canvas)::Bool
    nRows, nCols = size(cvs)
    row, col = point
    return (0 < row <= nRows) && (0 < col <= nCols)
end

function addPoints!(line::Vec{Location}, color::Symbol, cvs::Matrix{Str}=canvas)::Nothing
    for pt in line
        if isWithinCanvas(pt)
            cvs[pt...] = getBgColor(color)
        end
    end
    return nothing
end

function nudge(shape::Vec{Location}, by::Location)::Vec{Location}
    return map(pt -> pt .+ by, shape)
end

function getRectangle(width::Int, height::Int)::Vec{Location}
    @assert width >= 2 "width must be >= 2"
    @assert height >= 2 "height must be >= 2"
    nRects::Int = width * height
    rectangle::Vec{Location} = Vec{Location}(undef, nRects)
    i::Int = 1
    for row in 1:height, col in 1:width
        rectangle[i] = (row, col)
        i += 1
    end
    return rectangle
end

function shift(figure::Vec{Location}, anchor::Location)::Vec{Location}
    shift::Location = anchor .- COORD_ORIGIN
    return nudge(figure, shift)
end

function getRectangle(width::Int, height::Int, topLeft::Location)::Vec{Location}
    return shift(getRectangle(width, height), topLeft)
end

function getTriangle(height::Int)::Vec{Location}
    @assert height > 1 "height must be > 1"
    _, c::Int = COORD_ORIGIN
    lCol::Int = c
    rCol::Int = c
    triangle::Vec{Location} = []
    for row in 1:height
        for c in lCol:rCol
            push!(triangle, (row, c))
        end
        lCol -= 1
        rCol += 1
    end
    return triangle
end

function getTriangle(height::Int, apex::Location)::Vec{Location}
    return shift(getTriangle(height), apex)
end

function getCircle(radius::Int)::Vec{Location}
    @assert radius > 1 "radius must be > 1"
    cols::Vec{Vec{Int}} = [collect((-1-r):(2+r)) for r in 0:(radius-1)]
    cols = [cols..., reverse(cols)...]
    triangle::Vec{Location} = []
    for row in 1:(radius*2)
        for col in cols[row]
            push!(triangle, (row, col))
        end
    end
    return triangle
end

function getCircle(radius::Int, topCenter::Location)::Vec{Location}
    return shift(getCircle(radius), topCenter)
end

canvas = fill(getBgColor(:gray), 30, 60) # top-left corner (1, 1)

clearCanvas!()
addPoints!(getRectangle(60, 15, (16, 1)), :green)
addPoints!(getRectangle(60, 15), :blue)
addPoints!(getRectangle(15, 8, (15, 21)), :white)
addPoints!(getRectangle(6, 6, (17, 28)), :brown)
addPoints!(getRectangle(4, 2, (16, 22)), :darkblue)
addPoints!(getRectangle(4, 6, (8, 31)), :black)
addPoints!(getTriangle(8, (7, 28)), :red)
addPoints!(getCircle(4, (2, 55)), :yellow)
addPoints!(getCircle(3, (4, 7)), :white)
addPoints!(getCircle(4, (4, 14)), :white)
addPoints!(getCircle(2, (2, 18)), :white)
printCanvas()
