# Matrix Multiplication

Latest update (local time): Fri 13 Sep 2024

## Problem

In Julia a matrix is a tabular representation of numeric, two-dimensional (rows
and columns) data. Read about matrix multiplication on
[Wikipedia](https://en.wikipedia.org/wiki/Matrix_multiplication#Matrix_times_matrix)
or maybe better watch a [Khan Academy's
video](https://www.youtube.com/watch?v=OMA2Mwo0aZg) on it and write a function
with the following signature

```julia
multiply(m1::Matrix{Int}, m2::Matrix{Int})::Int
```

Compare it against Julia's built-in `*` operator (e.g. `some_matrix *
other_matrix`) to ensure its correct functioning.
