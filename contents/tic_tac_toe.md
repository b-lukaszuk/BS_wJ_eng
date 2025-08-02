# Tic-tac-toe {#sec:tic_tac_toe}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/tic_tac_toe)
(without explanations).

## Problem {#sec:tic_tac_toe_problem}

Write a program that will enable you to play a simple
[tic-tac-toe](https://en.wikipedia.org/wiki/Tic-tac-toe) game. It may look like
the one in @fig:ttt.

![A simple terminal based tic tac toe game (animation works only in an HTML document).](./images/ttt.gif){#fig:ttt}

In case you wanted to use the same colors as in the gif above, you may find the
[ANSI escape codes](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors)
useful.

## Solution {#sec:tic_tac_toe_solution}

The first decision we must make is the internal representation of our game
board. Two objects come to mind right away, a vector or a matrix. Here, I'll go
with the first option.

```jl
s = """
function getNewGameBoard()::Vec{Str}
    return string.(1:9)
end
"""
sc(s)
```

Next, we'll define a few constants that will be helpful later on.

```jl
s = """
players = ["X", "O"]
lines = [
	[1, 2, 3],
	[4, 5, 6],
	[7, 8, 9],
	[1, 4, 7],
	[2, 5, 8],
	[3, 6, 9],
	[1, 5, 9],
	[3, 5, 7]
]
"""
replace(sc(s), r"\bplayers" => "const players", r"\blines" => "const lines")
```

The two are: `players` symbols used (`"X"` for human, `"O"` for computer player)
and the coordinates of lines in our game board that we need to check to see if
a player won the game. You could probably be more clever and use
[enums](https://docs.julialang.org/en/v1/base/base/#Base.Enums.Enum) and list
comprehensions for our lines (e.g., `[collect(i:(i+2)) for i in [1, 4, 7]]` for
the rows), but for such a simple case it might be an overkill.
