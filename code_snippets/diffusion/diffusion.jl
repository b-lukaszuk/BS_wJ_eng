# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

# TODO: diffusion
# https://en.wikipedia.org/wiki/Diffusion

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
