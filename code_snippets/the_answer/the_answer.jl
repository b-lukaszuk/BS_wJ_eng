# TODO the_answer

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Str = String

const CHARS = "0123456789abcdef" |> collect
const MIN_BASE = 2
const MAX_BASE = 16

function isBaseN(num::Char, n::Int)::Bool
    @assert MIN_BASE <= n <= MAX_BASE "n not in [$MIN_BASE - $MAX_BASE]"
    return num in CHARS[1:n]
end

function isBaseN(num::Str, n::Int)::Bool
    return isBaseN.(collect(num), n) |> all
end

isBaseN("111", 2)
isBaseN("1121", 2)
