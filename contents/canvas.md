# Canvas {#sec:canvas}

In this chapter I did not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/canvas)
(without explanations).

## Problem {#sec:canvas_problem}

Create a simple pixel-art
[terminal](https://en.wikipedia.org/wiki/Terminal_emulator) graphics. You may,
e.g. draw a house on a meadow, similar to the one below.

![Sample pixel-art terminal graphics made with Julia.](./images/canvas.png){#fig:canvas}

## Solution {#sec:canvas_solution}

The first question we must answer is how to represent our `canvas`. Here, we'll
go with a matrix of strings which we will tint by placing space characters (`"
"`) on a background colored with [ANSI escape
codes](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors).

```
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

canvas = fill(getBgColor(:gray), 30, 60) # top-left corner (1, 1)
```

Next, we need a way to properly display canvas (`printCanvas`) and to clear it
(`clearCanvas!`) which will allow us to erase an incorrect drawing and try
again.

```
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
```

Now, to draw @fig:canvas we will need a few shapes, most likely: a rectangle, a
triangle and an oval/circle. A shape will be represented as coordinates (row and
column) of our matrix that need to be dyed with a specific color. Let's start
with a rectangle as this should be the easiest shape to obtain.

```
function getRectangle(width::Int, height::Int)::Vec{Pos}
    @assert width >= 2 "width must be >= 2"
    @assert height >= 2 "height must be >= 2"
    nRects::Int = width * height
    rectangle::Vec{Pos} = Vec{Pos}(undef, nRects)
    i::Int = 1
    startX::Int, startY::Int = COORD_ORIGIN
    for row in startX:height, col in startY:width
        rectangle[i] = (row, col)
        i += 1
    end
    return rectangle
end
```

Each `rectangle` is represented as a vector of positions (`Vec{Pos}`). It will
start at the origin of our coordinate system (`COORD_ORIGIN` - top left corner
of our matrix) and go through as many `row`s as its `height` is
(`startX:height`) and as many `col`umns as its width is (`startY:width`).
