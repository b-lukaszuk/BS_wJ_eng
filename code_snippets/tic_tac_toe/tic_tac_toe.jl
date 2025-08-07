const Str = String
const Vec = Vector

const players = ["X", "O"]
const lines = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    [1, 4, 7],
    [2, 5, 8],
    [3, 6, 9],
    [1, 5, 9],
    [3, 5, 7],
]

function getNewGameBoard()::Vec{Str}
    return string.(1:9)
end

# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
function getGray(s::Str)::Str
    # "\x1b[90m" sets forground color to gray
    # "\x1b[0m" resets forground color to default value
    return "\x1b[90m" * s * "\x1b[0m"
end

function isTaken(field::Str)::Bool
    return field in players
end

function getRed(s::Str)::Str
    # "\x1b[31m" sets forground color to red
    return "\x1b[31m" * s * "\x1b[0m"
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
    return (num in eachindex(board)) && !isTaken(board[num])
end

function getUserMove(gameBoard::Vec{Str})::Int
    input::Str = getUserInput("Enter your move: ")
    while !isMoveLegal(input, gameBoard)
        clearLines(1)
        input = getUserInput("Illegal move. Try again. Enter your move: ")
    end
    return parse(Int, input)
end

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

function makeMove!(move::Int, player::Str, board::Vec{Str})
    @assert move in eachindex(board) "move must be in range [1-9]"
    @assert player in players "player must be X or O"
    if !isTaken(board[move])
        board[move] = player
    end
    return nothing
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
    for i in eachindex(board)
        if !isTaken(board[i])
            return false
        end
    end
    return true
end

function isGameDraw(board::Vec{Str})::Bool
    return !isGameWon(board) && isNoMoreMoves(board)
end

function playMove!(player::Str, board::Vec{Str})
    @assert player in players "player must be X or O"
    clearLines(5)
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

function main()
    println("This is a toy program to play a tic-tac-toe game.")
    println("Note: your terminal must support ANSI escape codes.\n")

    # y(es) - default choice (also with Enter), anything else: no
    println("Continue with the game? [Y/n]")
    choice::Str = readline()
    if lowercase(strip(choice)) in ["y", "yes", ""]
        playGame()
    end

    println("\nThat's all. Goodbye!")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
