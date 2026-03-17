# Sort {#sec:sort}

In this chapter I did not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/sort)
(without explanations).

## Problem {#sec:sort_problem}

The Julia's built-in
[sort](https://docs.julialang.org/en/v1/base/sort/#Base.sort) function is a
pretty useful beast. Let's try to replicate some of its functionality.

Read about different [sorting
algorithms](https://en.wikipedia.org/wiki/Sorting_algorithm#Comparison_of_algorithms)
and implement one or two of them. As a minimum requirement your sorting function/s
should correctly sort a vector of numbers (integers and floats), e.g.

```
yourSortFn([47, 15, 23, 99, 4])
```

Should return:

```
[4, 15, 23, 47, 99]
```

If you want to make it more challenging, try to sort the numbers from 1 to 10 in
alphabetical order, e.g.

```
yourSortFn([1, 11, 6], possibleOtherArgs)
```

should return:

```
[11, 1, 6]
```

Since "eleven" comes before "one" and before "six" ("e" < "o" < "s").

## Solution {#sec:sort_solution}

For our first choice we'll go with [bubble
sort](https://en.wikipedia.org/wiki/Bubble_sort) algorithm.

```jl
s = """
function bs(v::Vec{<:Union{Flt, Int}})::Vec{<:Union{Flt, Int}}
    result::Vec{<:Union{Flt, Int}} = copy(v)
    swapped::Bool = true
    while swapped
        swapped = false
        for i in eachindex(result)[2:end]
            if result[i-1] > result[i]
                result[i-1], result[i] = result[i], result[i-1]
                swapped = true
            end
        end
    end
    return result
end
"""
sco(s)
```

Here, we implemented the algorithm for vectors that contain elements of type
`Flt` (an alias for `Float64`) or `Int` (`Union{Flt, Int}`). We started, by
copying the original vector to `result` and setting a variable named
`swapped`. We will stop our sorting algorithm once there was no swap (`swapped`
in `while` is `false`) during the last traversal of the vector (`result`,
traversal in the `for` loop). We search through the vector starting from its
second element (`i in eachindex(result)[2:end]`). Every time we compare the two
nearby elements (`result[i-1]` vs. `result[i]`) If the elements aren't in a
desired order (`if result[i-1] > result[i]`) we just swap them with each other
(`result[i-1], result[i] = result[i], result[i-1]`) and set the `swapped` flag
to `true`. Once we finish we return the result.

Let's see how we did.

```jl
s = """
[47, 15, 23, 99, 4] |> bs,
[47.3, 23.2, 47.2] |> bs
"""
replace(sco(s), "(" => "(\n", ", [" => ",\n[", ")" => "\n)")
```
