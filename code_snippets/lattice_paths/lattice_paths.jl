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

function isEqlTarget(position::Pos, target::Pos)::Bool
    return position == target
end

s = getSums(2)
filter(y -> isEqlTarget(y, (2, -2)), s) |> length
binomial(4, 2)

s = getSums(3)
filter(y -> isEqlTarget(y, (3, -3)), s) |> length
binomial(6, 3)

s = getSums(4)
filter(y -> isEqlTarget(y, (4, -4)), s) |> length
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
