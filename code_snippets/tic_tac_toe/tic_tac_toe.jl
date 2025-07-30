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

function isTaken(field::Str)::Bool
    return field == "X" || field == "O"
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

function isMoveLegal(move::Str, board::Vec{Str})::Bool
    num::Int = 0
    try
        num = parse(Int, move)
    catch
        return false
    end
    return (0 < num < 10) && !isTaken(board[num])
end

isMoveLegal("", board)
isMoveLegal("ala", board)
isMoveLegal("33", board)
isMoveLegal("3.3", board)
isMoveLegal("3.0", board)
isMoveLegal("2.0", board)
isMoveLegal("3", board)
isMoveLegal("2", board)
isMoveLegal("5 ", board)

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

getUserMove(board)

function isGameWon(board::Vec{Str})::Bool
    for line in lines
        if isTriplet(board[line])
            return true
        end
    end
    return false
end

isGameWon(board)

function isNoMoreMoves(board::Vec{Str})::Bool
    for i in 1:9
        if !isTaken(board[i])
            return false
        end
    end
    return true
end

isNoMoreMoves(board)

function isGameOver(board::Vec{Str})::Bool
    return isGameWon(board) || isNoMoreMoves(board)
end

isGameOver(board)

function makeMove!(move::Int, player::Str, board::Vec{Str})
    @assert 0 < move < 10 "move must be in range [1-9]"
    @assert isTaken(player) "player must be X or O"
    if !isTaken(board[move])
        board[move] = player
    end
    return nothing
end

function makeMoveHuman!(move::Int, board::Vec{Str})
    makeMove!(move, "X", board)
end

function makeMoveComputer!(move::Int, board::Vec{Str})
    makeMove!(move, "O", board)
end

printBoard(board)
makeMoveHuman!(3, board)
printBoard(board)
makeMoveHuman!(7, board)
printBoard(board)

makeMoveComputer!(9, board)
printBoard(board)
makeMoveComputer!(8, board)
printBoard(board)

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
printBoard(grid)
getComputerMove(grid)

# to be corrected
function playRound!(gameBoard::Array{Int, 2})
    printBoard(gameBoard)
    usrMove::Int = getUserMove(gameBoard)
    makeMoveHuman!(usrMove, gameBoard)
    if isGameWon(gameBoard)
        clearLines(6)
        printBoard(gameBoard)
        println("Game Over. You win.")
        return nothing
    end
    if isNoMoreMoves(gameBoard)
        clearLines(6)
        printBoard(gameBoard)
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
        printBoard(gameBoard)
        println("Game Over. Computer wins.")
        return nothing
    end
    if isNoMoreMoves(gameBoard)
        clearLines(6)
        printBoard(gameBoard)
        println("Game Over. Draw.")
        return nothing
    end
end

playRound!(grid)
playRound!(grid)
