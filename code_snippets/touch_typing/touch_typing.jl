# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Flt = Float64
const Str = String
const Vec = Vector

# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
function getRed(s::Char)::Str
    return "\x1b[31m" * s * "\x1b[0m"
end

function getGreen(s::Char)::Str
    return "\x1b[32m" * s * "\x1b[0m"
end

function getColoredTxt(typedTxt::Str, referenceTxt::Str)::Str
    result::Str = ""
    len::Int = length(typedTxt)
    for i in eachindex(referenceTxt)
        if i > len
            result *= referenceTxt[i]
        elseif typedTxt[i] == referenceTxt[i]
            result *= getGreen(referenceTxt[i])
        else
            result *= getRed(referenceTxt[i])
        end
    end
    return result
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
    cursorCol::Int = 1
    run(`stty raw -echo`) # raw mode - reads single character immediately
    while length(text2beTyped) > length(typedTxt)
        print("\r", getColoredTxt(typedTxt, text2beTyped))
        print("\x1b[", cursorCol, "G") # mv curs to cursorCol
        c = read(stdin, Char) # read a character without Enter
        if isDelete(c)
            typedTxt = typedTxt[1:(end-1)]
        elseif isAbort(c)
            break
        else
            typedTxt *= c
        end
        cursorCol = length(typedTxt) + 1
    end
    println("\r", getColoredTxt(typedTxt, text2beTyped))
    run(`stty cooked echo`) # reset to default behavior
    return typedTxt
end

function getAccuracy(typedTxt::Str, text2beTyped::Str)::Flt
    len1::Int = length(typedTxt)
    len2::Int = length(text2beTyped)
    @assert len1 <= len2 "len1 must be <= len2"
    correctlyTyped::Vec{Bool} = zeros(Bool, len1)
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
    println("\n---Summary---")
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
        txt2type::Str = "Julia is awesome. Try it out in 2025 and beyond!"
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
