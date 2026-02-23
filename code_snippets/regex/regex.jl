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
Rnd.seed!(009)
telNums = [join(Rnd.rand(string.(0:9), 9)) for _ in 1:3]

function getFmtTelNum(num::Str)::Str
    @assert map(isdigit, collect(num)) |> all "not a number"
    @assert length(num) == 9 "tel numbers have exactly 9 digits"
    return replace(
        num, r"^(\d{3})(\d{2})(\d{2})(\d{2})$" => s"\1-\2-\3-\4")
end

getFmtTelNum.(telNums)

