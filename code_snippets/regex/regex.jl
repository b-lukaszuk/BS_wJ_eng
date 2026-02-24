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

