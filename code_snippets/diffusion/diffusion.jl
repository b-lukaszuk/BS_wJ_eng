# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

# TODO: diffusion
# https://en.wikipedia.org/wiki/Diffusion
# https://en.wikipedia.org/wiki/Brownian_motion
# molecule shift
# new_pos = old_pos + sqrt(2nD⧋t)  * randn()
# where n - dimension, D - diffusion coefficient, t - time
# perhaps I should remove sqrt(2nD⧋t) to simplify it
# plus need collision detection

const Pos = Tuple{Int, Int} # position, (row, col) in canvas
const Vec = Vector

const N_COLS = 80
const N_ROWS = 40

# marix of chars
container = fill(' ', N_ROWS, N_COLS);

function printContainer(cvs::Matrix{Char}=container)::Nothing
    nRows, _ = size(cvs)
    for r in 1:nRows
        println(cvs[r, :] |> join)
    end
    return nothing
end

function clearContainer!(container::Matrix{Char}=container)::Nothing
    container .= ' '
    return nothing
end

function addBorders!(container::Matrix{Char}=container)::Nothing
    container[:, 1] .= '|'
    container[:, N_COLS] .= '|'
    container[1, :] .= '—'
    container[N_ROWS, :] .= '—'
    return nothing
end

addBorders!()
printContainer()
