# Roman numerals {#sec:roman_numerals}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/roman_numerals)
(without explanations).

## Problem {#sec:roman_numerals_problem}

Every now and then we encounter some Roman numerals written on an old building's
wall or on a book's page. Your job is to refresh your knowledge about the
numerals, e.g. by reading [this Wikipedia's
entry](https://en.wikipedia.org/wiki/Roman_numerals), and write a two way
converter, for instance in the form of `getRoman(arabic::Int)::Str` and
`getArabic(roman::Str)::Int` functions. Below you will find two sets of parallel
numbers (based on the Wikipedia's page) so that you can test your results (your
solution should work correctly for the numbers in range [1-3999]).

```jl
s = """
arabicTest = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10,
              11, 12, 39, 246, 789, 2421, 160, 207, 1009, 1066,
              3999, 1776, 1918, 1944, 2025,
			  1900, 1912]
romanTest = ["I", "II", "III", "IV", "V",
             "VI", "VII", "VIII", "IX", "X",
             "XI", "XII", "XXXIX", "CCXLVI", "DCCLXXXIX",
             "MMCDXXI", "CLX", "CCVII", "MIX", "MLXVI",
             "MMMCMXCIX", "MDCCLXXVI", "MCMXVIII", "MCMXLIV", "MMXXV",
             "MCM", "MCMXII"]
"""
sc(s)
```

Good luck.

## Solution {#sec:roman_numerals_solution}

The solution goes here.
