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
my understanding. Let's start small, first, analyze the pictures in
@fig:latticePaths1x1 and the previously depicted @fig:latticePaths2x2.

> **_Note:_** The solution presented here is practical only up to 4x4 lattice
> (70 paths to calculate and to draw). [The original
> problem](https://projecteuler.net/problem=15) (20x20 grid) got `binomial(40,
> 20)` = `jl binomial(40, 20)` possible routes between the top-left and
> bottom-right corner. That's far too many to calculate with the presented
> method and to draw in one figure.

![Lattice paths on a 1x1 grid in Cartesian coordinate system.](./images/latticePaths1x1.png){#fig:latticePaths1x1}

A few points of notice (make sure they agree on @fig:latticePaths2x2 and
@fig:latticePaths1x1):

1) the top left corner could be considered to be the center of our [Cartesian
coordinate system](https://en.wikipedia.org/wiki/Cartesian_coordinate_system)
with the location (0, 0);
2) the bottom right corner could be located within that system at position
(nRows, -nCols) of our grid (each small square in @fig:latticePaths2x2 got side
length = 1);
3) The number of arrows used to reach the destination is always the same for
each path and it is equal to nRows+nCols (or nRows*2);

Equipped with this knowledge, we can finally do something useful.
