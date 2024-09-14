# matrices are often named with a single capital letter
# convention from mathematics
A = [10.5 9.5; 8.5 7.5; 6.5 5.5]
A

# i'm not a mathematician though
# Math is Fun examples
a = [1 2 3; 4 5 6]
b = [7 8; 9 10; 11 12]

# Khan Academy examples
c = [0 3 5; 5 5 2]
d = [3 4; 3 -2; 4 -2]

function getDotProduct(row::Vector{Int}, col::Vector{Int})
    @assert length(row) == length(col)
    map(*, row, col) |> sum
end

function multiply(m1::Matrix{Int}, m2::Matrix{Int})::Matrix{Int}
    nRows1, nCols1 = size(m1)
    nRows2, nCols2 = size(m2)
    @assert  nCols1 == nRows2
    result::Matrix{Int} = zeros(nRows1, nCols2)
    for r in 1:nRows1
        for c in 1:nCols2
            result[r, c] = getDotProduct(m1[r,:], m2[:, c])
        end
    end
    return result
end

# visually testing the result of Math is Fun example
multiply(a, b)

# visually testing the result of Kahn Academy example
multiply(c, d)

# testing the result against the built in *
(a * b) == multiply(a, b)
(c * d) == multiply(c, d)
