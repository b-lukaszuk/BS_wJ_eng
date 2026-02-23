# TODO regex
# https://docs.julialang.org/en/v1/manual/strings/#man-regex-literals
# https://regex101.com/
# https://www.pcre.org/current/doc/html/pcre2syntax.html
# https://en.wikiversity.org/wiki/Regular_expressions

import Random as Rnd

const Flt = Float64
const Str = String

Rnd.seed!(009)
telNums = [join(Rnd.rand(string.(0:9), 9)) for _ in 1:3]

function getFmtTelNum(num::Str)::Str
    @assert map(isdigit, collect(num)) |> all "not a number"
    @assert length(num) == 9 "tel numbers have exactly 9 digits"
    return replace(
        num, r"^(\d{3})(\d{2})(\d{2})(\d{2})$" => s"\1-\2-\3-\4")
end

getFmtTelNum.(telNums)
