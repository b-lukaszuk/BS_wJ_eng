# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

# TODO: game of life
# https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life

const N_COLS = 80
const N_ROWS = 40
const PROB_ALIVE = 0.25
const ALIVE_SYMBOL = 'O'
const DEAD_SYMBOL = '.'
const DELAY_MS = 500
const NUM_CYCLES = 50

const Str = String
const Universe = Matrix{Bool}

function getEmptyUniverse()::Universe
    return zeros(Bool, N_ROWS, N_COLS)
end

function getRandUniverse()::Universe
    return rand(Float64, N_ROWS, N_COLS) .<= PROB_ALIVE
end

function getFieldSymbol(field::Bool)::Char
    return field ? ALIVE_SYMBOL : DEAD_SYMBOL
end

function printUniverse(u::Universe, cycleNum::Int)::Nothing
    population::Int = sum(u)
    println("cycle: $cycleNum, population: $population")
    for r in 1:N_ROWS
        println(map(getFieldSymbol, u[r, :]) |> join)
    end
    return nothing
end

# https://en.wikipedia.org/wiki/ANSI_escape_code
function clearDisplay(nLinesUp::Int)::Nothing
    @assert 0 < nLinesUp "nLinesUp must be a positive integer"
    # "\033[xxxA" - xxx moves cursor up xxx LINES
    print("\033[" * string(nLinesUp) * "A")
    # "\033[0J" - clears from cursor position till the end of the screen
    print("\033[0J")
    return nothing
end

function reprintUniverse(u::Universe, cycleNum::Int)::Nothing
    clearDisplay(N_ROWS+1) # +1 cause info line
    printUniverse(u, cycleNum)
    return nothing
end

function isCellWithinRange(row::Int, col::Int)::Bool
    return (1 <= row <= N_ROWS) && (1 <= col <= N_COLS)
end

function getNumLiveNeighbours(universe::Universe, row::Int, col::Int)::Int
    if !isCellWithinRange(row, col)
        return 0
    end
    nAlive::Int = 0
    neighbourCol::Int, neighbourRow::Int = 0, 0
    for c in -1:1, r in -1:1
        neighbourRow, neighbourCol = row+r, col+c
        if !isCellWithinRange(neighbourRow, neighbourCol)
            continue
        end
        if (neighbourRow == row && neighbourCol == col)
            continue
        end
        if universe[neighbourRow, neighbourCol]
            nAlive += 1
        end
    end
    return nAlive
end

function shouldCellBeAlive(univere::Universe, row::Int, col::Int)::Bool
    nLiveNeighbours::Int = getNumLiveNeighbours(univere, row, col)
    if univere[row, col]
        return 2 <= nLiveNeighbours <= 3
    end
    return nLiveNeighbours == 3
end

function getUniverseNextState(univere::Universe)::Universe
    newUniverse::Universe = getEmptyUniverse()
    for c in 1:N_COLS, r in 1:N_ROWS
        newUniverse[r, c] = shouldCellBeAlive(univere, r, c)
    end
    return newUniverse
end

# early stop
function areAllCellsDead(univere::Universe)::Bool
    return sum(univere) == 0
end

function runGameOfLife()
    universe::Universe = getRandUniverse()
    printUniverse(universe, 0)
    for i in 1:NUM_CYCLES
        universe = getUniverseNextState(universe)
        reprintUniverse(universe, i)
        sleep(DELAY_MS / 1000)
        if areAllCellsDead(universe)
            println("All cells are dead.")
            break
        end
    end
end

function main()
    println("\nThis is a toy program, it displays a so called game of life.")
    println("Note: your terminal must support ANSI escape codes.\n")

    println("The game will run through $NUM_CYCLES cycles.")
    println("WARNING: the screen may flicker (Ctrl-C should abort the program).")

    # y(es) - default choice (also with Enter), anything else: no
    println("\nContinue with the game? [Y/n]")
    choice::Str = readline()
    if lowercase(strip(choice)) in ["y", "yes", ""]
        runGameOfLife()
    end

    println("\nThat's all. Goodbye!")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
