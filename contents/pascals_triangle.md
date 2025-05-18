# Pascal's triangle {#sec:pascals_triangle}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/pascals_triangle)
(without explanations).

## Problem {#sec:pascals_triangle_problem}

Imagine that you are a basketball coach in a local school. A basketball team is
composed of 5 players. Nine kids attends your classes. You would like the kids
to play in every possible configuration so that you could choose the best team
to represent the school next month. You wonder how many different teams of 5
players can you compose out of 9 candidates.

Such a question could be answered with the
[binomial](https://docs.julialang.org/en/v1/base/math/#Base.binomial) function
or [Pascal's triangle](https://en.wikipedia.org/wiki/Pascal%27s_triangle).

So here is a task for you, write a program that will display the Pascal's
triangle that will help you to answer the question mentioned above.

Compare its output with `binomial`.

The function can display a bare (right) triangle

```
[1]
[1, 1]
[1, 2, 1]
[1, 3, 3, 1]
```

or if you like challenges a slightly formatted output (it doesn't have to be
exact):

```
   1
  1 1
 1 2 1
1 3 3 1
    ∆
```

The above indicates how many pairs of 2 people out of 3 candidates can we get
(e.g in order to play doubles in tennis).

## Solution {#sec:pascals_triangle_solution}

If you read [the Wikipedia's description of the Pascal's
triangle](https://en.wikipedia.org/wiki/Pascal%27s_triangle) then you may have
noticed this cool animation (see below).

![Construction of Pascal's triangle. Source:
[Wikipedia](https://en.wikipedia.org/wiki/File:PascalTriangleAnimated2.gif)
(public domain, used in accordance with the Licensing
section).](https://upload.wikimedia.org/wikipedia/commons/0/0d/PascalTriangleAnimated2.gif){#fig:pascalsTriangle}

It indicates that in order to create a new row of the triangle you just take the
previous row and add pair of its elements together to create the next
row. Finally, at the edges of the new row you place 1s. So let's start by doing
just that.

```jl
s = """
function getSumOfPairs(prevRow::Vec{Int})::Vec{Int}
    @assert all(prevRow .> 0) "every element of prevRow must be > 0"
    return [a + b for (a, b) in zip(prevRow, prevRow[2:end])]
end

function getRow(prevRow::Vec{Int})::Vec{Int}
    @assert length(prevRow) > 1 "length(prevRow) must be > 1"
    sumsOfPairs::Vec{Int} = getSumOfPairs(prevRow)
    return [1, sumsOfPairs..., 1]
end
"""
sc(s)
```

The first function (`getSumOfPairs`) creates pairs of values based on the
previous row (`prevRow`). It returns a vector of tuples of `(a, b)` being
elements from the zipped vectors, e.g.

```jl
s = """
zip([1, 2, 3, 4], [2, 3, 4]) |> collect
"""
sco(s)
```

Notice, that the second argument to `zip` is its first element (`[1, 2, 3, 4]`)
with shift 1 (just like `prevRow[2:end]` in the body of `getSumOfPairs`) and
parallel elements are `zip`ped together as long as there are pairs. Next, the
numbers in a pair are added (`a + b`). `getRow` uses the `sumsOfPairs` and adds
1s on the edges. The `...` in `getRow` unpacks elements from a vector, i.e.
`[1, [3, 2]..., 1]` becomes `[1, 3, 2, 1]`. All in all, we got a pretty
faithful translation of the algorithm from @fig:pascalsTriangle to Julia.

Now we are ready to build the triangle row by row.

```jl
s = """
function getPascalTriangle(n::Int)::Vec{Vec{Int}}
    @assert 0 <= n <= 10 "n must be in range [0-10]"
    triangle::Dict{Int, Vec{Int}} = Dict(0 => [1], 1 => [1, 1])
    if !haskey(triangle, n)
        for row in 2:n
            triangle[row] = getRow(triangle[row-1])
        end
    end
    return [triangle[k] for k in 0:n]
end
"""
sc(s)
```

We define our triangle with initial two rows. Next, we move downwards through
the possible triangle rows (`for row in 2:n`) and build the next row based on
the previous one `getRow(triangle[row-1])`. All that's left to do is to return
the triangle as a vector of vectors (`Vec{Vec{Int}})`) which will give us a
right triangle on output. For instance, let's get the Pascal's triangle from
@fig:pascalsTriangle.

```jl
s = """
getPascalTriangle(4)
"""
sco(s)
```

Pretty neat, we could end here or try to add some text formatting.
