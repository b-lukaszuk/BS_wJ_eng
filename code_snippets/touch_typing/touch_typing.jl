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

function isDelete(c::Char)::Bool
    return c == '\x08' || c == '\x7F'
end

function isAbort(c::Char)::Bool
    return c == '\x03' || c == '\x04'
end

function clearLines(nLines::Int)
    @assert 0 < nLines "nLines must be a positive integer"
    print("\033[" * string(nLines) * "A")
    print("\033[0J")
    return nothing
end

function printColoredTxt(typedTxt::Str, referenceTxt::Str)
    len::Int = length(typedTxt)
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

function getNumOfLines(txt::Str)::Int
    return length(findall((==)('\n'), txt)) + 1
end

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

# s = "Julia is awesome.\nTry it out\nin 2025 and beyond!"
# for i in eachindex(s)
#     getXY(s[1:i], s) |> println
# end

# more info on stty, type in the terminal: man stty
# display current stty settings with: stty -a (or: stty --all)
function playTypingGame(text2beTyped::Str)::Str
    c::Char = ' '
    typedTxt::Str = ""
    nLines::Int = getNumOfLines(text2beTyped)
    println("\r", text2beTyped)
    while length(text2beTyped) > length(typedTxt)
        run(`stty raw -echo`) # raw mode - reads single character immediately
        c = read(stdin, Char) # read a character without Enter
        run(`stty cooked echo`) # reset to default behavior
        if isDelete(c)
            typedTxt = typedTxt[1:(end-1)]
        elseif isAbort(c)
            break
        else
            typedTxt *= c
        end
        clearLines(nLines)
        printColoredTxt(typedTxt, text2beTyped)
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
        txt2type::Str = "Julia is awesome.\nTry it out\nin 2025 and beyond!"
        timeStart::Flt = time()
        typedTxt::Str = playTypingGame(txt2type)
        timeEnd::Flt = time()
        # elapsedTimeSeconds::Flt = timeEnd - timeStart
        # printSummary(typedTxt, txt2type, elapsedTimeSeconds)
    end

    println("\nThat's all. Goodbye!")

    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
