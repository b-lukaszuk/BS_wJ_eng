# Leap year {#sec:leap_year}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/leap_year)
(without explanations).

## Problem {#sec:leap_year_problem}

As you probably know an astronomical year is slightly less than 365 days
(roughly 365.25 days). For that reason [the Gregorian
calendar](https://en.wikipedia.org/wiki/Gregorian_calendar) got common years
(365 days each) and [leap years](https://en.wikipedia.org/wiki/Leap_year).

You task is to write a function that detects whether a given year is leap
(according to the Gregorian calendar). Feel free to test it, e.g. on the
following input: [1792, 1859, 1900, 1918, 1974, 1985, 2000, 2012] of which only
1792, 2000, and 2012 are leap years.

## Solution {#sec:leap_year_solution}

Let's start with the algorithm, as stated in [the Wikipedia's
page](https://en.wikipedia.org/wiki/Gregorian_calendar):

> The rule for leap years is that every year divisible by four is a leap year,
> except for years that are divisible by 100, except in turn for years also
> divisible by 400.

Nothing more, nothing less. Time to translate it into Julia's code.

```jl
s = """
function isLeap(yr::Int)::Bool
    @assert 0 < yr < 4001 "yr must be in range [1-4000]"
    divisibleBy4::Bool = yr % 4 == 0
    gregorianException::Bool = (yr % 100 == 0) && (yr % 400 != 0)
    if !divisibleBy4
        return false
    else
        return !gregorianException
    end
end
"""
sc(s)
```

The powerhouse of our function is is `%` (modulo operator) that returns the
reminder of the division. If a number `x` is evenly divided by a number `y`
(`x % y`) the reminder is equal to zero (`==`). Otherwise (`x % y != 0`) the `x`
cannot be evenly divided by `y`. Although not strictly necessary, we added a
mnemonic names for the tested conditions (`divisibleBy4` and
`gregorianException`), which should make the code more readable. Anyway, if a
year (`yr`) is not divisible by 4 (`!divisibleBy4`) then it is a common year.
Otherwise (`else`) if the the year fulfills the exception rule
(`gregorialException` is `true`) it is not a leap year (hence we negate `!`
`gregorianException`, because `!true` is `false`). If a year (`yr`) does not
meet the exception criteria (`gregorianException` is `false`) it is a common
year (we negate `false`, so we get `true`).

Actually, we can get rid of the `if`-`else` condition by using `&&` (logical
and) and its short circuiting property.

```jl
s1 = """
function isLeap(yr::Int)::Bool
    @assert 0 < yr < 4001 "yr must be in range [1-4000]"
    divisibleBy4::Bool = yr % 4 == 0
    gregorianException::Bool = (yr % 100 == 0) && (yr % 400 != 0)
    return divisibleBy4 && !gregorianException
end
"""
sc(s1)
```

When `divisibleBy4` is `false` the and operator (`&&`) skips the evaluation of
its second argument (short circuiting) and returns false. Otherwise,
(`divisibleBy4` is `true`) `!gregorianException` is evaluated and it becomes the
result of the function. For explanation of `!gregorianException` see the
explanation a few paragraphs above.

Time for a simple test.

```jl
s = """
yrs = [1792, 1859, 1900, 1918, 1974, 1985, 2000, 2012]
filter(isLeap, yrs)
"""
sco(s)
```

The `filter` function applies `isLeap` to each element of `yrs` and returns only
those for which the result is `true`.
