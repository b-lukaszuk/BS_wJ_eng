# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

# TODO: game of life
# https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life

const WIDTH = 80
const HEIGHT = 15
const PROB_ALIVE = 0.25
const ALIVE_SYMBOL = "O"
const DEAD_SYMBOL = "."

const Universe = Matrix{Bool}

function getEmptyUniverse()::Universe
    return zeros(Bool, HEIGHT, WIDTH)
end

function getRandUniverse()::Universe
    return rand(Float64, HEIGHT, WIDTH) .<= PROB_ALIVE
end

function getFieldSymbol(field::Bool)::String
    return field ? ALIVE_SYMBOL : DEAD_SYMBOL
end

function printUniverse(u::Universe, cycleNum::Int)
    population::Int = sum(u)
    for r in 1:HEIGHT
        println(map(getFieldSymbol, u[r, :]) |> join)
    end
    println("cycle: $cycleNum, population: $population")
end
