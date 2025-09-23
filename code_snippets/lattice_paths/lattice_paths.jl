import CairoMakie as Cmk

const Vec = Vector

const Pos = Tuple{Int, Int}
const Path = Vec{Pos}

const RIGHT = (1, 0)
const DOWN = (0, -1)

# the code in this file is meant to serve as a programming exercise only
# and it may not act correctly

# https://projecteuler.net/problem=15
function add(position::Pos, move::Pos)::Pos
    return (position[1]+move[1], position[2]+move[2])
end

function add(positions::Vec{Pos},
             moves::Vec{Pos})::Vec{Pos}
    result::Vec{Pos} = []
    for p in positions
        for m in moves
            push!(result, add(p, m))
        end
    end
    return result
end

function getSums(nRows::Int=2)::Vec{Pos}
    @assert 0 < nRows < 5 "nRows must be in the range [1-4]"
    sums::Vec{Pos} = [(0, 0)]
    moves::Vec{Pos} = [RIGHT, DOWN]
    for _ in 1:(nRows*2) # - *2 - because of columns
        sums = add(sums, moves)
    end
    return sums
end

s = getSums(2)
filter(y -> y == (2, -2), s) |> length
binomial(4, 2)

s = getSums(3)
filter(y -> y == (3, -3), s) |> length
binomial(6, 3)

s = getSums(4)
filter(y -> y == (4, -4), s) |> length
binomial(8, 4)

function makeOneStep(prevPaths::Vec{Path})::Vec{Path}
    @assert !isempty(prevPaths) "prevPaths cannot be empty"
    result::Vec{Path} = []
    step1::Pos = (0, 0)
    step2::Pos = (0, 0)
    for path in prevPaths
        step1 = add(path[end], RIGHT)
        push!(result, [path..., step1])
        step2 = add(path[end], DOWN)
        push!(result, [path..., step2])
    end
    return result
end

function getPaths(nRows::Int=2)::Vec{Path}
    @assert 0 < nRows < 5 "nRows must be in the range [1-4]"
    result::Vec{Path} = [[(0, 0)]]
    for _ in 1:(nRows*2) # - *2 - because of columns
        result = makeOneStep(result)
    end
    return result
end

ps = getPaths(2)
ps = filter(v -> v[end] == (2, -2), ps)
binomial(4, 2)

ps = getPaths(3)
ps = filter(v -> v[end] == (3, -3), ps)
binomial(6, 3)

ps = getPaths(4)
ps = filter(v -> v[end] == (4, -4), ps)
binomial(8, 4)

function getDirection(p1::Pos, p2::Pos)::Pos
    return (p2[1]-p1[1], p2[2]-p1[2])
end

function getDirections(path::Vec{Tuple{Int, Int}})::Vec{Tuple{Int, Int}}
    directions::Vec{Tuple{Int, Int}} = []
    for (startPoint, endPoint) in zip(path, path[2:end])
        push!(directions, getDirection(startPoint, endPoint))
    end
    return directions
end

function addGrid!(ax::Cmk.Axis,
                  xmin::Int=0, xmax::Int=2,
                  xCuts::Vec{Int}=[0, 1, 2],
                  ymin::Int=0, ymax::Int=-2,
                  yCuts::Vec{Int}=[0, -1, -2])
    for yCut in yCuts
        Cmk.lines!(ax, [xmin, xmax], [yCut, yCut], color=:blue, linewidth=1)
    end
    for xCut in xCuts
        Cmk.lines!(ax, [xCut, xCut], [ymin, ymax], color=:blue, linewidth=1)
    end
    return nothing
end

function drawPaths(paths::Vec{Path},
                   xmin::Int, xmax::Int,
                   ymin::Int, ymax::Int,
                   nCols::Int)::Cmk.Figure
    fig::Cmk.Figure = Cmk.Figure(size=(800, 800))
    r::Int, c::Int = 1, 1
    xCuts::Vec{Int} = collect(xmin:xmax)
    yCuts::Vec{Int} = collect(ymin:ymax)
    for path in paths
        ax = Cmk.Axis(fig[r, c],
                      limits=(xmin-0.25, xmax+0.25, ymin-0.25, ymax+0.25),
                      aspect=1)
        Cmk.hidespines!(ax)
        Cmk.hidedecorations!(ax)
        directions::Path = getDirections(path)
        addGrid!(ax, xmin, xmax, xCuts, ymin, ymax, yCuts)
        Cmk.arrows2d!(ax, path[1:end-1], directions)
        if c == nCols
            r += 1
            c = 1
        else
            c += 1
        end
    end
    Cmk.rowgap!(fig.layout, -10)
    Cmk.colgap!(fig.layout, -10)
    return fig
end

ps = getPaths(2)
ps = filter(v -> v[end] == (2, -2), ps)
drawPaths(ps, 0, 2, -2, 0, 3)

ps = getPaths(3)
ps = filter(v -> v[end] == (3, -3), ps)
drawPaths(ps, 0, 3, -3, 0, 4)
