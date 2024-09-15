# Matrix Multiplication

Latest update (local time): Sun 15 Sep 2024

## Problem

In Julia a
[matrix](https://b-lukaszuk.github.io/RJ_BS_eng/julia_language_variables.html#sec:julia_arrays)
is a tabular representation of numeric, two-dimensional (rows and columns)
data. We declare it with a friendly syntax (columns separated by spaces, rows
separated by semicolons).

```jl
s = """
A = [10.5 9.5; 8.5 7.5; 6.5 5.5]
A
"""
sco(s)
```

In mathematics by convention you denote matrices with a single capital
letter. However, since I'm not a mathematician then I'll use the, easier to
fingers, lowercase names here.

Anyway, here is the task. Read about matrix multiplication, e.g. on [Math is
Fun](https://www.mathsisfun.com/algebra/matrix-multiplying.html) or watch a
[Khan Academy's video](https://www.youtube.com/watch?v=OMA2Mwo0aZg) on it and
write a function with the following signature

```
multiply(m1::Matrix{Int}, m2::Matrix{Int})::Int
```

that for

```
a = [1 2 3; 4 5 6]
b = [7 8; 9 10; 11 12]
```

Should return the following matrix

```jl
s = """
[58 64; 139 154]
"""
sco(s)
```

Compare it against Julia's built-in `*` operator (on some matrices of your
choice) to ensure its correct functioning.

## Solution

It appears that in order to multiply two matrices we need to multiply each
element in a row from a matrix by each element in a column of another
matrix. Once we are done we sum the products. This is called a dot product. So,
let's start with that.

```jl
s = """
function getDotProduct(row::Vector{Int}, col::Vector{Int})
    @assert length(row) == length(col) "row & col must be of equal length"
    return map(*, row, col) |> sum
end
"""
sc(s)
```

First, we place a simple assumption check with the
[@assert](https://docs.julialang.org/en/v1/base/base/#Base.@assert). Then we
multiply each element of `row` by each element of `col` with `map`. `Map`
applies a function (its first argument) to every element of a collection (its
second argument), like so.

```jl
s = """
# adds 10 to each element of a vector
map(x -> x + 10, [1, 2, 3])
"""
sco(s)
```

Here we used a vector (`[1, 2, 3]`) and applied an anonymous function to each of
its elements. The function accepts one argument (`x`), adds 10 to it (`x + 10`)
and returns (`->`) that value. Interestingly, we may apply a function that
accepts two arguments and applies this function to parallel elements of two
vectors, like so

```jl
s = """
map((x, y) -> x * y, [1, 2, 3], [10, 100, 1000])
"""
sco(s)
```

Or since `*` is a syntactic sugar for `*(x, y)` we may simply place `*` alone.

```jl
s = """
map(*, [1, 2, 3], [10, 100, 1000])
"""
sco(s)
```

Since we calculate a dot product, then as an alternative (to live up to its
name) we could also use the [dot
operator](https://b-lukaszuk.github.io/RJ_BS_eng/julia_language_repetition.html#sec:julia_language_dot_functions)
syntax.

```jl
s = """
[1, 2, 3] .* [10, 100, 1000]
"""
sco(s)
```

Anyway, once we got the products vector we send it (`|>`) to `sum`.

Ok, time for multiplication itself.

```jl
s = """
function multiply(m1::Matrix{Int}, m2::Matrix{Int})::Matrix{Int}
    nRowsMat1, nColsMat1 = size(m1)
    nRowsMat2, nColsMat2 = size(m2)
    @assert  nColsMat1 == nRowsMat2 "the matrices are incompatible"
    result::Matrix{Int} = zeros(nRowsMat1, nColsMat2)
    for r in 1:nRowsMat1
        for c in 1:nColsMat2
            result[r, c] = getDotProduct(m1[r,:], m2[:, c])
        end
    end
    return result
end
"""
sc(s)
```

The above is a translation of the algorithm from the links provided in the task
description earlier on.  First we start by getting our matrices dimensions, and
performing a their compatibility check with `@assert`. Then we initialize an
empty matrix (`result`) with the appropriate dimensions (0s are placeholders for
its cells).  Finally, we get the dot products of every row (`for r`) in `m1` by
every column (`for c`) in `m2` and place them to the appropriate cells in the
`result` matrix.

Now, let's give it a swing.

```jl
s = """
# Math is Fun examples
a = [1 2 3; 4 5 6]
b = [7 8; 9 10; 11 12]
multiply(a, b)
"""
sco(s)
```

Looks good, and

```jl
s = """
# Khan Academy examples
c = [-1 3 5; 5 5 2]
d = [3 4; 3 -2; 4 -2]
multiply(c, d)
"""
sco(s)
```

Appears to be correct as well.

And now for a few tests against the build in `*` operator.

```jl
s = """
(a * b) == multiply(a, b)
(c * d) == multiply(c, d)
"""
sco(s)
```

We can't complain. It appears that we managed to solve this task in like 15
lines of code and without over-engineering it too much. It's all thanks to the
Julia's nice, terse syntax.
