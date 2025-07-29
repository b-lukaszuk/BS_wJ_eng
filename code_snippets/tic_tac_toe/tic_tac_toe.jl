# TODO:
# Write a simple tic-tac-toe game
const Str = String
const Vec = Vector

function getNewGameBoard()::Vec{Str}
    return string.(1:9)
end

board = getNewGameBoard()
# lines to check for triplets
const lines = [
    [collect(i:(i+2)) for i in [1, 4, 7]]...,
    [collect(i:3:(i+6)) for i in [1, 2, 3]]...,
    [1, 5, 9], [3, 5, 7]
]

# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
function getGray(s::Str)::Str
    return "\x1b[90m" * s * "\x1b[0m"
end

function getDefault(s::Str)::Str
    return "\x1b[0m" * s
end

function getRed(s::Str)::Str
    return "\x1b[31m" * s * "\x1b[0m"
end

function colorBoard(board::Vec{Str})::Vec{Str}
    result::Vec{Str} = copy(board)
    for i in 1:9
        if !(board[i] in ["X", "O"])
            result[i] = getGray(board[i])
        end
    end
    return result
end

function isTriplet(v::Vec{Str})::Bool
    @assert length(v) == 3 "length(v) must be equal 3"
    return join(v) == "XXX" || join(v) == "OOO"
end

function colorFirstTriplet(board::Vec{Str})::Vec{Str}
    result::Vec{Str} = copy(board)
    for l in lines
        if isTriplet(result[l])
            result[l] = getRed.(result[l])
            return result
        end
    end
    return result
end

function clearLines(nLines::Int)
    @assert 0 < nLines "nLines must be a positive integer"
    #"\033[xxxA" - xxx moves cursor up xxx lines
    print("\033[" * string(nLines) * "A")
    # clear from cursor position till the end of the screen
    print("\033[0J")
end

function printBoard(board::Vec{Str})
    cb::Vec{Str} = colorBoard(board)
    cb = colorFirstTriplet(cb)
    for r in [1, 4, 7]
        println(" ", join(cb[r:(r+2)], " | "))
        println("---+---+---")
    end
    clearLines(1)
    return nothing
end

printBoard(board)
board[1] = "O"
board[5] = "X"
printBoard(board)
# board[4] = "O"
# board[7] = "O"
# printBoard(board)
# board[3] = "X"
# board[7] = "X"
# printBoard(board)
board[3] = "X"
board[6] = "X"
board[9] = "X"
printBoard(board)

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

# getUserMove(grid)

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

function isGameWon(gameBoard::Array{Int, 2})::Bool
    return isThreeInRow(gameBoard) || isThreeInCol(gameBoard) ||
        isThreeInDiag(gameBoard)
end

isGameWon(grid)

function isNoMoreMoves(gameBoard::Array{Int, 2})::Bool
    for n in 1:9
        if n in gameBoard
            return false
        end
    end
    return true
end

isNoMoreMoves(grid)

function isGameOver(gameBoard::Array{Int, 2})::Bool
    return isGameWon(gameBoard) || isNoMoreMoves(gameBoard)
end

isGameOver(grid)

function makeMove!(move::Int, player::Int, gameBoard::Array{Int, 2})
    @assert 0 < move < 10 "move must be in range [1-9]"
    @assert player in [100, 1_000] "player must be 100 | 1_000"
    nRows::Int, nCols::Int = size(grid)
    for c in 1:nCols, r in 1:nRows
        if gameBoard[r, c] == move
            gameBoard[r, c] = player
        end
    end
    return nothing
end

function makeMoveHuman!(move::Int, gameBoard::Array{Int, 2})
    makeMove!(move, 100, gameBoard)
end

function makeMoveComputer!(move::Int, gameBoard::Array{Int, 2})
    makeMove!(move, 1_000, gameBoard)
end

printGrid(grid)
makeMoveHuman!(3, grid)
printGrid(grid)

makeMoveComputer!(9, grid)
printGrid(grid)

function getComputerMove(gameBoard::Array{Int, 2})::Int
    for i in 1:9
        if i in gameBoard
            return i
        end
    end
    return 0
end

getComputerMove(grid)
makeMove!(1, 1_000, grid)
printGrid(grid)
getComputerMove(grid)

# to be corrected
function playRound!(gameBoard::Array{Int, 2})
    printGrid(gameBoard)
    usrMove::Int = getUserMove(gameBoard)
    makeMoveHuman!(usrMove, gameBoard)
    if isGameWon(gameBoard)
        clearLines(6)
        printGrid(gameBoard)
        println("Game Over. You win.")
        return nothing
    end
    if isNoMoreMoves(gameBoard)
        clearLines(6)
        printGrid(gameBoard)
        println("Game Over. Draw.")
        return nothing
    end

    clearLines(6)
    compMove::Int = getComputerMove(gameBoard)
    println("Your move: ", usrMove)
    println("Computer move: ", compMove)
    makeMoveComputer!(compMove, gameBoard)

    if isGameWon(gameBoard)
        clearLines(6)
        printGrid(gameBoard)
        println("Game Over. Computer wins.")
        return nothing
    end
    if isNoMoreMoves(gameBoard)
        clearLines(6)
        printGrid(gameBoard)
        println("Game Over. Draw.")
        return nothing
    end
end

playRound!(grid)
playRound!(grid)
