# Cheque {#sec:cheque}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/cheque)
(without explanations).

## Problem {#sec:cheque_problem}

Every now and then it comes in handy to be able to write down an [English
numeral](https://en.wikipedia.org/wiki/English_numerals) with the words. Case in
point would be to write a sum of money on a cheque or to display it in a finance
(perhaps bank) app. So here is a task for you. Write a program in Julia that for
any number, let's say in the range 1 to 999,999 returns its transcription with
words.

## Solution {#sec:cheque_solution}

We begin by defining a few constants that will be useful later on.

```jl
s = """
unitsAndTeens = Dict(0 => "zero", 1 => "one",
                     2 => "two", 3 => "three", 4 => "four",
                     5 => "five", 6 => "six", 7 => "seven",
                     8 => "eight", 9 => "nine", 10 => "ten",
                     11 => "eleven", 12 => "twelve",
                     13 => "thirteen", 14 => "fourteen",
                     15 => "fifteen", 16 => "sixteen",
                     17 => "seventeen", 18 => "eighteen",
                     19 => "nineteen")

tens = Dict(20 => "twenty", 30 => "thrity",
            40 => "forty", 50 => "fifty", 60 => "sixty",
            70 => "seventy", 80 => "eigthy", 90 => "ninety")
"""
replace(sc(s), r"\units" => "const units", r"\tens " => "const tens ")
```

The above are just mappings between the necessary basic key elements of our
number soup. Let's use them to get the transcript for numbers in the range of 0
to 99.

```jl
s = """
function getEngNumeralUpto99(n::Int)::Str
    @assert 0 <= n <= 99 "n must be in range [0-99]"
    if n < 20
        return unitsAndTeens[n]
    end
    u::Int = rem(n, 10) # u - units
    result::Str = tens[n-u]
    if u != 0
        result *= "-" * unitsAndTeens[u]
    end
    return result
end
"""
sc(s)
```

Whenever a number (`n`) is below 20 (`if n < 20`) we just return its
representation from the `unitsAndTeens` dictionary. Alternatively, for `n` in
the `tens`, first we obtain the units (`u`) part, which is a reminder of
dividing `n` by `10` (`rem(n, 10)`). We use it (`u`), to obtain the transcript
for the tens (`tens[n-u]`). It becomes our `result` to which we attach the
transcript for units separated by hyphen (`"-" * unitsAndTeens[u]`), but only if
the unit is different than zero (`if u != 0`).

Time for a test ride.

```jl
s = """
(
	getEngNumeralUpto99.([0, 5, 9, 11, 13, 20, 21]),
	getEngNumeralUpto99.([25, 32, 58, 64, 66]),
	getEngNumeralUpto99.([79, 83, 95, 99])
)
"""
replace(sco(s), "], " => "],\n")
```

Good. It appears we got that one out of our way. Let's move on to something
bigger.
