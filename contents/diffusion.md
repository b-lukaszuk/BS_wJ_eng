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

At first `molecules` will be placed randomly within the `container`.

```jl
s = """
# assumption: molecules may pass through each other
# (or occupy the same pixel in 2D) since they move
# past each other in the third (not drawn) dimension
function placeMoleculesRandomly!(molecules::Vec{Pos},
                                 rowMin::Int, rowMax::Int,
                                 colMin::Int, colMax::Int)::Nothing
    @assert(isWithinContainer((rowMin, colMin)),
            "(rowMin, colMin) outside of container")
    @assert(isWithinContainer((rowMax, colMax)),
            "(rowMax, colMax) outside of container")
    r::Int, c::Int = 0, 0
    for i in eachindex(molecules)
        r = rand(rowMin:rowMax)
        c = rand(colMin:colMax)
        molecules[i] = (r, c)
    end
    return nothing
end

const MOLECULE = '.'

function addMolecules2container!(molecules::Vec{Pos},
                                 container!::Matrix{Char})::Nothing
    for molecule in molecules
        if isWithinContainer(molecule)
            container![molecule...] = MOLECULE
        end
    end
    return nothing
end
"""
sc(s)
```

Using `rowMin`/`rowMax`, `colMin`/`colMax` allows to place the molecules only in
some part of the matrix (per task specification it will be the left
side). Notice `!` character in `addMolecules2container!`. Per Julia's convention
it was added to the name of the function that modifies its contents. However,
both `molecules` (`Vec{Pos}`) and `container` (`Matrix{Char}`) are passed by
reference. So a question may arise which one of the two (or maybe both) will get
modified. To help with the answer the second parameter was named `container!` to
emphasize that only it will be modified by the function
(`placeMoleculesRandomly!` may modify only `molecules` so there is no need for
an extra `!` which might be confusing at first glance).

Each molecule does [Brownian motion](https://en.wikipedia.org/wiki/Brownian_motion):

> [...] a normal distribution with the mean $\mu = 0$ and variance $\sigma^{2} =
> 2Dt$ usually called Brownian motion $B_{t}$ [...]

Here, we are OK with all the molecules being identical (and sharing identical
properties). Therefore, for simplicity we'll just assume that `D = 0.5` and `t =
1`, hence `2Dt = 1`. This last action will give us normal distribution with mean
$\mu = 0$ and variance $\sigma^{2} = 1$ (standard deviation `sd` is also 1,
since $sd = \sqrt{variance}$). Luckily, that is what the built-in
[randn](https://docs.julialang.org/en/v1/stdlib/Random/#Base.randn) function
provides. Hence, we will calculate the new position of a molecule to be
`new_position = old_position + randn()` and implement it like so:

```jl
s = """
round2int(f::Flt)::Int = round(Int, f)

function getNewPosition(molecule::Pos)::Pos
    r::Int = round2int(randn())
    c::Int = round2int(randn())
    return molecule .+ (r, c)
end

# assumption: molecules may pass through each other
# (or occupy the same pixel in 2D) since they move
# past each other in the third (not drawn) dimension
function make1BrownianCycleShift!(molecules::Vec{Pos})::Nothing
    i::Int = 1
    newPos::Pos = (0, 0)
    while i <= N_MOLECULES
        newPos = getNewPosition(molecules[i])
        if isWithinContainer(newPos)
            molecules[i] = newPos
            i += 1
        end
    end
    return nothing
end
"""
sc(s)
```

The terminal display requires us to give a shift in integers, hence `round2int`
implemented as [single expression function
syntax](https://en.wikibooks.org/wiki/Introducing_Julia/Functions#Single_expression_functions).
Moreover, we cannot allow a particle to go outside the walls of the container,
thus the `if isWithinContainer(newPos), etc.` statement. It makes sure that the
molecule 'falls back' to the container. Effectively, it kind of simulates its
reflection from the walls of the vessel.
