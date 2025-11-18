# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Str = String

const TXT = "julia is awesome"

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
function clearLines(nLines::Int)
    @assert 0 < nLines "nLines must be a positive integer"
    # "\033[xxxA" - xxx moves cursor up xxx LINES
    print("\033[", nLines, "A")
    # "\033[0J" - clears from cursor position till the end of the screen
    print("\033[0J")
    return nothing
end

# more info on stty, type in the terminal: man stty
# display current stty settings with: stty -a (or: stty --all)
function playTypingGame()
    println("Start typing the text:")
    c::Char = ' '
    typedTxt::Str = ""
    run(`stty raw -echo`) # raw mode - reads single character immediately
    while length(TXT) > length(typedTxt)
        clearLines(1)
        println(getColoredTxt(typedTxt))
        print("\r")
        c = read(stdin, Char)  # read a character without Enter
        typedTxt *= c
    end
    clearLines(1)
    println(getColoredTxt(typedTxt))
    print("\r")
    run(`stty cooked echo`) # reset terminal default
end

playTypingGame()
