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

Let's start with a helper function that returns the number of characters that
compose a number.

```jl
s = """
function getNumLen(num::Int)::Int
    return num |> string |> length
end
"""
sc(s)
```

The function is quite simple, it sends (`|>`) a number (`num`) to `string`
(converts a number to its textual representation) and redirects the result
(`|>`) to `length`. I find this form clearer that the equivalent
`length(string(num))` of `string(num) |> length` or `(length ∘ string)(num)`
(`∘` is a [function composition
operator](https://docs.julialang.org/en/v1/manual/functions/#Function-composition-and-piping)
that you obtain by typing `\circ` and pressing Tab )

Time for a test run.

```jl
s = """
map(getNumLen, [5, -8, -11, 303])
"""
sco(s)
```

Appears to be working fine.

Now let's write a function that takes a vector of integers and returns the
number of characters in the longest of them (we will need it to determine the
width of the stem later on).

```jl
s = """
function getMaxLengthOfNum(nums::Vec{Int})::Int
    maxLen::Int = map(getNumLen, nums) |> maximum
    return max(2, maxLen)
end
"""
sc(s)
```

> Note. Instead of `map(getNumLen, nums)` above we could have just used
> `map(length ∘ string, nums)`. This would save us some typing (no need to
> define `getNumLen` in the first place), but made the code a bit more cryptic
> at first read.

Again, a piece of cake, we just use `map` to apply `getNumLen` to every number
in a vector (`nums`) and get the length of the 'longest' number by sending the
lengths (`|>`) to `maximum`. Notice, that the function doesn't return the
expected `maxLen`. This is because in a moment, we will write
`getStemAndLeaf(num::Int, maxLenOfNum::Int)` that brakes a number into two
parts: stem and leaf. It will require `maxLenOfNum` to be at least 2
characters long (so that at least one digit serves as a stem and one as a leaf),
hence we end our `getMaxLengthOfNum` with
`max(2, maxLen)`.

```jl
s = """
function getStemAndLeaf(num::Int, maxLenOfNum::Int)::Tuple{Str, Str}
    @assert maxLenOfNum > 1 "maxLenOfNum must be greater than 1"
    @assert getNumLen(num) <= maxLenOfNum
    numStr::Str = lpad(abs(num), maxLenOfNum, "0")
    stem::Str = numStr[1:end-1] |> string
    leaf::Str = numStr[end] |> string
    stem = parse(Int, stem) |> string #1
    stem = num < 0 ? "-" * stem : stem #2
    stem = lpad(stem, maxLenOfNum, " ") #3
    return (stem, leaf)
end
"""
sc(s)
```

We begin with `lpad`. This function converts its first input (`abs(num)`) to
string of a given length (`maxLenOfNum`). It adds a specified padding (`"0"`) to
the left side of the result (if necessary) in order to obtain the string with a
desired number of characters. Next, we proceed to obtain the `stem` which
contains all the characters from `numStr`, except the last one. The `|> string`
makes sure that the end result is `Str` (since e.g. making `stem` from `"21"`
returns `'2'` which is of type `Char`). Similarly, we produce `leaf` by taking
last character of `numStr`. We could end here, and it would likely work fine
for a positive integer. However, handling broader range of inputs
(`num` and `maxLenOfNum`) requires some further `stem` processing. Hence the
lines designated with `#1-#3` that were added in later iterations of
`getStemAndLeaf`.`#1` removes superfluous 0s from the left side of the string
(e.g. `"001"` becomes `"1"` and `"00"` becomes `"0"`). `#2` adds `"-"` sign if
the input (`num`) was negative. `#3` aligns the text (`stem`) to the right. It
does so by adding spaces (`" "`) to the left site of `stem`. All that's left to
do is to `return` our `stem` and `leaf` and see how it works for some exemplary
inputs.

```jl
s = """
[getStemAndLeaf(n, 3) for n in [-12, -3, 3, 8, 10, 145]]
"""
sco(s)
```
