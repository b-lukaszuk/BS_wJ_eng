import DataFrames as Dfs
import Random as Rnd

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Flt = Float64
const Vec = Vector

# TODO extend the solutions for 5 and 7 doors scenarios
###############################################################################
#                                  solution 1                                 #
###############################################################################
df = Dfs.DataFrame(Dict("Door" => 1:3))
df.prior = repeat([1//3], 3) # 1//3 is Rational (a fraction)
df

df.likelihood = [1//2, 1, 0]
df

function bayesUpdate!(df::Dfs.DataFrame)::Nothing
    unnorm = df.prior .* df.likelihood
    df.posterior = unnorm ./ sum(unnorm)
    return nothing
end

bayesUpdate!(df)
df # to see Rationals as floats: convert.(Flt, df.posterior)

###############################################################################
#                                  solution 2                                 #
###############################################################################
mutable struct Door
    isCar::Bool
    isChosen::Bool
    isOpen::Bool
end

function get3RandDoors()::Vec{Door}
    cars::Vec{Bool} = Rnd.shuffle([true, false, false])
    chosen::Vec{Bool} = Rnd.shuffle([true, false, false])
    return [Door(car, chosen, false)
            for (car, chosen) in zip(cars, chosen)]
end

# open first non-chosen, non-car door
function openEligibleDoor!(doors::Vec{Door})::Nothing
    @assert length(doors) == 3 "need 3 doors"
    indEligible::Int = findfirst(d -> !d.isCar && !d.isChosen, doors)
    doors[indEligible].isOpen = true
    return nothing
end

# swap to first non-chosen, non-open door
function swapChoice!(doors::Vec{Door})::Nothing
    @assert length(doors) == 3 "need 3 doors"
    indCurChosen::Int = findfirst(d -> d.isChosen, doors)
    ind2Choose::Int = findfirst(d -> !d.isChosen && !d.isOpen, doors)
    doors[indCurChosen].isChosen = false
    doors[ind2Choose].isChosen = true
    return nothing
end

function didTraderWin(doors::Vec{Door})::Bool
    indWinner::Union{Nothing, Int} = findfirst(
        d -> d.isChosen && d.isCar, doors)
    return isnothing(indWinner) ? false : true
end

function getResultOfDoorsGame(shouldSwap::Bool=false)::Bool
    doors::Vec{Door} = get3RandDoors()
    openEligibleDoor!(doors)
    if shouldSwap
        swapChoice!(doors)
    end
    return didTraderWin(doors)
end

# treats: true as 1, false as 0
function getAvg(successes::Vec{Bool})::Flt
    return sum(successes) / length(successes)
end

function getProbOfWinningDoorsGame(shouldSwap::Bool=false,
                                   nSimul::Int=10_000)::Flt
    @assert 1e3 <= nSimul <= 1e5 "nSimul must be in range [1e3 - 1e5]"
    return [getResultOfDoorsGame(shouldSwap) for _ in 1:nSimul] |> getAvg
end

Rnd.seed!(1492)
getProbOfWinningDoorsGame(false), getProbOfWinningDoorsGame(true)

###############################################################################
#                                  solution 3                                 #
###############################################################################
function getAll3DoorSets()::Vec{Vec{Door}}
    allDoorSets::Vec{Vec{Door}} = []
    subset::Vec{Door} = Door[]
    for indCar in 1:3, indChosen in 1:3
        subset = [Door(false, false, false) for _ in 1:3]
        subset[indCar].isCar = true
        subset[indChosen].isChosen = true
        push!(allDoorSets, subset)
    end
    return allDoorSets
end

# open first non-chosen, non-car door
function openEligibleDoor!(doors::Vec{Door})::Vec{Door}
    @assert length(doors) == 3 "need 3 doors"
    indEligible::Int = findfirst(d -> !d.isCar && !d.isChosen, doors)
    doors[indEligible].isOpen = true
    return doors # instead of: return nothing
end

# swap to first non-chosen, non-open door
function swapChoice!(doors::Vec{Door})::Vec{Door}
    @assert length(doors) == 3 "need 3 doors"
    indCurChosen::Int = findfirst(d -> d.isChosen, doors)
    ind2Choose::Int = findfirst(d -> !d.isChosen && !d.isOpen, doors)
    doors[indCurChosen].isChosen = false
    doors[ind2Choose].isChosen = true
    return doors # instead of: return nothing
end

map(didTraderWin ∘ openEligibleDoor!, getAll3DoorSets()) |> getAvg,
map(didTraderWin ∘ swapChoice! ∘ openEligibleDoor!,
    getAll3DoorSets()) |> getAvg
