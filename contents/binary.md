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
cash it as electrons trapped in tiny transistors. The data can be read into
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
solution](https://b-lukaszuk.github.io/RJ_BS_eng/statistics_intro_exercises_solutions.html#sec:statistics_intro_exercise1_solution)).
The number 123 is actually a sum of one hundred, two tens, and three units
($1*100 + 2*10 + 3*1$ = `sum([1*100, 2*10, 3*1])` = `jl sum([1*100, 2*10, 3*1])`).
Equivalently, this can be written with the consecutive powers of ten
($10^x$ = `10^x` in Julia's code, where x starts from the right and at 0), i.e.
$1*10^2 + 2*10^1 + 3*10^0$ =
`sum([1*10^2, 2*10^1, 3*10^0])` = `jl sum([1*10^2, 2*10^1, 3*10^0])`. Pause for
a moment and make sure you got that.

Similar reasoning applies to binary numbers, but here we operate on the powers
of two. A number, let's say: fourteen (14), can be written with digits ([0-1])
placed in four slots. This is because $2^4$ allows us to write down 16 numbers
(in binary: [0000-1111]), whereas $2^3$ suffices for only 8 numbers (in binary:
[000-111]). Each slot (from right to left) represents subsequent powers of two,
i.e. ones ($2^0 = 1$), twos ($2^1 = 2$), fours ($2^2 = 4$), and eights ($2^3 =
8$). Once again we sum the digits to get our encoded number `1110` =
$1*2^3 + 1*2^2 + 1*2^1 + 1*2^0$ = $1*8 + 1*4 + 1*2 + 1*0$ =
`sum([1*8, 1*4, 1*2, 1*0])` = `jl sum([1*8, 1*4, 1*2, 1*0])`. Time to put that
knowledge to good use by writing our `dec2bin`.

```jl
s = """
function getNumOfBits2codeDec(dec::Int)::Int
    @assert 0 <= dec <= 1024 "dec must be in range [0-1024]"
    dec = (dec == 0) ? 1 : dec
    for i in 1:dec
        if 2^i > dec
            return i
        end
    end
    return 0 # should never happen
end

function dec2bin(dec::Int)::Str
    @assert 0 <= dec <= 1024 "dec must be in range [0-1024]"
    nBits::Int = getNumOfBits2codeDec(dec)
    result::Vec{Char} = fill('0', nBits)
    bitDec::Int = 2^(nBits-1) # -1, because powers of 2 start at 0
    for i in eachindex(result)
        if bitDec <= dec
            result[i] = '1'
            dec -= bitDec
        end
        bitDec = (bitDec < 2) ? 0 : bitDec/2
    end
    return join(result)
end
"""
sc(s)
```

We begin by declaring `getNumOfBits2codeDec`, a function that will help us to
find how many bits (slots) we need in order to code a given decimal as a binary
number. It does so by using a 'brute force' approach (`for i in 1:dec`) with an
early stop mechanism (`if 2^i > dec`). As an alternative we may consider to
use the built-in `log2` function, but the approach presented here just seemed so
natural and in line with the previous explanations that I just couldn't resist.

As for the `dec2bin` function we start by declaring a few helper variables:
`nBits` - number of bits/slots we need to fill in order to code our number,
`result` - a vector that will hold our final binary representation, and
`bitDec` - a variable that will store the consecutive powers of 2 (expressed in
decimal). Next, we traverse the bits/slots of our `result` from left to
right. When the current power of two is smaller or equal to the decimal we still
got to encode (`if bitDec <= dec`) then we set that particular bit to 1
(`result[i] = '1'`) and reduce the decimal we need to encode by that value
(`dec -= bitDec`). Moreover, we update (reduce) our consecutive powers of two
(`bitDec`) by using the 2 divisor (`bitDec/2`, since in the array: $2^4 = 16,
2^3 = 8, 2^2 = 4, 2^1 = 2, 2^0 = 1$ each number gets two times smaller). The
`(bitDec < 2) ? 0` protects us from the case when the integer division by 2 is
not possible (when in the last turnover of the loop `bitDec` will be equal to
`1`).

Let's see how it works with a couple of numbers.

```jl
s = """
lpad.(dec2bin.(0:8), 4, '0')
"""
replace(sco(s), "\", " => "\",\n", "[" => "[\n", "]" => "\n]")
```

Time for a benchmark vs. the built-in `string` function.

```jl
s = """
all([dec2bin(i) == string(i, base=2) for i in 0:1024]) # python like
# or simply, more julia style
dec2bin.(0:1024) == string.(0:1024, base=2)
"""
sco(s)
```

It appears we did just fine, as the function produces the same results as
`string`.
