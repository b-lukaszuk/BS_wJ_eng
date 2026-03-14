import Random as Rnd

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Flt = Float64
const Str = String
const Vec = Vector

## Regex Intro
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

txt = getTxtFromFile("./loremJohnSmith.txt");
println(txt)

function getAllMatches(rmi::Base.RegexMatchIterator)::Vec{Str}
    allMatches::Vec{RegexMatch} = collect(rmi)
    return isempty(allMatches) ? [] :
        [regMatch.match for regMatch in allMatches]
end

getAllMatches(eachmatch(r"John Smith", txt))

txt = replace(txt, r"John Smith" => "John S")
getAllMatches(eachmatch(r"John Smith", txt))

# in Julia strings are immutable
# to make changes permament write it to `txt` and/or to a file
txt = replace(txt, r"John Smith" => "John S")
eachmatch(r"John Smith", txt) |> getAllMatches

### Example 1
txt = getTxtFromFile("./loremDates.txt");
println(txt)

eachmatch(r"[0-9][0-9][0-9][0-9]", txt) |> getAllMatches
eachmatch(r"[0-9]{4}", txt) |> getAllMatches
eachmatch(r"\d{4}", txt) |> getAllMatches

### Example 2
txt = getTxtFromFile("./loremDollarsDates.txt");
println(txt)

eachmatch(r"\d.+\d", txt) |> getAllMatches
eachmatch(r"\d.+?\d", txt) |> getAllMatches
eachmatch(r"\d{1,}", txt) |> getAllMatches
eachmatch(r"\d{1,3}", txt) |> getAllMatches
eachmatch(r"$\d{1,}", txt) |> getAllMatches
getAllMatches(eachmatch(r"\$\d{1,}", txt))

getAllMatches(eachmatch(r"\$\d{1,}", txt)) |>
vecStrDollars -> replace.(vecStrDollars, "\$" => "") |>
vecStrNumbers -> parse.(Int, vecStrNumbers) |>
sum
