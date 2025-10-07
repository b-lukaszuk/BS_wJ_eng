# Lattice Paths {#sec:lattice_paths}

In this chapter you may or may not use the following external libraries.

```jl
s24 = """
import CairoMakie as Cmk
"""
sc(s24)
```

You may compare your own solution with the one in this chapter (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/lattice_paths)
(without explanations).

## Problem {#sec:lattice_paths_problem}

The following exercise was inspired by [the following Euler
Project problem](https://projecteuler.net/problem=15), but modified by me.

Take a look at @fig:latticePaths2x2 below. You will find a big square build of
2x2 smaller squares. Your task is to start at the top left corner of the big
square and go to the bottom right corner of it using only right and down arrows
(as few as possible).

![Lattice paths on a 2x2 grid.](./images/latticePaths2x2.png){#fig:latticePaths2x2}

For the said problem there are exactly 6 paths (as depicted in
@fig:latticePaths2x2). But think about a big square composed of 3x3 little
squares.

How many different paths are there? Can you draw these paths? Well, use Julia to
find out.

## Solution {#sec:lattice_paths_solution}

[The lattice paths](https://projecteuler.net/problem=15) is actually a problem
from the field of [combinatorics](https://en.wikipedia.org/wiki/Combinatorics).
In our particular case (3x3 grid) it could be solved (number of paths
calculation) with a Pascal's triangle (covered in @sec:pascals_triangle) or the
build-in `binomial` function (`binomial(nRows+nCols, nRows)`). Since I'm not a
mathematician, then for a detailed explanation I refer you to [this Wikipedia's
entry](https://en.wikipedia.org/wiki/Lattice_path#Combinations_and_NE_lattice_paths).

Still, for practical reasons I like to use computer calculations to help me with
my understanding. Let's start small. First, analyze the pictures in
@fig:latticePaths1x1wCoordinates and @fig:latticePaths2x2wCoordinates.

> **_Note:_** The solution presented here is practical only fors small girds (up
> to 4x4 lattice, 70 paths to calculate and to draw). [The original
> problem](https://projecteuler.net/problem=15) (20x20 grid) got `binomial(40,
> 20)` = `jl binomial(40, 20)` possible routes between the top-left and
> bottom-right corner. That's far too many to calculate with the presented
> method and to draw in one figure.

![Lattice paths on a 1x1 grid in Cartesian coordinate system.](./images/latticePaths1x1wCoordinates.png){#fig:latticePaths1x1wCoordinates}

![Lattice paths on a 2x2 grid in Cartesian coordinate system.](./images/latticePaths2x2wCoordinates.png){#fig:latticePaths2x2wCoordinates}

A few points of notice (make sure they agree on @fig:latticePaths1x1wCoordinates
and @fig:latticePaths2x2wCoordinates):

1) the top left corner could be considered to be the center of our [Cartesian
coordinate system](https://en.wikipedia.org/wiki/Cartesian_coordinate_system)
with the location (0, 0);
2) the bottom right corner could be located within that system at position
(nRows, -nCols) of our grid (each small square in
@fig:latticePaths1x1wCoordinates and @fig:latticePaths2x2wCoordinates got side
length = 1 and builds rows and columns of a large square);
3) The number of arrows used to reach the destination is always the same for
each path and it is equal to nRows+nCols (or nRows*2);

Equipped with this knowledge, we can finally do something useful.

```
const Pos = Tuple{Int, Int}
const Mov = Tuple{Int, Int}

const RIGHT = (1, 0)
const DOWN = (0, -1)
const MOVES = [RIGHT, DOWN]

function add(position::Pos, move::Mov)::Pos
    return position .+ move
end

function add(positions::Vec{Pos}, moves::Vec{Mov}=MOVES)::Vec{Pos}
    @assert !isempty(positions) "positions cannot be empty"
    @assert !isempty(moves) "moves cannot be empty"
    result::Vec{Pos} = []
    for p in positions, m in moves
        push!(result, add(p, m))
    end
    return result
end
```

We begin by defining a few constants. The type synonyms: `Pos` (shortcut for
position), `Mov` (shortcut for move) will save us some typing later on.
Whereas, `RIGHT` (shift by 1 unit along X-axis) and `DOWN` (shift by 1 unit
along Y-axis) are the arrow coordinates in the Cartesian coordinate system,
which together form a vector of available `MOVES`.

Next, we define the `add` function. Its first version, aka method, allows to add
a position (like a starting point, top left corner (0, 0)) to a move (like the
move to the `RIGHT`). In some programming languages we would have to type
something like `return (position[1] + move[1], position[2] + move[2])` but in
Julia we just use a broadcasting operator `.+` to add the tuples
element-wise. The second version of `add` takes a vector of any starting
`positions` and any possible `moves` and adds each move to each starting
position (using simplified nested for loop syntax we met in
@sec:mat_multip_solution) to get the new positions (places on the grid) after
the moves.

Let's put the above functions to good use.

```
function getFinalPositions(nRows::Int)::Vec{Pos}
    @assert 0 < nRows < 5 "nRows must be in the range [1-4]"
    sums::Vec{Pos} = [(0, 0)]
    for _ in 1:(nRows*2) # - *2 - because of columns
        sums = add(sums, MOVES)
    end
    return sums
end

function getNumOfPaths(nRows::Int)::Int
    @assert 0 < nRows < 5 "nRows must be in the range [1-4]"
    target::Pos = (nRows, -nRows)
    positions::Vec{Pos} = getFinalPositions(nRows)
    return filter(x -> x == target, positions) |> length
end

getNumOfPaths(3) # the same result as: binomial(6, 3)
```

```
20
```

`getFinalPositions` accepts `nRows` which is the number of small squares in a
column of, e.g. @fig:latticePaths2x2wCoordinates. Next, it starts at the top
left corner (`sums::Vec{Pos} = [(0, 0)]`) and `moves` away from it. The number
of moves is equal to `nRows*2` (see point 3 in the points of notice above), and
we always go in both directions (`RIGHT` and `DOWN` which are in `moves`) thanks
to the previously defined `add` function. Finally, we return the final positions
(`return sums`) that we get after we made all the possible moves. Next, in
`getNumOfPaths`, we choose only those `positions` that land us in the bottom
right corner (`target`, see point 2 in the points of notice above) by using
`filter`. The `length` of our vector is the number of paths we were looking for.
