# TODO:
# Write a simple tic-tac-toe game
const Str = String
const Vec = Vector

# arr 1-9 is field index to display
# 100 is 'x'
# 1_000 is 'o'
grid = [1 2 3;
        4 5 6;
        7 8 9]

function getField(n::Int)::Str
    if n == 100
        return "x"
    elseif n == 1_000
        return "o"
    else
        # https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
        # "\x1b[90m" - FG light black (gray)
        # "\x1b[0m" - reset color to default
        return "\x1b[90m" * string(n) * "\x1b[0m"
    end
end

function printGrid(g::Array{Int, 2})
    for (rowIndex, row) in enumerate(eachrow(g))
        println(" " * join(map(getField, row), " | "))
        if rowIndex < 3
            println("---+---+---")
        end
    end
    return nothing
end

printGrid(grid)

grid = [1 100 3;
        4 100 6;
        1_000 1_000 9]
printGrid(grid)

function getUserInput(prompt::Str)::Str
    print(prompt)
    input::Str = readline()
    return strip(input)
end

function isMoveLegal(move::Str, gameBoard::Array{Int, 2})::Bool
    num::Int = 0
    try
        num = parse(Int, move)
    catch
        return false
    end
    return (0 < num < 10) && (num in gameBoard)
end

isMoveLegal("", grid)
isMoveLegal("ala", grid)
isMoveLegal("33", grid)
isMoveLegal("3.3", grid)
isMoveLegal("3.0", grid)
isMoveLegal("3", grid)
isMoveLegal("5 ", grid)

function clearLines(nLines::Int)
    @assert 0 < nLines "nLines must be a positive integer"
    #"\033[xxxA" - xxx moves cursor up xxx lines
    print("\033[" * string(nLines) * "A")
    # clear from cursor position till the end of the screen
    print("\033[0J")
end

function getUserMove(gameBoard::Array{Int, 2})::Int
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

getUserMove(grid)

function isThreeInRow(gameBoard::Array{Int, 2})::Bool
    total::Int = 0
    for r in eachrow(gameBoard)
        total = sum(r)
        if total == 300 || total == 3_000
            return true
        end
    end
    return false
end

function isThreeInCol(gameBoard::Array{Int, 2})::Bool
    total::Int = 0
    for c in eachcol(gameBoard)
        total = sum(c)
        if total == 300 || total == 3_000
            return true
        end
    end
    return false
end

isThreeInRow(grid)
isThreeInCol(grid)

function getDiags(gameBoard::Array{Int, 2})::Tuple{Vec{Int}, Vec{Int}}
    return (
        [gameBoard[r, c] for (r, c) in zip(1:3, 1:3)],
        [gameBoard[r, c] for (r, c) in zip(1:3, 3:-1:1)]
    )
end
getDiags(grid)

function isThreeInDiag(gameBoard::Array{Int, 2})::Bool
    total::Int = 0
    diags::Tuple{Vec{Int}, Vec{Int}} = getDiags(gameBoard)
    for diag in diags
        total = sum(diag)
        if total == 300 || total == 3_000
            return true
        end
    end
    return false
end

isThreeInDiag(grid)

function isTriplet(gameBoard::Array{Int, 2})::Bool
    return isThreeInRow(gameBoard) || isThreeInCol(gameBoard) ||
        isThreeInDiag(gameBoard)
end

isTriplet(grid)
