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

> Note. Using `const` with mutable containers like vectors or dictionaries
> allows to change their contents in the future, e.g., with `push!`. So the
> `const` used here is more like a convention, a signal that we do not plan to
> change the containers in the future. If we really wanted an immutable
> container then we should consider a(n) (immutable) tuple.

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
    for i in eachindex(board)
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
    # "\\033[xxxA" - xxx moves cursor up xxx lines
    print("\\033[" * string(nLines) * "A")
    # "\\033[0J" - clears from cursor position till the end of the screen
    print("\\033[0J")
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
    while !isMoveLegal(input, gameBoard)
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
that may be on the edges).

Next, we make sure that the move made by the user is legal (`isMoveLegal`),
i.e. can it be correctly converted to integer (`parse(Int, move)`), is it in the
acceptable range (`0 < num < 10`) and is the field free to place the player's
mark (`!isTaken(board[num])`). Notice, the use of `try` and `catch`
construct. First we `try` to make an integer out of the string obtained from the
user (`parse(Int, move)`). This may fail (e.g., because we got the letter `"a"`
instead of the number `"2"`). Such a failure, will result in an error that will
terminate the program execution. We don't want that to happen, so we `catch` a
possible error and instead of terminating the program, we just `return
false`. If the `try` succeeds, we skip the `catch` part and go straight to the
next statement after the `try`-`catch` block
(`return (0 < num < 10) && !isTaken(board[num])`) that we already discussed.

Finally, we declare `getUserMove` a function that asks the user for a move and
is quite persistent about it. If the user gave a correct move the first time
(`input::Str = getUserInput("Enter your move: ")`) then the while loop condition
(`!isMoveLegal(input, gameBoard)`) is false and the loop isn't executed at all
(we move to the return statement). However, if the user plays tricks on us and
want to smuggle an illegal move (or maybe just did it absent-mindedly) then the
condition (`!isMoveLegal(input, gameBoard)`) is true and `while` it is we nag
them for a correct move (`"Illegal move. Try again. Enter your move: "`).

> Note. Using `while` loop always carries a risk of it being infinite, that's
> why it is worth to know that you can always press
> [Ctrl+C](https://en.wikipedia.org/wiki/Control-C) that should terminate the
> program execution.

OK, and how about a computer move.

```jl
s = """
function getComputerMove(board::Vec{Str})::Int
    move::Int = 0
    for i in eachindex(board)
        if !isTaken(board[i])
            move = i
            break
        end
    end
    println("Computer plays: ", move)
    return move
end
"""
sc(s)
```

We start small, `getComputerMove` will simply walk through the board and return
an index (`i`) of a first empty, i.e., not taken by a player
(`!isTaken(board[i])`) field. If all the fields are taken it will return `0`
(but this will not be a problem as we will see afterwards). Since `getUserMove`
prints one line of a screen output, then so does `getComputerMove`
(`println("Computer plays: ", move)`) for compatibility.

Time to actually make a move that we obtained for a player.

```jl
s = """
function makeMove!(move::Int, player::Str, board::Vec{Str})
    @assert 0 < move < 10 "move must be in range [1-9]"
    @assert player in players "player must be X or O"
    if !isTaken(board[move])
        board[move] = player
    end
    return nothing
end
"""
sc(s)
```

For that we just take the `move`, a `player` for whom we place a mark and the
game `board` that we will modify. If a given field isn't taken
(`if !isTaken(board[move])`, or to put it differently, it's free to take) we
just put the mark for a player there (`board[move] = player`).
