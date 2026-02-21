const Str = String
const Vec = Vector

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

function getProgressBar(perc::Int)::Str
    @assert 0 <= perc <= 100 "perc must be in range [0-100]"
    maxNumChars::Int = 50
    p::Int = round(Int, perc / (100 / maxNumChars))
    return "|" ^ p * "." ^ (maxNumChars-p) * " $perc%"
end

# the terminal must support ANSI escape codes
# https://en.wikipedia.org/wiki/ANSI_escape_code
function clearPrintout()::Nothing
    #"\033[xxxA" - xxx moves cursor up xxx lines
    print("\033[1A")
    # clears from cursor position till end of display
    print("\033[J")
    return nothing
end

function animateProgressBar()::Nothing
    delayMs::Int = 0
    fans::Vec{Str} = ["\\", "-", "/", "-"]
    ind::Int = 1
    for p in 0:100
        delayMs = rand(100:250)
        println(getProgressBar(p), " ", fans[ind])
        sleep(delayMs / 1000) # sleep accepts delay in seconds
        clearPrintout()
        ind = (ind == length(fans)) ? 1 : ind + 1
    end
    println(getProgressBar(100))
    return nothing
end

function main()::Nothing
    println("Toy program.")
    println("It animates a progress bar.")
    println("Note: your terminal must support ANSI escape codes.\n")

    # y(es) - default choice (also with Enter), anything else: no
    println("Continue with the animation? [Y/n]")
    choice::Str = readline()
    if lowercase(strip(choice)) in ["y", "yes", ""]
        animateProgressBar()
    end

    println("\nThat's all. Goodbye!")

    return nothing
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
