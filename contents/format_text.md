# Format text {#sec:format_text}

In this chapter I used the following libraries. Still, once you read the problem
description you may decide to do otherwise.

```jl
s2 = """
import Random as Rnd
"""
sc(s2)
```

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/format_text)
(without explanations).

## Problem {#sec:format_text_problem}

[Word processing
programs](https://en.wikipedia.org/wiki/List_of_word_processor_programs) offer
many text editing capacities. Let's try to replicate some of those with Julia.

Choose an exemplary text, like `text2beFormatted.txt` from [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/format_text)
or [Lorem ipsum from this Wikipedia's
page](https://en.wikipedia.org/wiki/Lorem_ipsum).  For simplicity, you may
assume the text to be composed of [ASCII encoded
symbols](https://en.wikipedia.org/wiki/ASCII) with the words composed of, let's
say, up to 10 letters and separated by an unspecified number of [whitespace
caracters](https://en.wikipedia.org/wiki/Whitespace_character).

Write a program (a series of functions) that will allow you to:

1. Left align,

```
------------------------------------------------------------------
|  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed  |
|  do eiusmod tempor incididunt ut labore et dolore magna        |
|  aliqua. Ut enim ad minim veniam, quis nostrud exercitation    |
|  ullamco laboris nisi ut aliquip ex ea commodo consequat.      |
|  Duis aute irure dolor in reprehenderit in voluptate velit     |
|  esse cillum dolore eu fugiat nulla pariatur. Excepteur sint   |
|  occaecat cupidatat non proident, sunt in culpa qui officia    |
|  deserunt mollit anim id est laborum.                          |
------------------------------------------------------------------ 
```

2. Right align,

```
------------------------------------------------------------------
|  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed  |
|        do eiusmod tempor incididunt ut labore et dolore magna  |
|    aliqua. Ut enim ad minim veniam, quis nostrud exercitation  |
|      ullamco laboris nisi ut aliquip ex ea commodo consequat.  |
|     Duis aute irure dolor in reprehenderit in voluptate velit  |
|   esse cillum dolore eu fugiat nulla pariatur. Excepteur sint  |
|    occaecat cupidatat non proident, sunt in culpa qui officia  |
|                          deserunt mollit anim id est laborum.  |
------------------------------------------------------------------ 
```

3. Center,

```
------------------------------------------------------------------
|  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed  |
|     do eiusmod tempor incididunt ut labore et dolore magna     |
|   aliqua. Ut enim ad minim veniam, quis nostrud exercitation   |
|    ullamco laboris nisi ut aliquip ex ea commodo consequat.    |
|   Duis aute irure dolor in reprehenderit in voluptate velit    |
|  esse cillum dolore eu fugiat nulla pariatur. Excepteur sint   |
|   occaecat cupidatat non proident, sunt in culpa qui officia   |
|              deserunt mollit anim id est laborum.              |
------------------------------------------------------------------ 
```

4. Justify,

```
------------------------------------------------------------------
|  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed  |
|  do eiusmod  tempor  incididunt  ut labore  et  dolore  magna  |
|  aliqua. Ut  enim ad minim  veniam, quis nostrud exercitation  |
|  ullamco  laboris nisi  ut  aliquip ex ea  commodo consequat.  |
|  Duis aute irure  dolor  in  reprehenderit in voluptate velit  |
|  esse cillum dolore eu fugiat nulla pariatur. Excepteur  sint  |
|  occaecat cupidatat  non proident, sunt in culpa  qui officia  |
|  deserunt mollit anim id est laborum.                          |
------------------------------------------------------------------ 
```

or

5. Justify in a double column layout

```
------------------------------------------------------------------
|  Lorem ipsum dolor sit  amet,    aute    irure    dolor    in  |
|  consectetur adipiscing elit,    reprehenderit  in  voluptate  |
|  sed   do    eiusmod   tempor    velit esse  cillum dolore eu  |
|  incididunt  ut   labore   et    fugiat    nulla    pariatur.  |
|  dolore magna aliqua. Ut enim    Excepteur   sint    occaecat  |
|  ad    minim   veniam,   quis    cupidatat non proident, sunt  |
|  nostrud exercitation ullamco    in    culpa    qui   officia  |
|  laboris  nisi  ut aliquip ex    deserunt  mollit anim id est  |
|  ea  commodo consequat.  Duis    laborum.                      |
------------------------------------------------------------------ 
```

the text (the borders are optional).

## Solution {#sec:format_text_solution}

Our first step in formatting a paragraph will be to break it into lines, each
with the length smaller than or equal to some target value.

```
const PAD = " "
const MAX_LINE_LEN = 60

function getLines(txt::Str, targetLineLen::Int=MAX_LINE_LEN)::Vec{Str}
    @assert 19 < targetLineLen < 61 "targetLineLen must be in range [20-60]"
    words::Vec{Str} = split(txt)
    lines::Vec{Str} = []
    curLine::Str = ""
    difference::Int = 0
    for word in words
        difference = targetLineLen - length(curLine) - length(word)
        if difference >= 0
            curLine *= word * PAD
        else
            push!(lines, strip(curLine))
            curLine = word * PAD
        end
    end
    push!(lines, strip(curLine))
    return lines
end
```

For that we break our text (`txt`) into `words` with the `split` function. Next,
`for` each `word` we calculate the `difference` between our desired line length
(`targetLineLen`) and the current line length (`length(curLine)`) plus the
length of the word (`length(word)`) we want to add to that line. If we still got
room for one more word (`if difference >= 0`) then we just add it with a padding
on the right side (`curLine *= word * PAD`). Otherwise (`else`), we add
`curLine` to the vector of `lines` with `push!` and make our `word` the
beginning of a new line (`curLine = word * PAD`). Notice, that before `push`ing
the old line to the collection, first, we `strip`ped it from any possible extra
spaces on the edges. Afterwards (`end` of `for`), we `push` the last line to
`lines` and return the latter from inside the function.

Now, for left-, right- and center alignment each line will have to be padded
with space characters (`PAD`) placed on the right, left, and both sides,
respectively. For that we need to know the difference between the number of
characters in our line and its target length. Moreover, we need a padding
function. Notice, the usage of the `*` operator that glues two strings
together and the `^` symbol that repeats the sting on its left the number of
times on its right (remember about the operator precedence from mathematics).

```
function getLenDiffs(lines::Vec{Str},
                     targetLineLen::Int=MAX_LINE_LEN)::Vec{Int}
    return targetLineLen .- map(length, lines)
end

function padLine(line::Str, lPadLen::Int, rPadLen::Int,
                 lPad::Str=PAD, rPad::Str=PAD)::Str
    @assert lPadLen >= 0 && rPadLen >= 0, "padding lengths must be >= 0"
    return lPad ^ lPadLen * line * rPad ^ rPadLen
end
```

Once we got it, padding lines should be a breeze.

```
function getPaddedLines(lines::Vec{Str},
                         lPadsLens::Vec{Int}, rPadsLens::Vec{Int})::Vec{Str}
    @assert(length(lines) == length(lPadsLens) == length(rPadsLens),
            "all vectors must be of equal lengths")
    return map(padLine, lines, lPadsLens, rPadsLens)
end
```

Here, similarly to @sec:mat_multip_solution, we use
[map](https://docs.julialang.org/en/v1/base/collections/#Base.map), which
applies a function (`padLine`) to every consecutive elements of `lines`,
`lPadsLens` and `rPadsLens` in turn. So it goes like: `padLine(lines[1],
lPadsLens[1], rPadsLens[1])` and `padLine(lines[2], lPadsLens[2],
rPadsLens[2])`, etc., and collect the results into a vector.
