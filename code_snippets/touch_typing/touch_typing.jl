# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Flt = Float64
const Str = String
const Vec = Vector

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

function getColoredTxt(typedTxt::Str, referenceTxt::Str)::Str
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
function playTypingGame(text2beTyped::Str)::Str
    c::Char = ' '
    typedTxt::Str = ""
    run(`stty raw -echo`) # raw mode - reads single character immediately
    println("\n")
    while length(text2beTyped) > length(typedTxt)
        clearLines()
        println(getColoredTxt(typedTxt, text2beTyped), "\r")
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
    println(getColoredTxt(typedTxt, text2beTyped), "\r")
    run(`stty cooked echo`) # reset terminal default
    return typedTxt
end

function getAccuracy(typedTxt::Str, text2beTyped::Str)::Flt
    len::Int = length(typedTxt)
    correctlyTyped::Vec{Bool} = collect(typedTxt) .== collect(text2beTyped)
    return sum(correctlyTyped) / len
end

function printSummary(typedTxt::Str, text2beTyped::Str, elapsedTimeSec::Flt)
    wordLen::Int = 4
    secsPerMin::Int = 60
    txtLen::Int = length(typedTxt)
    cpm::Flt = txtLen / elapsedTimeSec * secsPerMin
    wpm::Flt = cpm / wordLen
    acc::Flt = getAccuracy(typedTxt, text2beTyped)
    println("\n---Summary---")
    println("Elapsed time: ", round(elapsedTimeSec, digits=2), " seconds")
    println("Characters per minute: ", round(cpm, digits=1))
    println("Words per minute: ", round(wpm, digits=1))
    println("Accuracy: ", round(acc * 100, digits=2), "%")
    return nothing
end

function main()

    txt2type = "Julia is awesome. Try it out in 2025, try it out later!"

    println("Hello. This is a toy program for touch typing.")
    println("To work correctly your terminal must support ANSI escape codes.\n")

    println("Press Enter (or any key and Enter) and start typing.")
    println("Press q to quit.")
    choice::Str = readline()
    typedTxt::Str = ""
    if lowercase(strip(choice)) != "q"
        timeStart::Flt = time()
        typedTxt = playTypingGame(txt2type)
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
