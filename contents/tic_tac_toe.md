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

The two are: `players`, a vector with marks used by each of the players (`"X"` -
human, `"O"` - computer) and the coordinates of `lines` in our game board that
we need to check to see if a player won the game. You could probably be more
clever and use
[enums](https://docs.julialang.org/en/v1/base/base/#Base.Enums.Enum) for the
players and list comprehensions for our lines (e.g.,
`[collect(i:(i+2)) for i in [1, 4, 7]]` to get the rows),
but for such a simple case it might be overkill.

OK, time to format the board.

```jl
s = """
# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
function getGray(s::Str)::Str
    # "\\x1b[90m" sets forground color to gray
    # "\\x1b[0m" resets forground color to default value
    return "\\x1b[90m" * s * "\\x1b[0m"
end

function isTaken(field::Str)::Bool
    return field in players
end

function colorFieldNumbers(board::Vec{Str})::Vec{Str}
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

We begin with the definition of `getGray` that will change the
font color of the selected symbols from our game board. This should look nice on
a standard, dark terminal display. Still, feel free to adjust the color to your
needs (although if you use a terminal with a white background you may want to
stop it and get some help). Anyway, a field not taken by one of the players
(`!isTaken`) will be colored by `colorFieldNumbers`.

Personally, I would also opt to add the function for the triplets detection
(`isTriplet`). which we will use to color them (the first we find based on
`const lines`) with `colorFirstTriplet`. This should allow us for easier visual
determination when the game is over (later on we will also use it in
`isGameWon`).

```jl
s = """
# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
function getRed(s::Str)::Str
    # "\\x1b[31m" sets forground color to red
    # "\\x1b[0m" resets forground color to default value
    return "\\x1b[31m" * s * "\\x1b[0m"
end

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

Notice, that neither `colorFieldNumbers`, nor `colorFirstTriplet` modify the
original game board, instead they produce a copy of it which is returned as a
result.

Now, we are ready to print.

```jl
s = """
# https://en.wikipedia.org/wiki/ANSI_escape_code
function clearLines(nLines::Int)
    @assert 0 < nLines "nLines must be a positive integer"
    # "\033[xxxA" - xxx moves cursor up xxx lines
    print("\033[" * string(nLines) * "A")
    # "\033[0J" - clears from cursor position till the end of the screen
    print("\033[0J")
	return nothing
end

function printBoard(board::Vec{Str})
    bd::Vec{Str} = colorFieldNumbers(board)
    bd = colorFirstTriplet(bd)
    for r in [1, 4, 7]
        println(" ", join(bd[r:(r+2)], " | "))
        println("---+---+---")
    end
    clearLines(1)
    return nothing
end
"""
sc(s)
```

First, we declare `clearLines`, it will help us to tidy the printout (e.g.,
while playing the game we will have to redraw the game board a couple of times).
Next, we proceed with `printBoard`. Here, we color the board with the previously
defined functions and move row by row (`[1, 4, 7]` are the indicies that mark
the beginnings of each row). We `join` the contents of a row together (we
glue them with `" | "`) and print it (`println`). We follow it by a row
separator (`println("---+---+---")`). Once we're finished we remove the last row
separator (`"---+---+---"`) (we do not want it, but it was printed because we
were too lazy to add an if statement in our for loop).

So far, so good, time to handle a human player's (aka user's) move.

```jl
s = """
function getUserInput(prompt::Str)::Str
    print(prompt)
    input::Str = readline()
    return strip(input)
end

function isMoveLegal(move::Str, board::Vec{Str})::Bool
    num::Int = 0
    try
        num = parse(Int, move)
    catch
        return false
    end
    return (0 < num < 10) && !isTaken(board[num])
end

function getUserMove(gameBoard::Vec{Str})::Int
    input::Str = getUserInput("Enter your move: ")
    while true
        if isMoveLegal(input, gameBoard)
            break
        end
        clearLines(1)
        input = getUserInput("Illegal move. Try again. Enter your move: ")
    end
    return parse(Int, input)
end
"""
sc(s)
```

We begin with `getUserInput` a function that prints the `prompt` (it tells the
user what to do), prints it, and accepts the user's input (`readline`) that is
returned as a result (after `strip`ing them from space/tab/new line characters
that may be on the edges). Next, we make sure that the move made
