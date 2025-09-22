const Vec = Vector
const Tup = Tuple

const RIGHT = (1, 0)
const DOWN = (0, -1)

# the code in this file is meant to serve as a programming exercise only
# and it may not act correctly

# https://projecteuler.net/problem=15
function add(position::Tup{Int, Int}, move::Tup{Int, Int})::Tup{Int, Int}
    return (position[1]+move[1], position[2]+move[2])
end

function add(positions::Vec{Tup{Int, Int}},
             moves::Vec{Tup{Int, Int}})::Vec{Tup{Int, Int}}
    result::Vec{Tup{Int, Int}} = []
    for p in positions
        for m in moves
            push!(result, add(p, m))
        end
    end
    return result
end

function getSums(nRows::Int=2)::Vec{Tup{Int, Int}}
    @assert 0 < nRows < 6 "nRows must be in the range [1-5]"
    sums::Vec{Tup{Int, Int}} = [(0, 0)]
    moves::Vec{Tup{Int, Int}} = [RIGHT, DOWN]
    for _ in 1:(nRows*2) # - *2 - because of columns
        sums = add(sums, moves)
    end
    return sums
end

function isEqlTarget(position::Tup{Int, Int},
                     target::Tup{Int, Int})::Bool
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

s = getSums(5)
filter(y -> isEqlTarget(y, (5, -5)), s) |> length
binomial(10, 5)

function makeOneStep(prevPaths::Vec{Vec{Tup{Int, Int}}})::Vec{Vec{Tup{Int, Int}}}
    @assert !isempty(prevPaths) "prevPaths cannot be empty"
    result::Vec{Vec{Tup{Int, Int}}} = []
    for path in prevPaths
        step1::Tup{Int, Int} = add(path[end], RIGHT)
        push!(result, [path..., step1])
        step2::Tup{Int, Int} = add(path[end], DOWN)
        push!(result, [path..., step2])
    end
    return result
end

function getPaths(nRows::Int=2)::Vec{Vec{Tup{Int, Int}}}
    @assert 0 < nRows < 6 "nRows must be in the range [1-5]"
    result::Vec{Vec{Tup{Int, Int}}} = [[(0, 0)]]
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
