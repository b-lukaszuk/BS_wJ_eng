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

In this exercise your job is to write a
[terminal](https://en.wikipedia.org/wiki/Terminal_emulator) based application,
like the one presented in the GIF below (it doesn't have to be exact), that
measures your (touch) typing speed.

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

Now, in order to play our touch typing game we need a way to read a character or
characters from the
[terminal](https://en.wikipedia.org/wiki/Terminal_emulator). This could be done
with [read](https://docs.julialang.org/en/v1/base/io-network/#Base.read) or with
`readline` that we met in @sec:tic_tac_toe_solution. The problem is that by
default, those are blocking functions (you need to press Enter for the
`Char`/`String` to be read into your program). It turns out that an immediate,
non-blocking readout in Julia isn't trivial to get. One option suggested by the
[Rosetta
Code](https://rosettacode.org/wiki/Keyboard_input/Flush_the_keyboard_buffer#Julia)
website is to use an external library (the Gtk.jl presented in the link above
seems to be no longer maintained). Other possibility would be to do this in a
programming language better adjusted for such low level tasks, like C. We could
therefore, copy-paste [this code
snippet](https://rosettacode.org/wiki/Keyboard_input/Flush_the_keyboard_buffer#Julia)
(possibly modifying it) and execute it from Julia (similarly to the suggestions
found in [this video](https://www.youtube.com/watch?v=obCMGkQ8Y8g)). However, in
order to keep my solution minimal I will rely on `stty`, a terminal command
found in unix(-like) systems. If you don't have it on your computer you need to
find some other way (or just skip this task).

> **_Note:_** Type `man stty` (and press Enter) into your terminal to check do
> you have the program installed on your system (`q` - closes the man page).
