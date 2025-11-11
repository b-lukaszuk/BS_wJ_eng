# Randomness {#sec:randomness}

In this chapter I did not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/randomness)
(without explanations).

## Problem {#sec:randomness_problem}

Random numbers are the numbers that occur, well, at random. Anyway, they are
quite useful for programming. Chances are you will use them to solve the
problems in @sec:birthday_problem or @sec:logo_problem.

But how do the computers generate them. Surprise, they don't. But then how
could a Julia's `Random.jl` (part of the standard library) generate one. Hmm,
it's complicated, but the basic idea could be explained with an example.

In a moment I will use a function that generates a random number in the range 1
to 10. Take a moment and try to guess it.

Ready, here we go.

```
getRand()
```

The number was seven. Did you guess it? If so, congrats. The popular psychology
claims that for the said range people most often choose 7 and 3 so I wonder just
how many of you, the readers, succeeded. Anyway, let me try again, I will use
[comprehensions](https://b-lukaszuk.github.io/RJ_BS_eng/julia_language_repetition.html#sec:julia_language_comprehensions)
to generate 10 random numbers and you will try to guess the next one, ready.

```
[getRand() for _ in 1:10]
```

```
[ 8, 9, 10, 1, 2, 3, 4, 5, 6, 7]
```

OK, what's the next number?

You got it, it's 8. Now let's examine this sub-optimal number generator.

```
seed = 6

function getRand()::Int
    newSeed::Int = (seed % 10) + 1
    global seed = newSeed
    return newSeed
end
```

First, we declare some initial, undisclosed and hard to predict value (`seed` -
a global variable) from which our results will grow. Next, inside `getRand` we
update the `seed ` using some mathematical formula and return it as our
result. Moreover, we update the old `seed ` with that new value
(`global seed = newSeed`), so that the next time we use `getRand` it will return
us some new value.

Surprisingly this is more or less what the [random number
generators](https://en.wikipedia.org/wiki/List_of_random_number_generators#Pseudorandom_number_generators_(PRNGs))
do. The idea we got there was not bad, we just need to improve on its
execution. We need a less obvious starting value, a more chaotic update method,
and a much longer looping period so that no one sees that the sequence repeats
itself periodically.

And here we are. In this chapter we are going to develop a simplified library
for random numbers generation.

First, pick a random number generator that is easy enough to implement
([LCG](https://en.wikipedia.org/wiki/Linear_congruential_generator) seems to be
good enough, but it's up to you). The `seed` is often initialized with [epoch
time](https://en.wikipedia.org/wiki/Epoch_(computing)), e.g. the number of
seconds that passed since 1 January 1970, which is kind of
unpredictable. You should be able to get it out of
[Dates](https://docs.julialang.org/en/v1/stdlib/Dates/) module. Use the LCG to
write `getRand` that returns a random `Float64` in the range `[0-1)`
(inclusive - exclusive). This is our bread and butter of random number
generation. It works similar to JavaScript's `Math.random()` or Julia's `rand()`
(`Base.rand` imports it from `Random.jl`). Next, define another `getRand`
method, the one that returns a random integer from a given range. To cool down
read about [Box-Mueller
transform](https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform) and use
it to define two `getRandn` methods, one that returns a value from a [standard
normal
distribution](https://en.wikipedia.org/wiki/Normal_distribution#Standard_normal_distribution)
with mean = 0 and standard deviation = 1 (like the `Base.randn`). The other
should return a normal distribution with a specified mean and standard
deviation.

If the above feels overwhelming, then do as much as you can one step at a
time. Remember you need to understand this stuff enough to implement it in code,
leave the theorems and proofs to mathematicians and trust that they did they
jobs right.

## Solution {#sec:randomness_solution}

We start by defining a few global variables required by LCG as well a a way to
set our `seed` to a desired value.

```jl
s = """
import Dates as Dt

a = 1664525
c = 1013904223
m = 2^32
seed = round(Int, Dt.now() |> Dt.datetime2unix)

function setSeed!(newSeed)
    global seed = newSeed
    return nothing
end
"""
sc(s)
```

The values were chosen based on [this table from
Wikipedia](https://en.wikipedia.org/wiki/Linear_congruential_generator#Parameters_in_common_use).

Time to translate the LCG algorithm to Julia's code.

```jl
s = """
function getRandFromLCG()::Int
    newSeed::Int = (a * seed + c) % m
    setSeed!(newSeed)
    return newSeed
end
"""
sc(s)
```

Let's see how it works.

```jl
s = """
[getRandFromLCG() for _ in 1:6]
"""
sco(s)
```

A small victory, in result we got some integers that are very hard to predict
for a human brain alone.

Still, the numbers are unwieldy and look quite odd, how can we transform them
into a function that returns `Float64` from the range `[0-1)`? The key is the
modulo operator (`%` equivalent to `rem` function) in `getRandFromLCG` which is
a reminder after division. It has an interesting property, the remainder of `i`
divided by `m` is always in the range 0 to `m-1`, see the example below.

```jl
s = """
[i % 3 for i in 1:7]
"""
sco(s)
```

If so then all we have to do is to divide our `seed` by `m` to bet the desired
`Float64` value.

```jl
s = """
function getRand()::Flt
    return getRandFromLCG() / m
end

[getRand() for _ in 1:3]
"""
sco(s)
```

Much better, we reached the first checkpoint. OK, now how to convert it to an
random integer generator. Let's try one step at a time, the `getRand()` returns
a `Float64` in the range `[0-1)` so if we multiply it by some integer and round
it (`floor` returns the nearest integer greater than or equal to a `Float64`) we
should get a value from 0 almost up to that integer (since the max is slightly
below 1).

```jl
s = """
function getRand(upToExcl::Int)::Int
    @assert 0 < upToExcl "upToExcl must be greater than 0"
    return floor(getRand() * upToExcl)
end
"""
sc(s)
```

Time, for a test. If we did our job right we should get a sequence of random
values each equally likely to occur (`getCounts` was developed and explained
[here](https://b-lukaszuk.github.io/RJ_BS_eng/statistics_prob_theor_practice.html)).

```jl
s = """
function getCounts(v::Vec{T})::Dict{T,Int} where T
    counts::Dict{T,Int} = Dict()
    for elt in v
        counts[elt] = get(counts, elt, 0) + 1
    end
    return counts
end

[getRand(3) for _ in 1:100_000] |> getCounts
"""
sco(s)
```

Yep, roughly equal counts. One, more swing with a different range.

```jl
s = """
[getRand(5) for _ in 1:100_000] |> getCounts
"""
sco(s)
```

Ladies and gentlemen, we got it. Now, time to tweak a bit so that we can get an
integer in the desired range.

```jl
s = """
function getRand(minIncl::Int, maxIncl::Int)::Int
    @assert 0 < minIncl < maxIncl "must get: 0 < minIncl < maxIncl"
    return minIncl + getRand(maxIncl-minIncl+1)
end

function getRand(n::Int, minIncl::Int, maxIncl::Int)::Vec{Int}
    @assert 0 < n "n must be greater than 0"
    return [getRand(minIncl, maxIncl) for _ in 1:n]
end
"""
sc(s)
```

For that we just generated an `Int` from 0 up to one more than the span of our
range (`maxIncl-minIncl+1`) and added `minIncl` so that the range starts at that
value and not at zero. Let's check it out.

```jl
s = """
getRand(100_000, 1, 4) |> getCounts
"""
sco(s)
```

Looks good, roughly equal counts was what we were looking for. One more time,
just to be sure.

```jl
s = """
getRand(100_000, 3, 7) |> getCounts
"""
sco(s)
```

Another checkpoint reached.

As for the Box-Mueller transform there is a small problem, the Wikipedia
contains [the algorithm implementation in
Julia](https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform#Julia). So for
a change, what we will do here is take the [JavaScript
version](https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform#JavaScript)
and translate it to Julia.

```jl
s = """
function getRandn()::Tuple{Flt, Flt}
    theta::Flt = 2 * pi * getRand()
    R::Flt = sqrt(-2 * log(getRand()))
    x::Flt = R * cos(theta)
    y::Flt = R * sin(theta)
    return (x, y)
end

"""
sc(s)
```

And voila, the only differnce is that instead of a vector we return a tuple with
each element being a value from a normal distribution with mean = 0 and standard
deviation = 1. However, in general we would be interested in a function that
returns any number of normally distributed values (and not only two), hence the
following code.

```jl
s = """
function flatten(randnNums::Vec{Tuple{A, A}})::Vec{A} where A
    len::Int = length(randnNums) * 2
    result::Vec{A} = Vec{A}(undef, len)
    i::Int = 1
    for (a, b) in randnNums
        result[i] = a
        result[i+1] = b
        i += 2
    end
    return result
end

function getRandn(n::Int)::Vec{Flt}
    @assert n > 0 "n must be greater than 0"
    roughlyHalf::Int = cld(n, 2)
    return flatten([getRandn() for _ in 1:roughlyHalf])[1:n]
end
"""
sc(s)
```

In `getRandn(n::Int)` generates a vector of tuples using comprehensions. The
length of the vector is determined using `cld`, which divides n by two, and
returns the smallest integer equal to or greater than the result of that
division. The vector of tuples (in this case `Vec{Tuple{Flt, Flt}}`) is
`flatten`ed vefore being returned from `getRandn(n::Int)` as a regular vector of
floats (`Vec{Flt}`).
