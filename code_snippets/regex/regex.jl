# TODO regex
# https://docs.julialang.org/en/v1/manual/strings/#man-regex-literals
# https://regex101.com/
# https://www.pcre.org/current/doc/html/pcre2syntax.html
# https://en.wikiversity.org/wiki/Regular_expressions
# https://docs.julialang.org/en/v1/base/strings/#Base.replace-Tuple{IO,%20AbstractString,%20Vararg{Pair}}
# https://docs.julialang.org/en/v1/base/strings/#Base.eachmatch
import Random as Rnd

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Flt = Float64
const Str = String
const Vec = Vector

# e/t 1
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
txt = getTxtFromFile("./loremJohnSmith.txt")

function getAllMatches(rmi::Base.RegexMatchIterator)::Vec{Str}
    allMatches::Vec{RegexMatch} = collect(rmi)
    return isempty(allMatches) ? [] :
        [regMatch.match for regMatch in allMatches]
end

getAllMatches(eachmatch(r"John Smith", txt))
txt = replace(txt, r"John Smith" => "John S.")
getAllMatches(eachmatch(r"John Smith", txt))

# e/t 2
txt = getTxtFromFile("./loremDates.txt")

yrRegs = [r"[0-9][0-9][0-9][0-9]", r"[0-9]{4}", r"\d{4}"]

getAllMatches(eachmatch(yrRegs[1], txt))
getAllMatches(eachmatch(yrRegs[2], txt))
getAllMatches(eachmatch(yrRegs[3], txt))

# e/t 3
txt = getTxtFromFile("./loremDollarsDates.txt")

getAllMatches(eachmatch(r"\d.+\d", txt))
getAllMatches(eachmatch(r"\d.+?\d", txt))
getAllMatches(eachmatch(r"\d{1,}", txt))
getAllMatches(eachmatch(r"$\d{1,}", txt))
getAllMatches(eachmatch(r"\$\d{1,}", txt))

getAllMatches(eachmatch(r"\$\d{1,4}", txt)) |>
vecStrDollars -> replace.(vecStrDollars, "\$" => "") |>
vecStrNumbers -> parse.(Int, vecStrNumbers) |>
sum

# e/t 4
datesMMDDYYYY = [
   "01042025",
   "11012018",
   "12311999",
]

# extract year only
replace.(datesMMDDYYYY, r"^\d{4}" => "")

# convert to yyyymmdd
replace.(datesMMDDYYYY, r"(\d{2})(\d{2})(\d{4})" => s"\3\1\2")
replace.(datesMMDDYYYY, r"(\d{2})(\d{2})(\d{4})" => s"\3-\1-\2")

# e/t 5
camelCasedWords = ["helloWorld", "niceToMeetYou", "translateToEnglish"]
# funny, Julia allows for \1 (captures) but not \l (lowercase) from pcre2
# replace.(camelCasedWords, r"([A-Z])" => s"\l\1")
# no biggie, we'll do it with an anonymous function
replace.(camelCasedWords, r"([A-Z])" => AtoZ -> "_$(lowercase(AtoZ))")
replace.(camelCasedWords, r"([A-Z])" => AtoZ -> "_" * lowercase(AtoZ))

snakeCasedWords = ["hello_world", "nice_to_meet_you", "translate_to_english"]
replace.(snakeCasedWords, r"_[a-z]" => _atoz -> uppercase(_atoz[2:end]))

# e/t 6
Rnd.seed!(009)
telNums = [join(Rnd.rand(string.(0:9), 9)) for _ in 1:3]

function getFmtTelNum(num::Str)::Str
    @assert map(isdigit, collect(num)) |> all "not a number"
    @assert length(num) == 9 "tel numbers have exactly 9 digits"
    return replace(
        num, r"^(\d{3})(\d{2})(\d{2})(\d{2})$" => s"\1-\2-\3-\4")
end

getFmtTelNum.(telNums)

# e/t 7
txt = getTxtFromFile("./loremMail.txt")

mailReg = r"[a-z0-9.]+@[a-z0-9.]+"
getAllMatches(eachmatch(mailReg, txt)) |> unique

# e/t 8
means_sds = ["100,15", "25,2.5", "88,8.0"]
replace.(means_sds, r"(\d{1,}),(\d{1,})" => s"mean = \1, sd = \2")

# e/t 9
firstNameOption = ["Peter", "Adam", "Tom", "John", "Jane", "Eve", "Mary"]
lastNameOption = ["Smith", "Doe", "Brown", "Johnson"]

function getRandName(n::Int = 3,
                     first::Vec{Str}=firstNameOption,
                     last::Vec{Str}=lastNameOption)::Vec{Str}
    @assert n > 0 "n must be > 0"
    result::Vec{Str} = []
    parts::Vec{Str} = []
    for _ in 1:n
        parts = [Rnd.rand(first), Rnd.rand(last)]
        push!(result, join(parts, " "))
    end
    return result
end

Rnd.seed!(824)
firstLastNames = getRandName()
replace.(firstLastNames, r"([A-z]+) ([A-z]+)" => s"\2 \1")

