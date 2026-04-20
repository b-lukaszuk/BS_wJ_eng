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
