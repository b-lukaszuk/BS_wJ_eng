# Calendar {#sec:calendar}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/calendar)
(without explanations).

## Problem {#sec:calendar_problem}

A Gnu/Linux operating system comes with a bunch of
[utilities](https://en.wikipedia.org/wiki/Util-linux) that help with an everyday
life. One of them is [cal](https://en.wikipedia.org/wiki/Cal_(command)) command
that displays a calendar. Let's try to mimic a fraction of its power.
Write a program that prints a calendar for a given month that looks similarly
to:

```
> cal Jun 2025 # shell command (output starts 1 line below)
     June 2025
Su Mo Tu We Th Fr Sa
 1  2  3  4  5  6  7
 8  9 10 11 12 13 14
15 16 17 18 19 20 21
22 23 24 25 26 27 28
29 30
```

Use it to tell on which day of the week you were born.

Alternatively, assume that the Gregorian calendar has been applied throughout
the [Common Era](https://en.wikipedia.org/wiki/Common_Era). Based on that say:

- on what day of the week was Jesus born (assume: Dec 25, year 1)?
- on what day of the week did Christopher Columbus departed from Palos de la
  Frontera and later discovered the New World (assume: Aug 3, year 1492)?
- on what day of the week was the world suppose to end (assume: Dec 21, year
  2012, but you [got plenty dates to choose
  from](https://en.wikipedia.org/wiki/List_of_dates_predicted_for_apocalyptic_events))?
- on what day of the week will the next millennium start (assume: Jan 1, 3000)?

Try not to employ the built-in
[Dates](https://docs.julialang.org/en/v1/stdlib/Dates/) module in your
solution. Still, you may use it to verify your results, e.g. in order to know on
which day did this year start just type:

```jl
s = """
import Dates as Dt

d = Dt.Date(2025, 1, 1)
Dt.dayname(d)
"""
sco(s)
```

BTW. You may use the above as your reference point for counting days.

## Solution {#sec:calendar_solution}

First let's begin by defining a few rather self explanatory constants (`const`)
that we will use throughout our program.

```jl
s = """
daysPerWeek::Int = 7
daysPerMonth::Vec{Int} = [31, 28, 31, 30, 31, 30, 31,
	31, 30, 31, 30, 31]
daysPerMonthLeap::Vec{Int} = [31, 29, 31, 30, 31, 30, 31,
	31, 30, 31, 30, 31]
shiftYr::Int = 365
shiftYrLeap::Int = 366
monthsNum2Name::Dict{Int, Str} = Dict(
    1 => "January", 2 => "February", 3 => "March",
    4 => "April", 5 => "May", 6 => "June", 7 => "July",
    8 => "August", 9 => "September", 10 => "October",
    11 => "November", 12 => "December")
monthsName2Num::Dict{Str, Int} = Dict(
    "Jan" => 1, "Feb" => 2, "Mar" => 3,
    "Apr" => 4, "May" => 5, "Jun" => 6, "Jul" => 7,
    "Aug" => 8, "Sep" => 9, "Oct" => 10,
    "Nov" => 11, "Dec" => 12)
"""
replace(sc(s), r"\bd" => "const d", r"\bs" => "const s", r"\bm" => "const m")
```

As you can see from the output of `cal Jan 2025` we get a rectangular printout
with 7 rows and `x` columns. Clearly, the number of elements is a multiple of 7.
So, let's write a function that determines how many elements should be in our
rectangle.

```jl
s = """
function getMultOfYGtEqX(x::Int, y::Int=daysPerWeek)::Int
    @assert x > 0 && y > 0 "x and y must be > 0"
    @assert x >= y "x must be >= y"
    if x % y == 0
        return x
    else
        return round(Int, ceil(x / y)) * y
    end
end
"""
sc(s)
```

To that end we wrote `getMultOfYGtEqX` that, as its name implies, returns the
multiple of `y` that is greater than or equal to `x`.
