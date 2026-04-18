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
# (or maybe just let them pass through in 3rd D, like in: https://en.wikipedia.org/wiki/File:Brownian_motion_large.gif
const Flt = Float64
const Pos = Tuple{Int, Int} # position, (row, col) in 2D container
const Str = String
const Vec = Vector

const DELAY_SEC = 0.1
const MOLECULE = '.'
const N_COLS = 80
const N_CYCLES = 2_500
const N_MOLECULES = 100
const N_ROWS = 40

function printContainer(container::Matrix{Char})::Nothing
    nRows, _ = size(container)
    for r in 1:nRows
        println(container[r, :] |> join)
    end
    return nothing
end

function addBorders!(container::Matrix{Char})::Nothing
    container[:, 1] .= '|'
    container[:, N_COLS] .= '|'
    container[1, :] .= '—'
    container[N_ROWS, :] .= '—'
    return nothing
end

function isWithinContainer(molecule::Pos, container::Matrix{Char})::Bool
    nRows, nCols = size(container)
    row, col = molecule
    # corrected for borders
    return (1 < row <= nRows-1) && (1 < col <= nCols-1)
end

function clearContainer!(container::Matrix{Char})::Nothing
    for c in 1:N_COLS, r in 1:N_ROWS
        if isWithinContainer((r, c), container)
            container[r, c] = ' '
        end
    end
    return nothing
end

function rndPlaceMolecules!(molecules::Vec{Pos},
                            rowsMinMax::Tuple{Int, Int},
                            colsMinMax::Tuple{Int, Int},
                            nMolecules::Int=N_MOLECULES)::Nothing
    i::Int = 1
    r::Int, c::Int = 0, 0
    while i <= nMolecules
        r = rand(range(rowsMinMax...))
        c = rand(range(colsMinMax...))
        if !in((r, c), molecules)
            molecules[i] = (r, c)
            i += 1
        end
    end
    return nothing
end

function addMolecules!(molecules::Vec{Pos}, container!::Matrix{Char})::Nothing
    for molecule in molecules
        if isWithinContainer(molecule, container!)
            container![molecule...] = MOLECULE
        end
    end
    return nothing
end

roundFlt2int(f::Flt)::Int = round(Int, f)

function moveMolecule(molecule::Pos)::Pos
    r::Int = roundFlt2int(randn())
    c::Int = roundFlt2int(randn())
    return molecule .+ (r, c)
end

# assumption: molecules may pass through each other (or occupy the same pixel in 2D)
# since they move past each other in the third (not drawn) dimension
function moveBrownian!(molecules!::Vec{Pos}, container::Matrix{Char})::Nothing
    i::Int = 1
    newPos::Pos = (0, 0)
    while i <= N_MOLECULES
        newPos = moveMolecule(molecules![i])
        if isWithinContainer(newPos, container)
            molecules![i] = newPos
            i += 1
        end
    end
    return nothing
end

function clearLines(nLines::Int)::Nothing
    @assert 0 < nLines "nLines must be a positive integer"
    # "\033[xxxA" - xxx moves cursor up xxx LINES
    print("\033[" * string(nLines) * "A")
    # "\033[0J" - clears from cursor position till the end of the screen
    print("\033[0J")
    return nothing
end

getSnd((_, y)::Pos)::Int = y

function getCount(molecules::Vec{Pos})::Str
    cols::Vec{Int} = map(getSnd, molecules)
    midCol::Int = roundFlt2int(N_COLS/2)
    lCount::Int = sum(cols .<= midCol)
    rCount::Int = sum(cols .> midCol)
    return "Left count: $lCount | Right count: $rCount"
end

function redrawDisplay(container::Matrix{Char},
                       molecules::Vec{Pos},
                       nCycle::Int)::Nothing
    clearLines(N_ROWS+2)
    println("Cycle no: $nCycle/$N_CYCLES")
    println(getCount(molecules))
    printContainer(container)
    return nothing
end

function simulateBrownian!(nCycles::Int=N_CYCLES)::Nothing
    @assert 500 < nCycles < 1e5 "nCycles must be in range (500, 1e5)"
    container::Matrix{Char} = fill(' ', N_ROWS, N_COLS);
    addBorders!(container)
    molecules::Vec{Pos} = fill((0, 0), N_MOLECULES)
    rndPlaceMolecules!(molecules, (2, N_ROWS), (2, roundFlt2int(N_COLS/2)))
    addMolecules!(molecules, container)

    redrawDisplay(container, molecules, 0)

    for i in 1:nCycles
        moveBrownian!(molecules, container)
        clearContainer!(container)
        addMolecules!(molecules, container)
        sleep(DELAY_SEC)
        redrawDisplay(container, molecules, i)
    end
    return nothing
end

rnd2(x::Flt)::Flt = round(x, digits=2)

function main()::Nothing
    durationSec::Flt = DELAY_SEC * N_CYCLES
    durationMin::Flt = durationSec / 60

    println("\nThis is a (UNFINISHED) toy program that models simplified diffusion.")
    println("Note: your terminal must support ANSI escape codes.\n")

    # y(es) - default choice (also with Enter), anything else: no
    println("Estimated execution time of the program:")
    println("$(rnd2(durationSec)) seconds or $(rnd2(durationMin)) minutes.")
    println("\nContinue with the simulation? [Y/n]")
    choice::Str = readline()
    if lowercase(strip(choice)) in ["y", "yes", ""]
        simulateBrownian!()
    end

    println("\nThat's all. Goodbye!")

    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
