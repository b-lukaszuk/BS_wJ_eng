# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Str = String

const TXT = "Julia is awesome. Try it out in 2025, try it out later!"

# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
function getRed(s::Str)::Str
    # "\x1b[31m" sets forground color to red
    # "\x1b[0m" resets forground color to default value
    return "\x1b[31m" * s * "\x1b[0m"
end

function getGreen(s::Str)::Str
    # "\x1b[32m" sets forground color to red
    # "\x1b[0m" resets forground color to default value
    return "\x1b[32m" * s * "\x1b[0m"
end

function getColoredTxt(typedTxt::Str, referenceTxt::Str=TXT)::Str
    result::Str = ""
    len::Int = length(typedTxt)
    for i in eachindex(referenceTxt)
        if i > len
            result *= referenceTxt[i]
        elseif typedTxt[i] == referenceTxt[i]
            result *= getGreen(string(referenceTxt[i]))
        else
            result *= getRed(string(referenceTxt[i]))
        end
    end
    return result
end

# https://en.wikipedia.org/wiki/ANSI_escape_code
function clearLines(nLines::Int=1)
    @assert 0 < nLines "nLines must be a positive integer"
    # "\033[xxxA" - xxx moves cursor up xxx LINES
    print("\033[", nLines, "A")
    # "\033[0J" - clears from cursor position till the end of the screen
    print("\033[0J")
    return nothing
end

function isDelete(c::Char)::Bool
    return c == '\x08' || c == '\x7F'
end

function isAbort(c::Char)::Bool
    return c == '\x03' || c == '\x04'
end

# more info on stty, type in the terminal: man stty
# display current stty settings with: stty -a (or: stty --all)
function playTypingGame()
    c::Char = ' '
    typedTxt::Str = ""
    run(`stty raw -echo`) # raw mode - reads single character immediately
    println("\n")
    while length(TXT) > length(typedTxt)
        clearLines()
        println(getColoredTxt(typedTxt), "\r")
        c = read(stdin, Char)  # read a character without Enter
        if isDelete(c)
            typedTxt = typedTxt[1:(end-1)]
        elseif isAbort(c)
            break
        else
            typedTxt *= c
        end
    end
    clearLines()
    println(getColoredTxt(typedTxt), "\r")
    run(`stty cooked echo`) # reset terminal default
    return nothing
end

function main()
    println("Hello. This is a toy program for touch typing.\n")

    println("Press Enter (or any key and Enter) and start typing.")
    println("Press Ctrl-C to abort.")
    println("Note: your terminal must support ANSI escape codes.")
    choice::Str = readline() * " "
    if !isAbort(choice[1])
        playTypingGame()
    end

    println("\nThat's all. Goodbye!")

    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
