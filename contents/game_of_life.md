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
