# Matrix Multiplication

Latest update (local time): Fri 13 Sep 2024

## Problem

In Julia a matrix is a tabular representation of numeric, two-dimensional (rows
and columns) data. Read about matrix multiplication, e.g. on [Math is
Fun](https://www.mathsisfun.com/algebra/matrix-multiplying.html) or watch a
[Khan Academy's video](https://www.youtube.com/watch?v=OMA2Mwo0aZg) on it and
write a function with the following signature

```julia
multiply(m1::Matrix{Int}, m2::Matrix{Int})::Int
```

that for

```julia
m1 = [1 2 3; 4 5 6]
m2 = [7 8; 9 10; 11 12]
```

Should return the following matrix

```julia
[58 64; 139 154]
```

Compare it against Julia's built-in `*` operator (on some random matrices) to
ensure its correct functioning.
