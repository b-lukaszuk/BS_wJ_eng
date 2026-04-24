# Game of Life {#sec:game_of_life}

In this chapter I did not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/game_of_life)
(without explanations).

## Problem {#sec:game_of_life_problem}

Let's finish with another classic. This time your job is to implement [Conway's
Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) with a
finite two dimensional grid called the universe. Each cell on the grid
got some initial probability (let's say [0.2-0.5]) of being alive. Per the Wikipedia's
description the next state of the universe is calculated as follows:

> 1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
> 2. Any live cell with two or three live neighbours lives on to the next generation.
> 3. Any live cell with more than three live neighbours dies, as if by overpopulation.
> 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

The end result may look something like @fig:gameOfLife.

![A frame from the Conway's Game of Life.](./images/gameOfLife.png){#fig:gameOfLife}

> **_WARNING:_** While running the program in terminal the screen may
> flicker. If that's a problem (you may feel unwell) then you can skip this
> exercise. Remember that you should be able to abort the program (terminal
> application) at any time by pressing Ctrl-C.

## Solution {#sec:game_of_life_solution}

Let's start with our universe.


```jl
s = """
N_COLS = 80
N_ROWS = 40
PROB_ALIVE = 0.25

Universe = Matrix{Bool}

function getEmptyUniverse()::Universe
    return zeros(Bool, N_ROWS, N_COLS)
end

function getRandUniverse()::Universe
	# rand gives val [0-1) and not [0-1] like prob, but it will do
    return rand(Float64, N_ROWS, N_COLS) .<= PROB_ALIVE
end
"""
replace(sc(s), "N_COLS =" => "const N_COLS =", "N_ROWS =" => "const N_ROWS =",
	"PROB_ALIVE =" => "const PROB_ALIVE =", "Universe =" => "const Universe =")
```

For that we define a few `const`ants, the `Universe` data type, which is a
synonym for a `Matrix` (`N_ROWS`x`N_COLS`) of `Bool`s. This is a natural choice
since each cell can be either alive (with the probability of `0.25`) or dead.

Next, time for printing.

```jl
s = """
ALIVE_SYMBOL = 'O'
DEAD_SYMBOL = '.'
N_GENERATIONS = 50

function getFieldSymbol(field::Bool)::Char
    return field ? ALIVE_SYMBOL : DEAD_SYMBOL
end

function printUniverse(universe::Universe, nGeneration::Int)::Nothing
    population::Int = sum(universe)
    print("Generation: \$nGeneration/\$N_GENERATIONS, ")
	println("population: \$population\\n")
    for r in 1:N_ROWS
        println(map(getFieldSymbol, universe[r, :]) |> join)
    end
    return nothing
end

# https://en.wikipedia.org/wiki/ANSI_escape_code
function clearDisplay(nLinesUp::Int)::Nothing
    @assert 0 < nLinesUp "nLinesUp must be a positive integer"
    # "\\033[xxxA" - xxx moves cursor up xxx LINES
    print("\\033[" * string(nLinesUp) * "A")
    # "\\033[0J" - clears from cursor position till the end of the screen
    print("\\033[0J")
    return nothing
end

function reprintUniverse(universe::Universe, nGeneration::Int)::Nothing
    clearDisplay(N_ROWS+2) # +2 cause info line and newline
    printUniverse(universe, nGeneration)
    return nothing
end
"""
replace(sc(s), "ALIVE_SYMBOL =" => "const ALIVE_SYMBOL =",
	"DEAD_SYMBOL =" => "const DEAD_SYMBOL =",
	"N_GENERATIONS =" => "const N_GENERATIONS =")
```

The above (printing and reprinting) is basically a modified code from
@sec:diffusion_solution. Of note, here we do not draw the borders, instead we
use dead (`DEAD_SYMBOL`) and live (`ALIVE_SYMBOL`) cells.

Time to determine the next state of our `universe`. But first, per task
specification, we need to know to number of a cell neighbors that are alive.

```jl
s = """
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
"""
sc(s)
```

We assign this task to `getNumLiveNeighbours` that accepts our `universe` and the
cell of interest coordinates (`row` and `col`) as its parameters. The
neighbors of a cell are located in a row below, the same row as the cell, and a
row above the cell's own row (`r in -1:1`). Similarly, we look for a column on
the left, the same column as the cell, and a column to the right of the cell's
own column (`c in -1:1`). Hence, a neighbor coordinates are calculated as
`neighbourRow = row+r` (`row` is the cell's own row, `r` is the row shift) and
`neighbourCol = col+c` (`col` is the cell's own column, `c` is the column
shift). We examine all the possible neighbor locations with the `for` loop. If
the coordinates fall outside the grid (`!isCellWithinRange` - the cell does
exist in our `universe`) then we `continue` to the next iteration (we examine
next coordinates). The same goes for examining the coordinates of the cell
itself (since both `r` and `c` may be equal 0). Otherwise, if a neighbor is
alive (`if universe[neighbourRow, neighbourCol]`) we add 1 to the count (`nAlive
+= 1`), which we eventually `return` from the function.
