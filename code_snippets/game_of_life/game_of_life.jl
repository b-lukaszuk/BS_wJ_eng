# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

# TODO: game of life
# https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life

const N_COLS = 80
const N_ROWS = 40
const PROB_ALIVE = 0.25
const ALIVE_SYMBOL = '#'
const DEAD_SYMBOL = '.'

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
    neighbourRow::Int, neighbourCol::Int = 0, 0
    for r in -1:1, c in -1:1
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
    for r in 1:N_ROWS, c in 1:N_COLS
        newUniverse[r, c] = shouldCellBeAlive(univere, r, c)
    end
    return newUniverse
end

function areAllCellsDead(univere::Universe)::Bool
    return sum(univere) == 0
end
