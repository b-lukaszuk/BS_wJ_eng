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

Choose an exemplary text, like `text2beFormatted.txt` or [Lorem
ipsum](https://en.wikipedia.org/wiki/Lorem_ipsum) from the Wikipedia page. For
simplicity, you may assume the text to be composed of [ASCII
characters](https://en.wikipedia.org/wiki/ASCII) with the words composed of,
let's say, up to 10 characters.

Write a program (a series of functions) that will allow you to:

1. Left align

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

2. Right align

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

3. Center

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

4. Justify

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

and/or

5. Justify in a double column layout

```
-------------------------------------------------------------
|  Lorem  ipsum  dolor   sit     Duis  aute irure dolor in  |
|  amet,         consectetur     reprehenderit          in  |
|  adipiscing elit,  sed  do     voluptate   velit    esse  |
|  eiusmod tempor incididunt     cillum  dolore  eu fugiat  |
|  ut labore et dolore magna     nulla pariatur. Excepteur  |
|  aliqua.  Ut enim ad minim     sint  occaecat  cupidatat  |
|  veniam,   quis    nostrud     non  proident,  sunt   in  |
|  exercitation      ullamco     culpa     qui     officia  |
|  laboris  nisi  ut aliquip     deserunt mollit  anim  id  |
|  ex ea  commodo consequat.     est laborum.               |
-------------------------------------------------------------
```

the text.

## Solution {#sec:format_text_solution}

The solution goes here.
