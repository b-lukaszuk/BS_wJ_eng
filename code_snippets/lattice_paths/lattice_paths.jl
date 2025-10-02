import CairoMakie as Cmk

const Vec = Vector
const Flt = Float64

const Pos = Tuple{Int, Int}
const Mov = Tuple{Int, Int}
const Path = Vector{Pos}

const RIGHT = (1, 0)
const DOWN = (0, -1)

# the code in this file is meant to serve as a programming exercise only
# and it may not act correctly

function add(position::Pos, move::Mov)::Pos
    return position .+ move
end

function add(positions::Vec{Pos}, moves::Vec{Mov})::Vec{Pos}
    @assert !isempty(positions) "positions cannot be empty"
    @assert !isempty(moves) "moves cannot be empty"
    result::Vec{Pos} = []
    for p in positions, m in moves
        push!(result, add(p, m))
    end
    return result
end

function getFinalPositions(nRows::Int)::Vec{Pos}
    @assert 0 < nRows < 5 "nRows must be in the range [1-4]"
    sums::Vec{Pos} = [(0, 0)]
    moves::Vec{Mov} = [RIGHT, DOWN]
    for _ in 1:(nRows*2) # - *2 - because of columns
        sums = add(sums, moves)
    end
    return sums
end

function getNumOfPaths(nRows::Int)::Int
    @assert 0 < nRows < 5 "nRows must be in the range [1-4]"
    target::Pos = (nRows, -nRows)
    positions::Vec{Pos} = getFinalPositions(nRows)
    return filter(x -> x == target, positions) |> length
end

getNumOfPaths.(1:4)
all([getNumOfPaths(i) == binomial(2*i, i) for i in 1:4])

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

function getPaths(nRows::Int)::Vec{Path}
    @assert 0 < nRows < 5 "nRows must be in the range [1-4]"
    result::Vec{Path} = [[(0, 0)]]
    for _ in 1:(nRows*2) # - *2 - because of columns
        result = makeOneStep(result)
    end
    return result
end

ps = getPaths(1)
ps = filter(v -> v[end] == (1, -1), ps)
binomial(2, 1)

ps = getPaths(2)
ps = filter(v -> v[end] == (2, -2), ps)
binomial(4, 2)

ps = getPaths(3)
ps = filter(v -> v[end] == (3, -3), ps)
binomial(6, 3)

ps = getPaths(4)
ps = filter(v -> v[end] == (4, -4), ps)
binomial(8, 4)

function getDirection(p1::Pos, p2::Pos)::Mov
    return p2 .- p1
end

function getDirections(path::Path)::Vec{Mov}
    directions::Vec{Mov} = []
    for i in eachindex(path)[1:end-1]
        push!(directions, getDirection(path[i], path[i+1]))
    end
    return directions
end

function addGrid!(ax::Cmk.Axis,
                  xmin::Int=0, xmax::Int=2, xCuts::Vec{Int}=[0, 1, 2],
                  ymin::Int=0, ymax::Int=-2, yCuts::Vec{Int}=[0, -1, -2])
    @assert xmin < xmax "xmin must be < xmax"
    @assert ymin < ymax "ymin must be < ymax"
    for yCut in yCuts
        Cmk.lines!(ax, [xmin, xmax], [yCut, yCut], color=:blue, linewidth=1)
    end
    for xCut in xCuts
        Cmk.lines!(ax, [xCut, xCut], [ymin, ymax], color=:blue, linewidth=1)
    end
    return nothing
end

function drawPaths(paths::Vec{Path}, xmin::Int, xmax::Int,
                   ymin::Int, ymax::Int, nCols::Int)::Cmk.Figure
    @assert length(paths) % nCols == 0 "nCols is not multiple of length(paths)"
    # fig::Cmk.Figure = Cmk.Figure(size=(1000, 800))
    fig::Cmk.Figure = Cmk.Figure()
    r::Int, c::Int = 1, 1
    xCuts::Vec{Int} = collect(xmin:xmax)
    yCuts::Vec{Int} = collect(ymin:ymax)
    sp::Flt = 0.5 # extra space for better outlook
    for path in paths
        ax = Cmk.Axis(fig[r, c],
                      limits=(xmin-sp, xmax+sp, ymin-sp, ymax+sp),
                      aspect=1)
        Cmk.hidespines!(ax)
        Cmk.hidedecorations!(ax)
        directions::Vec{Pos} = getDirections(path)
        addGrid!(ax, xmin, xmax, xCuts, ymin, ymax, yCuts)
        Cmk.arrows2d!(ax, path[1:end-1], directions)
        if c == nCols
            r += 1
            c = 1
        else
            c += 1
        end
    end
    # Cmk.rowgap!(fig.layout, Cmk.Fixed(1))
    # Cmk.colgap!(fig.layout, Cmk.Fixed(1))
    return fig
end

ps = getPaths(1)
ps = filter(v -> v[end] == (1, -1), ps)
drawPaths(ps, 0, 1, -1, 0, 2)

ps = getPaths(2)
ps = filter(v -> v[end] == (2, -2), ps)
drawPaths(ps, 0, 2, -2, 0, 3)

ps = getPaths(3)
ps = filter(v -> v[end] == (3, -3), ps)
drawPaths(ps, 0, 3, -3, 0, 4)
drawPaths(ps, 0, 3, -3, 0, 5)

ps = getPaths(4)
ps = filter(v -> v[end] == (4, -4), ps)
drawPaths(ps, 0, 4, -4, 0, 7)
drawPaths(ps, 0, 4, -4, 0, 10)
