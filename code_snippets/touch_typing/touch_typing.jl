# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Flt = Float64
const Str = String
const Vec = Vector

# https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
function getGreen(c::Char)::Str
    return "\x1b[32m" * c * "\x1b[0m"
end

function getRed(c::Char)::Str
    return "\x1b[31m" * c * "\x1b[0m"
end

function isAbort(c::Char)::Bool
    return c == '\x03' || c == '\x04'
end

function isDelete(c::Char)::Bool
    return c == '\x08' || c == '\x7F'
end

function isEnter(c::Char)::Bool
    return c == '\x0D'
end

# by default sets cursor at (1, 1), i.e. top left corner
function setCursor(row::Int=1, col::Int=1)::Nothing
    @assert row >= 1 && col >= 1 "both row and col must be >= 1 "
    print("\x1b[", row, ";", col, "H")
    return nothing
end

# clears screen, sets cursor at (1, 1), i.e. top left corner
function clearScreen()::Nothing
    print("\x1b[", 1, "J") # clear from cursor to beginning of the screen
    setCursor()
    return nothing
end

function printColoredTxt(typedTxt::Str, referenceTxt::Str)::Nothing
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

# get cursor position
function getCursRowCol(typedTxt::Str, referenceTxt::Str)::Tuple{Int, Int}
    x::Int = 1 # position along x axis
    y::Int = 1 # position along y axis
    len1::Int = length(typedTxt)
    for i in eachindex(referenceTxt)
        if i > len1
            return (y, x)
        elseif referenceTxt[i] == '\n'
            y += 1
            x = 1
        else
            x += 1
        end
    end
    return (y, x)
end

# more info on stty, type in the terminal: man stty
# display current stty settings with: stty -a (or: stty --all)
function playTypingGame(text2beTyped::Str)::Str
    c::Char = ' '
    typedTxt::Str = ""
    clearScreen()
    println(text2beTyped)
    setCursor()
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
        setCursor()
        printColoredTxt(typedTxt, text2beTyped)
        row, col = getCursRowCol(typedTxt, text2beTyped)
        setCursor(row, col)
    end
    setCursor()
    printColoredTxt(typedTxt, text2beTyped)
    return typedTxt
end

function getAccuracy(typedTxt::Str, text2beTyped::Str)::Flt
    len1::Int = length(typedTxt)
    len2::Int = length(text2beTyped)
    @assert len1 <= len2 "len1 must be <= len2"
    correctlyTyped::Vec{Bool} = Vec{Bool}(undef, len1)
    for i in eachindex(correctlyTyped)
        correctlyTyped[i] = typedTxt[i] == text2beTyped[i]
    end
    return sum(correctlyTyped) / length(correctlyTyped)
end

function printSummary(typedTxt::Str, text2beTyped::Str, elapsedTimeSec::Flt)::Nothing
    wordLen::Int = 5 # avg. word length in English
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

function getTxtFromFile(filePath::Str)::Str
    fileTxt::Str = ""
    try
        fileTxt = open(filePath) do file
            read(file, Str)
        end
    catch
        fileTxt = "Couldn't read '$filePath', please make sure it exists."
    end
    return fileTxt
end

function getTxtFormatedForTyping(txt::Str, lineLen::Int=60)::Str
    @assert 40 <= lineLen <= 60 "lineLen must be in range [40-60]"
    words::Vec{Str} = split(txt)
    result::Str = ""
    curLineLen::Int = 0
    wordLen::Int = 0
    for w in words
        wordLen = length(w)
        if (curLineLen + wordLen + 1) >= lineLen
            result *= '\n' * w
            curLineLen = wordLen
        else
            result *= ' ' * w
            curLineLen += wordLen + 1
        end
    end
    return result[2:end] # 1st char is ' '
end

function isSttyPresent()::Bool
    try
        return success(`man stty`)
    catch
        return false
    end
end

function isAnsiColorsSupport()::Bool
    try
        nColors::Int = parse(Int, read(`tput colors`, String))
        return nColors >= 8
    catch
        return false
    end
end

function areRequirementsMet()::Bool
    requirementsMet::Bool = true
    println("Checking the requirements...")
    if !isAnsiColorsSupport()
        requirementsMet &= false
        println("Didn't detect suport for ANSI escape codes.")
    end
    if !isSttyPresent()
        requirementsMet &= false
        println("Didn't detect `stty` command.")
    end
    if requirementsMet
        println("Requirements seem to be met.\n")
    end
    return requirementsMet
end

function main()::Nothing

    println("\nHello. This is a toy program for touch typing.")
    println("It should work well on terminals that: ")
    println("- support ANSI escape codes,")
    println("- got stty.\n")

    if !areRequirementsMet()
        println("\nLeaving the program. Goodbye!\n")
        return nothing
    end

    println("Press Enter (or any key and Enter) and start typing")
    println("(While typing you may quit by pressing Ctrl+C or Ctrl+D).")
    println("Press q and Enter to quit now.")
    choice::Str = readline()

    if lowercase(strip(choice)) != "q"
        txt2type::Str = getTxtFromFile("./text2beTyped.txt")
        txt2type = getTxtFormatedForTyping(txt2type)
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
