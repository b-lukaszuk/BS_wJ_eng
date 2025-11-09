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

But how do the computers generate them. Well, actually they don't. But then how
could a Julia's `Random.jl` (part of the standard library) generate one. Hmm,
it's complicated, but the basic idea could be explained with an example.

In a moment I will use a function that generates a random number in the range 1
to 10. Take a moment and try to guess it. Ready, here we go.

```
getRand()
```

```
7
```

Did you guess it? If so, congrats. The popular psychology claims that for the
said range people most often choose 7 and 3 so I wonder just how many of you,
the readers, succeeded. Anyway, let me try again, I will generate 10 random
numbers and you will try to guess the next one, ready.

```
[getRand() for _ in 1:10]
```

```
[ 8, 9, 10, 1, 2, 3, 4, 5, 6, 7]
```

Ok, what's the next number? You got it, its 8. Now let's examine this suboptimal
number generator.

```
seed = 6

function getRand()::Int
    newSeed::Int = (seed % 10) + 1
    global seed = newSeed
    return newSeed
end
```

First, we declare some initial hard to predict undisclosed value (`seed`). Next,
inside `getRand` we update the seed using some mathematical formula and return
it as our result. Moreover, we update the old seed (global variable) with that
new value (`global seed = newSeed`), so that next time we use `getRand` it will
return us some new value.

Surprisingly this is more or less what the [random number
generators](https://en.wikipedia.org/wiki/List_of_random_number_generators#Pseudorandom_number_generators_(PRNGs))
do. The idea we got there was not bad, we just need to improve its
execution. We need a better starting value, a less obvious update method, and a
much longer looping period so no one sees that it repeats itself.

And here we are. In this chapter we are going to develop a simplified library
for random numbers generation.

First, pick a random number generator that is easy enough to implement
([LCG](https://en.wikipedia.org/wiki/Linear_congruential_generator) seems to be
easy enough, but it's up to you). The `seed` is often initialized with [epoch
time](https://en.wikipedia.org/wiki/Epoch_(computing)), e.g. the number of
miliseconds since 1 January 1970, which is kind of unpredictable. You should be
able to get it out of [Dates](https://docs.julialang.org/en/v1/stdlib/Dates/)
module. Use the LCG to write `getRand` that returns a random `Float64` in the
range `[0-1)` (inclusive - exclusive). This is our bread and butter of random
number generation. It works similar to JavaScript's `Math.random()` or Julia's
`rand()` (`Base.rand` is imports it from `Random.jl`). Next, define another
`getRand` method, the one that returns a random integer from a given range.
To cool down read about [Box-Mueller
transform](https://en.wikipedia.org/wiki/Box%E2%80%93Muller_transform) and use it to define
two `getRandn` methods, one that returns a value from a [standard normal
distribution](https://en.wikipedia.org/wiki/Normal_distribution#Standard_normal_distribution)
with mean = 0 and standard deviation = 1 (like the `Base.randn`). The other
should return a normal distribution with a specified mean and standard
deviation.

If the above feels overwhelming, then do as much as you can (one step at a
time). Remember you need to understand this stuff enough to implement it in
code, leave the mathematical proofs to mathematitians and trust they did they
job right.

## Solution {#sec:randomness_solution}

The solution goes here.
