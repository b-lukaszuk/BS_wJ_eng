function isLeap(yr::Int)::Bool
    @assert 0 < yr < 4000
    if yr % 4 != 0
        return false
    elseif yr % 25 != 0
        return true
    elseif yr % 16 != 0
        return false
    else
        return true
    end
end

yrs = [1792, 1859, 1900, 1918, 1974, 1985, 2000, 2012]
isLeap.(yrs)
filter(isLeap, yrs)
