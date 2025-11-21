# Touch Typing {#sec:touch_typing}

In this chapter I did not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/touch_typing)
(without explanations).

## Problem {#sec:touch_typing_problem}

In this exercise your job is to write a terminal based application, like the one
presented in the GIF below (it doesn't have to be exact), that measures your
(touch) typing speed.

![A terminal based application that measures typing speed.](./images/touchTyping.gif){#fig:touchTyping}

Your program should:

- mark the characters in- and correctly typed
- allow to delete the (incorrectly) typed characters
- display some basic summary of the speed (like WPM - words per minute)

To make it easier, you may assume it to always operate on a short line of text
(let's say 50 characters long) composed only of the characters from the standard
Latin alphabet encoded by [ASCII](https://en.wikipedia.org/wiki/ASCII).

## Solution {#sec:touch_typing_solution}

Let's approach the problem one step at a time. First, a formatting function
`getColoredTxt`. The function will colorize the letters based on the correctness
of our input. To that end we will reuse some of the code (see `getRed` and
`getGreen` below) from the previous chapter (see @sec:tic_tac_toe_solution).

```jl
s = """
# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
function getRed(s::Char)::Str
    return "\\x1b[31m" * s * "\\x1b[0m"
end

function getGreen(s::Char)::Str
    return "\\x1b[32m" * s * "\\x1b[0m"
end

function getColoredTxt(typedTxt::Str, referenceTxt::Str)::Str
    result::Str = ""
    for i in eachindex(referenceTxt)
        if i > length(typedTxt)
            result *= referenceTxt[i]
        elseif typedTxt[i] == referenceTxt[i]
            result *= getGreen(referenceTxt[i])
        else
            result *= getRed(referenceTxt[i])
        end
    end
    return result
end
"""
sc(s)
```

> **_Note:_** In this chapter we rely on the assumption that we operate on a
> text composed of standard ASCII charset. Be aware that in the case of other
> charsets the indexing may not work as intended (see [the
> docs](https://docs.julialang.org/en/v1/manual/strings/#Unicode-and-UTF-8))

The code is rather simple, we traverse the `referenceTxt`, i.e. the text we are
suppose to type, with a `for` loop and indexing (`i`). If the text we already
typed (`typedTxt`) is shorter than the current index (`i > length(typedTxt)`) we
just append the character of the reference text to the `result` without coloring
(`result *= referenceTxt[i]`). Otherwise we color the character of our
`referenceTxt[i]` green (`getGreen`) in case of a match
(`typedTxt[i] == referenceTxt[i]`) or red (`getRed`) otherwise. Finally, we
`return` the colored text (`result`) for printout.
