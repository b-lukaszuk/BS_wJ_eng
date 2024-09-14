# Matrix Multiplication

Latest update (local time): Sat 14 Sep 2024

## Problem

In Julia a
[matrix](https://b-lukaszuk.github.io/RJ_BS_eng/julia_language_variables.html#sec:julia_arrays)
is a tabular representation of numeric, two-dimensional (rows and columns)
data. We declare it with a friendly syntax (columns separated by spaces, rows
separated by semicolons).

```julia
A = [10.5 9.5; 8.5 7.5; 6.5 5.5]
A
```

In mathematics by convention you denote matrices with a single capital letter. However, since I'm not a mathematician then I use the, easier to fingers, lowercase names here.

Read about matrix multiplication, e.g. on [Math is
Fun](https://www.mathsisfun.com/algebra/matrix-multiplying.html) or watch a
[Khan Academy's video](https://www.youtube.com/watch?v=OMA2Mwo0aZg) on it and
write a function with the following signature

```julia
multiply(m1::Matrix{Int}, m2::Matrix{Int})::Int
```

that for

```julia
a = [1 2 3; 4 5 6]
b = [7 8; 9 10; 11 12]
```

Should return the following matrix

```julia
[58 64; 139 154]
```

Compare it against Julia's built-in `*` operator (on some matrices of your
choice) to ensure its correct functioning.
