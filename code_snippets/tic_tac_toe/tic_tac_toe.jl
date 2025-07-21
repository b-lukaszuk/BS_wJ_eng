# TODO:
# Write a simple tic-tac-toe game

# arr 1-9 is field index to display
# 100 is 'x'
# 1_000 is 'o'
grid = [1 2 3;
        4 5 6;
        7 8 9]

function getField(n::Int)::Char
    if n == 100
        return 'x'
    elseif n == 1_000
        return 'o'
    else
        return string(n)[1]
    end
end

function printGrid(g::Array{Int, 2})
    for r in eachrow(g)
        println(join(map(getField, r), "  "))
    end
    return nothing
end

printGrid(grid)
