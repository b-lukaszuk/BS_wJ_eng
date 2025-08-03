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
the rows), but for such a simple case it might be overkill.

OK, time to format the board.

```jl
s = """
# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
function getGray(s::Str)::Str
    # "\\x1b[90m" sets forground color to gray
    # "\\x1b[0m" resets forground color to default value
    return "\\x1b[90m" * s * "\\x1b[0m"
end

function getRed(s::Str)::Str
    # "\\x1b[31m" sets forground color to red
    return "\\x1b[31m" * s * "\\x1b[0m"
end

function isTaken(field::Str)::Bool
    return field in players
end

function colorBoard(board::Vec{Str})::Vec{Str}
    result::Vec{Str} = copy(board)
    for i in 1:9
        if !isTaken(board[i])
            result[i] = getGray(board[i])
        end
    end
    return result
end
"""
sc(s)
```

We begin with the definitions of `getGray` and `getRed` that will change the
font color of the selected symbols from our game board. This should look nice on
a standard, dark terminal display. Still, feel free to adjust the colors to your
needs (although if you use a terminal with a white background you may want to
stop it and get some help). Anyway, a field taken by one of the players
(`isTaken`) will be colored by `colorBoard`.

Personally, I would also opt to add the function for the triplets detection
(`isTriplet`). which we will use to color them (the first we find from the
`const lines`) with `colorFirstTriplet`. This should allow us for easier visual
determination when the game is over (later on we will also use it in
`isGameWon`).

```jl
s = """
function isTriplet(v::Vec{Str})::Bool
    @assert length(v) == 3 "length(v) must be equal 3"
    return join(v) == "XXX" || join(v) == "OOO"
end

function colorFirstTriplet(board::Vec{Str})::Vec{Str}
    result::Vec{Str} = copy(board)
    for line in lines
        if isTriplet(result[line])
            result[line] = getRed.(result[line])
            return result
        end
    end
    return result
end
"""
sc(s)
```

Notice, that neither `colorBoard`, nor `colorFirstTriplet` modify the original
game board, instead they produce a copy of it which is returned as a result.
