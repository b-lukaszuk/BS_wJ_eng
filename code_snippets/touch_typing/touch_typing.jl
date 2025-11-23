# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Flt = Float64
const Str = String
const Vec = Vector

# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
function getRed(c::Char)::Str
    return "\x1b[31m" * c * "\x1b[0m"
end

function getGreen(c::Char)::Str
    return "\x1b[32m" * c * "\x1b[0m"
end

function isDelete(c::Char)::Bool
    return c == '\x08' || c == '\x7F'
end

function isAbort(c::Char)::Bool
    return c == '\x03' || c == '\x04'
end

function isEnter(c::Char)::Bool
    return c == '\x0D'
end

function setCursor(row::Int=1, col::Int=1)
    @assert row >= 1 && col >= 1 "both row and col must be >= 1 "
    print("\x1b[", row, ";", col, "H") # set cursor at row, col (top left; 1, 1)
    return nothing
end

# clears terminal printout
# 1 - clear from cursor to beginning of screen
# 2 - clear entire screen, move cursor to top left corner
function clearScreen(n::Int)
    @assert n in [1, 2] "n must be 1 or 2"
    print("\x1b[", n, "J")
    setCursor()
    return nothing
end

function printColoredTxt(typedTxt::Str, referenceTxt::Str)
    len::Int = length(typedTxt)
    # print("\r")
    for i in eachindex(referenceTxt)
        if i > len
            print(referenceTxt[i])
        elseif typedTxt[i] == referenceTxt[i]
            print(getGreen(referenceTxt[i]))
        else
            print(getRed(referenceTxt[i]))
        end
    end
    println()
    return nothing
end

# get cursor position on XY axis
function getXY(typedTxt::Str, referenceTxt::Str)::Tuple{Int, Int}
    x::Int = 1
    y::Int = 1
    len1::Int = length(typedTxt)
    for i in eachindex(referenceTxt)
        if i > len1
            return (x, y)
        elseif referenceTxt[i] == '\n'
            y += 1
            x = 1
        else
            x += 1
        end
    end
    return (x, y)
end

# more info on stty, type in the terminal: man stty
# display current stty settings with: stty -a (or: stty --all)
function playTypingGame(text2beTyped::Str)::Str
    c::Char = ' '
    typedTxt::Str = ""
    clearScreen(2)
    println(text2beTyped)
    setCursor(1, 1)
    while length(text2beTyped) > length(typedTxt)
        run(`stty raw -echo`) # raw mode - reads single character immediately
        c = read(stdin, Char) # read a character without Enter
        run(`stty cooked echo`) # reset to default behavior
        if isDelete(c)
            typedTxt = typedTxt[1:(end-1)]
        elseif isAbort(c)
            break
        elseif isEnter(c)
            typedTxt *= '\n'
        else
            typedTxt *= c
        end
        clearScreen(1)
        printColoredTxt(typedTxt, text2beTyped)
        x, y = getXY(typedTxt, text2beTyped)
        setCursor(y, x)
    end
    return typedTxt
end

function getAccuracy(typedTxt::Str, text2beTyped::Str)::Flt
    len1::Int = length(typedTxt)
    len2::Int = length(text2beTyped)
    @assert len1 <= len2 "len1 must be <= len2"
    correctlyTyped::Vec{Bool} = Vec{Bool}(undef, len1)
    for i in 1:len1
        correctlyTyped[i] = typedTxt[i] == text2beTyped[i]
    end
    return sum(correctlyTyped) / len1
end

function printSummary(typedTxt::Str, text2beTyped::Str, elapsedTimeSec::Flt)
    wordLen::Int = 4
    secsPerMin::Int = 60
    len1::Int = length(typedTxt)
    len2::Int = length(text2beTyped)
    cpm::Flt = len1 / elapsedTimeSec * secsPerMin
    wpm::Flt = cpm / wordLen
    acc::Flt = getAccuracy(typedTxt, text2beTyped)
    println("\n\n---Summary---")
    println("Elapsed time: ", round(elapsedTimeSec, digits=2), " seconds")
    println("Typed characters: $len1/$len2")
    println("Characters per minute: ", round(cpm, digits=1))
    println("Words per minute: ", round(wpm, digits=1))
    println("Accuracy: ", round(acc * 100, digits=2), "%")
    return nothing
end

function main()

    println("Hello. This is a toy program for touch typing.")
    println("It should work well on terminals that support ANSI escape codes.\n")

    println("Press Enter (or any key and Enter) and start typing.")
    println("Press q and Enter to quit now.")
    choice::Str = readline()

    if lowercase(strip(choice)) != "q"
        txt2type::Str = "Julia is awesome.\nTry it out\nin 2025 and beyond!"
        timeStart::Flt = time()
        typedTxt::Str = playTypingGame(txt2type)
        timeEnd::Flt = time()
        elapsedTimeSeconds::Flt = timeEnd - timeStart
        printSummary(typedTxt, txt2type, elapsedTimeSeconds)
    end

    println("\nThat's all. Goodbye!")

    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
