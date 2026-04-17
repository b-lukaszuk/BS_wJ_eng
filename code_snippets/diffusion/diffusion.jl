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
const N_MOLECULES = 30
const MOLECULE = '.'

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

molecules = fill((0, 0), N_MOLECULES)

function rndPlaceMolecules!(molecules::Vec{Pos}=molecules,
                            nMolecules::Int=N_MOLECULES)::Nothing
    i::Int = 1
    r::Int = 0
    c::Int = 0
    while i <= nMolecules
        r = rand(2:N_ROWS-1)
        c = rand(2:N_COLS-1)
        if !in((r, c), molecules)
            molecules[i] = (r, c)
            i += 1
        end
    end
    return nothing
end

function isWithinContainer(molecule::Pos, container::Matrix{Char}=container)::Bool
    nRows, nCols = size(container)
    row, col = molecule
    return (0 < row <= nRows) && (0 < col <= nCols)
end

function addMolecules!(molecules=Vec{Pos}, container::Matrix{Char}=container)::Nothing
    for molecule in molecules
        if isWithinContainer(molecule, container)
            container[molecule...] = '.'
        end
    end
    return nothing
end

rndPlaceMolecules!()
addMolecules!(molecules)
printContainer()
