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

const Pos = Tuple{Int, Int} # position, (row, col) in 2D container
const Str = String
const Vec = Vector

const N_COLS = 80
const N_ROWS = 40
const N_MOLECULES = 30
const MOLECULE = '.'

function printContainer(container::Matrix{Char})::Nothing
    nRows, _ = size(container)
    for r in 1:nRows
        println(container[r, :] |> join)
    end
    return nothing
end

function clearContainer!(container::Matrix{Char})::Nothing
    container .= ' '
    return nothing
end

function addBorders!(container::Matrix{Char})::Nothing
    container[:, 1] .= '|'
    container[:, N_COLS] .= '|'
    container[1, :] .= '—'
    container[N_ROWS, :] .= '—'
    return nothing
end

function rndPlaceMolecules!(molecules::Vec{Pos},
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

function isWithinContainer(molecule::Pos, container::Matrix{Char})::Bool
    nRows, nCols = size(container)
    row, col = molecule
    return (0 < row <= nRows) && (0 < col <= nCols)
end

function addMolecules!(molecules::Vec{Pos}, container!::Matrix{Char})::Nothing
    for molecule in molecules
        if isWithinContainer(molecule, container!)
            container![molecule...] = MOLECULE
        end
    end
    return nothing
end

function main()::Nothing
    println("\nThis is a (UNFINISHED) toy program that models simplified diffusion.")
    println("Note: your terminal must support ANSI escape codes.\n")

    # y(es) - default choice (also with Enter), anything else: no
    println("Continue with the simulation? [Y/n]")
    choice::Str = readline()
    if lowercase(strip(choice)) in ["y", "yes", ""]

        container::Matrix{Char} = fill(' ', N_ROWS, N_COLS);
        molecules::Vec{Pos} = fill((0, 0), N_MOLECULES)

        addBorders!(container)
        rndPlaceMolecules!(molecules)
        addMolecules!(molecules, container)
        printContainer(container)
    end

    println("\nThat's all. Goodbye!")

    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
