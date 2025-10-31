# Birthday {#sec:birthday}

In this chapter I did not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/birthday)
(without explanations).

## Problem {#sec:birthday_problem}

The following is a classical [birthday
paradox](https://en.wikipedia.org/wiki/Birthday_problem) problem slightly
modified by me.

Imagine you're throwing a party for your birthday. You invited 4 people.
And now you begin to wonder:

1) what is the [probability](https://en.wikipedia.org/wiki/Probability) that any
two of your guests were born on the same day of a year?
2) what is the [probability](https://en.wikipedia.org/wiki/Probability) that any
of your guests were born on the same day of a year that you were born on?

Use Julia to answer the before-mentioned questions for the number of guests,
let's say in the range [4-30].

## Solution {#sec:birthday_solution}

The following solution is based on a computer simulation and relies on a few
assumptions, namely:

1) there are always exactly 365 days in a year (no country for leap years)
2) a person got equal chance to be born on any day of a year (no seasonal and
yearly patterns, etc.)
3) the birth date of one person does not influence the birth date of another
person (not twins, siblings, etc.)

None of the above is exactly true, still, those are some reasonable assumptions
that will allow us to knack the problem.
