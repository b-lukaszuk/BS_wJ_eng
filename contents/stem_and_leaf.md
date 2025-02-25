# Stem and Leaf Plot {#sec:stem_and_leaf}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/stem_and_leaf)
(without explanations).

## Problem {#sec:stem_and_leaf_problem}

In statistics a useful technique used to visualize the distribution of data is
[histogram](https://en.wikipedia.org/wiki/Histogram). A bit less popular,
although easier to implement with text display is [stem and leaf
plot](https://en.wikipedia.org/wiki/Stem-and-leaf_display).

So here is a task for you:

- read the Wikipedia's description of how the plot is constructed
- write the function that displays stem and leaf plot for positive integers
  (e.g. in the range 0 to 110, since wider number span doesn't look well on
  printout)
- extend it to work also with the range -110 to 110
- extend it to work also with floats in the range -110.9 to 110.9

As a minimal test, make sure it works correctly on the examples from the
[Wikipedia's web page](https://en.wikipedia.org/wiki/Stem-and-leaf_display), i.e


```jl
s = """
stemLeafTest1 = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37,
                41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
stemLeafTest2 = [44, 46, 47, 49, 63, 64, 66, 68, 68, 72, 72, 75,
                76, 81, 84, 88, 106]
stemLeafTest3 = [-23.678758, -12.45, -3.4, 4.43, 5.5, 5.678,
                16.87, 24.7, 56.8]
"""
sc(s)
```

## Solution {#sec:stem_and_leaf_solution}

Let's start with a function that takes a vector of integers and returns the
number of characters in the greatest number.

```jl
s = """
function getMaxLengthOfNum(nums::Vec{Int})::Int
    maxLen::Int = map(length ∘ string, nums) |> maximum
    return maxLen == 1 ? maxLen + 1 : maxLen
end
"""
sc(s)
```

To that end we used a [function composition
operator](https://docs.julialang.org/en/v1/manual/functions/#Function-composition-and-piping)
(type `\circ` and press Tab to obtain `∘` symbol). `length ∘ string` is
equivalent to an anonymous function `num -> length(string(num))`, i.e. a
function that takes a number, converts it to its textual representation and
returns the number of characters in it. We use `map` to apply the function to
every number in a vector (`nums`) |> and return the length of the 'longest' number
(`maximum`). If the number is composed of only 1 digit then we add 1 


Next, we will write a function that takes a number and brakes it into two parts:
stem and leaf.

```jl
s = """
function getStemAndLeaf(num::Int, stemLen::Int)::Tuple{Str, Str}
    @assert stemLen > 1 "stemLen must be greater than 1"
    numStr::Str = lpad(abs(num), stemLen, "0")
    stem::Str = numStr[1:end-1] |> string
    leaf::Str = numStr[end] |> string
    stemTmp::Int = parse(Int, stem)
    stem = num < 0 ? "-" * string(stemTmp) : string(stemTmp)
    stem = lpad(stem, stemLen, " ")
    return (stem, leaf)
end
"""
sc(s)
```

We begin with `lpad`. The function converts its first input (`abs(num)`) to
string (if it isn't one already) of a given length (`stemLen`) it adds a
specified padding (`"0"`) to the left side of the result if necessary. 
