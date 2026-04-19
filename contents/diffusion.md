# Diffusion {#sec:diffusion}

In this chapter I did not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/diffusion)
(without explanations).

## Problem {#sec:diffusion_problem}

This time your job is to write a simplified
[diffusion](https://en.wikipedia.org/wiki/Diffusion) simulator. It may or may
not be a terminal app.

For that purpose create a container (let's say 40x80) and fill its left half
with let's say 150 molecules (like in @fig:diffusionFirstFrame) that are sped by
[Brownian motion](https://en.wikipedia.org/wiki/Brownian_motion). See if the
diffusion works, by comparing initial distribution of particles with the
distribution after a few thousand cycles.

> **_WARNING:_** While running the program in terminal the screen may
> flicker. If that's a problem (you will feel unwell) then you may skip this
> exercise. Remember that you should be able to abort the program (terminal
> application) at any time by pressing Ctrl-C.

![Simplified diffusion simulation (initial frame).](./images/diffusionFirstFrame.png){#fig:diffusionFirstFrame}

## Solution {#sec:diffusion_solution}

Let's start with the container and its functionality.

```jl
s = """
N_COLS = 80
N_ROWS = 40

function addBorders!(container::Matrix{Char})::Nothing
    container[:, 1] .= '|'
    container[:, N_COLS] .= '|'
    container[1, :] .= '-'
    container[N_ROWS, :] .= '-'
    return nothing
end

function getEmptyContainer()::Matrix{Char}
    container::Matrix{Char} = fill(' ', N_ROWS, N_COLS);
    addBorders!(container)
    return container
end

function printContainer(container::Matrix{Char})::Nothing
    for r in 1:N_ROWS
        println(container[r, :] |> join)
    end
    return nothing
end

function clearDisplay(nLinesUp::Int)::Nothing
    @assert 0 < nLinesUp "nLinesUp must be a positive integer"
    # "\\033[xxxA" - xxx moves cursor up xxx LINES
    print("\\033[" * string(nLinesUp) * "A")
    # "\\033[0J" - clears from cursor position till the end of the screen
    print("\\033[0J")
    return nothing
end
"""
replace(sc(s), "N_COLS" => "const N_COLS", "N_ROWS" => "const N_ROWS")
```

The `container` is just a `Matrix` (a table) of characters (`Chars`) that's
constrained by the borders (`|` and `-`) and initially contains nothing inside
(`fill(' ', N_ROWS, N_COLS)`).

The container will contain `molecules` inside. The above will be defined as a
vector of positions denoting their locations (row and column) within the matrix
(our `container`).

```jl
s = """
Pos = Tuple{Int, Int} # position (row, col) in 2D container

function isWithinContainer(molecule::Pos)::Bool
    row, col = molecule
    # accounts for borders
    return (1 < row < N_ROWS) && (1 < col < N_COLS)
end
"""
replace(sc(s), "Pos =" => "const Pos =")
```
