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

function isGameWon(board::Vec{Str})::Bool
    for line in lines
        if isTriplet(board[line])
            return true
        end
    end
    return false
end

function isNoMoreMoves(board::Vec{Str})::Bool
    for i in 1:9
        if !isTaken(board[i])
            return false
        end
    end
    return true
end

function isGameDraw(board::Vec{Str})::Bool
    return !isGameWon(board) && isNoMoreMoves(board)
end

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

function getComputerMove(board::Vec{Str})::Int
    move::Int = 0
    for i in 1:9
        if !isTaken(board[i])
            move = i
            break
        end
    end
    println("Computer plays: ", move)
    return move
end

function playMove!(player::Str, board::Vec{Str})
    @assert isTaken(player) "player must be X or O"
    clearLines(6)
    printBoard(board)
    move::Int = (player == "X") ? getUserMove(board) : getComputerMove(board)
    makeMove!(move, player, board)
    clearLines(6)
    printBoard(board)
    if isGameWon(board)
        println("Game Over. ", player == "X" ? "You" : "Computer", " won.")
    end
    if isGameDraw(board)
        println("Game Over. Draw.")
    end
    return nothing
end

function playGame()
    player::Str = "X"
    board::Vec{Str} = getNewGameBoard()
    isOver::Bool = isGameWon(board) || isGameDraw(board)
    while !isOver
        playMove!(player, board)
        player = player == "X" ? "O" : "X"
        isOver = isGameWon(board) || isGameDraw(board)
    end
    return nothing
end

playGame()
