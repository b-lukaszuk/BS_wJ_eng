# Binary {#sec:binary}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/binary)
(without explanations).

## Problem {#sec:binary_problem}

Numbers, or information in general, can be written down in different forms. The
most basic one, and the only one that is actually understood by a computer, is
as a binary. Usually, it is depicted by a sequence of 1s and 0s, but it could be
anything really. Anything, that can take two separate states. The once common
[CDs](https://en.wikipedia.org/wiki/Compact_disc) or
[DVDs](https://en.wikipedia.org/wiki/DVD) are a sequence of laser burns (tiny
pits) in a spiral track (burn - 1, no burn - 0). The [hard disk
drives](https://en.wikipedia.org/wiki/Hard_disk_drive) store data as magnetized
spots, whereas [SSD drives](https://en.wikipedia.org/wiki/Solid-state_drive)
cashe it as electrons trapped in tiny transistors. The data can be read into
into memory (RAM) and send to a processor for calculations.

Here is a task for you, read about [binary
numbers](https://en.wikipedia.org/wiki/Binary_number) or watch some online
videos (e.g. from [Khan
Academy](https://www.youtube.com/watch?v=ku4KOFQ-bB4&list=PLS---sZ5WJJvsjaAQZKwTwxl910xUdO98))
on the topic. Next, to get a better grasp of the subject, write:

- a function that transforms a binary number to its decimal counterpart
- a function that transforms a decimal number to its binary counterpart
- a function that adds two binary numbers
- a function that multiplies two binary numbers

For simplicity, assume that the functions will operate only on natural numbers
in the range of let's say 0 to 1024 (in decimal). You may check your functions
against the built-in `string` and `parse` functions. For instance,
`string(3, base=2)` converts the decimal (3) to its binary representation and
`parse(Int, "11", base=2)` performs the opposite action.

## Solution {#sec:binary_solution}

Let's start with our `dec2bin` converter, we'll base it on the [Khan Academy
videos](https://www.youtube.com/watch?v=ku4KOFQ-bB4&list=PLS---sZ5WJJvsjaAQZKwTwxl910xUdO98)
and similarities with the decimal number system.

A decimal system operates on base 10. A number, let's say: one hundred and
twenty-three (123), can be written with digits ([0-9]) placed in three slots. We
know this because three slots allow us to write $10^3 = 1000$ numbers ([0-999]),
whereas two slots are good only for $10^2 = 100$ numbers ([0-99], compare also
with the [exercise
1](https://b-lukaszuk.github.io/RJ_BS_eng/statistics_intro_exercises.html#sec:statistics_intro_exercise1)
and [its
solution](https://b-lukaszuk.github.io/RJ_BS_eng/statistics_intro_exercises_solutions.html#sec:statistics_intro_exercise1_solution).
The number 123 is actually a sum of one hundred, two tens, and three units
($1*100 + 2*10 + 3*1$ = `sum([1*100, 2*10, 3*1])` = `jl sum([1*100, 2*10, 3*1])`).
Equivalently, this can be written with the consecutive powers of ten
($10^x$ = `10^x` in Julia's code, where x starts at 0), i.e.
$1*10^2 + 2*10^1 + 3*10^0$ =
`sum([1*10^2, 2*10^1, 3*10^0])` = `jl sum([1*10^2, 2*10^1, 3*10^0])`. Pause for
a moment and make sure you got that.

OK,

```jl
s = """
function dec2bin(dec::Int)::Str
    @assert 0 <= dec <= 1024 "dec must be in range [0-1024]"
    rest::Int = dec
    result::Str = dec == 0 ? "0" : ""
    while dec != 0
        dec, rest = divrem(dec, 2)
        result = string(rest) * result
    end
    return result
end
"""
sc(s)
```

In order to convert a number in decimal to its binary form all we have to do it
to divide it by 2 until it is equal 0, which is accomplished with
`while dec != 0`. For that we use `divrem` that returns two numbers: 1) quotient
- the number that remains after the division; and 2) the reminder - 0 for even
division and 1 for uneven. Those two will be stored in `dec` and `rest`
variables, respectively. Moreover, each time we prepend the reminder
(`string(rest)`) to our `result` and voila. Let's see how we did.

```jl
s = """
dec2bin.(0:1024) == string.(0:1024, base=2)
"""
sco(s)
```

It appears we did just fine, as the function produces the same results as the
built-in `string`.