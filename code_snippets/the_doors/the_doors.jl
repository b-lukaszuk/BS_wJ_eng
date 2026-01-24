import DataFrames as Dfs
import Random as Rnd

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Flt = Float64
const Vec = Vector

# https://en.wikipedia.org/wiki/Monty_Hall_problem

# Solution 1
# Bayes's Theorem
# https://allendowney.github.io/ThinkBayes2/chap02.html#the-monty-hall-problem
df = Dfs.DataFrame(Dict("Door" => 1:3))
df.prior = repeat([1//3], 3)
df

df.likelihood = [1//2, 1, 0]
df

function bayesUpdate!(df::Dfs.DataFrame)
    unnorm = df.prior .* df.likelihood
    df.posterior = unnorm ./ sum(unnorm)
    return nothing
end

bayesUpdate!(df)
df # to see as floats: convert.(Flt, df.posterior)

# Solution 2 and 3 common code
mutable struct Door
    isCar::Bool
    isChosen::Bool
    isOpen::Bool

    Door() = new(false, false, false)
    Door(iscar, ischosen, isopen) = new(iscar, ischosen, isopen)
end

function getNRandDoors(n::Int=3)::Vec{Door}
    @assert 2 < n < 11 "n must be in range [3-10]"
    cars::Vec{Bool} = zeros(Bool, n)
    cars[Rnd.rand(1:n)] = true
    chosen::Vec{Bool} = zeros(Bool, n)
    chosen[Rnd.rand(1:n)] = true
    return [Door(car, chosen, false) for (car, chosen) in zip(cars, chosen)]
end

# open random non-chosen, non-car, non-open door
function openEligibleDoor!(doors::Vec{Door})::Vec{Door}
    @assert 2 < length(doors) < 11 "must have [3-10] doors"
    inds2Open::Vec{Int} = findall(d -> !d.isOpen && !d.isChosen && !d.isCar, doors)
    ind2Open::Int = inds2Open[Rnd.rand(eachindex(inds2Open))]
    doors[ind2Open].isOpen = true
    return doors
end

# swap to random non-chosen, non-open door
function swapChoice!(doors::Vec{Door})::Vec{Door}
    @assert 2 < length(doors) < 11 "must have [3-10] doors"
    indChosen::Int = findfirst(d -> d.isChosen, doors)
    inds2Swap::Vec{Int} = findall(d -> !d.isOpen && !d.isChosen, doors)
    ind2Swap::Int = inds2Swap[Rnd.rand(eachindex(inds2Swap))]
    doors[indChosen].isChosen = false
    doors[ind2Swap].isChosen = true
    return doors
end

function didTraderWin(doors::Vec{Door})::Bool
    for d in doors
        if d.isChosen && d.isCar
            return true
        end
    end
    return false
end

# treats: true as 1, false as 0
function getAvg(successes::Vec{Bool})::Flt
    return sum(successes) / length(successes)
end

# Solution 2
# computer simulation
# single doors game
function getResultOfDoorsGame(shouldSwap::Bool=false, nDoors::Int=3)::Bool
    doors::Vec{Door} = getNRandDoors(nDoors)
    openEligibleDoor!(doors)
    if shouldSwap
        swapChoice!(doors)
    end
    return didTraderWin(doors)
end

function getProbOfWinningDoorsGame(nDoors::Int=3, shouldSwap::Bool=false,
                                   nSimul::Int=10_000)::Flt
    @assert 1e4 <= nSimul <= 1e6 "nSimul must be in range [1e4 - 1e6]"
    return [getResultOfDoorsGame(shouldSwap, nDoors) for _ in 1:nSimul] |> getAvg
end

getProbOfWinningDoorsGame(3, false), getProbOfWinningDoorsGame(3, true)

# Solution 3
# list all the possibilities of car location and choice location
function getAllDoorSets(doorsPerSet::Int=3)::Vec{Vec{Door}}
    @assert 2 < doorsPerSet < 11 "doorsPerSet must in the range [3-10]"
    allDoorSets::Vec{Vec{Door}} = []
    subset::Vec{Door} = Door[]
    for i in 1:doorsPerSet, j in 1:doorsPerSet
        subset = [Door() for _ in 1:doorsPerSet]
        subset[i].isCar = true
        subset[j].isChosen = true
        push!(allDoorSets, subset)
    end
    return allDoorSets
end

# to get ∘ (function composition) type \circ and press Tab key
map(didTraderWin ∘ openEligibleDoor!, getAllDoorSets()) |> getAvg
map(didTraderWin ∘ swapChoice! ∘ openEligibleDoor!, getAllDoorSets()) |> getAvg


###############################################################################
#                               5 doors per set                               #
###############################################################################
# with Bayes's theorem
df = Dfs.DataFrame(Dict("Door" => 1:5))
df.prior = repeat([1/5], 5)
# no matter which door is opened, no matter where is the car
# here, trader's choice Door 1, opened Door 5 (without car)
df.likelihood = [1/4, 1/3, 1/3, 1/3, 0]
bayesUpdate!(df)
df # to see as floats: convert.(Flt, df.posterior)

# with a computer simulation
getProbOfWinningDoorsGame(5, false), getProbOfWinningDoorsGame(5, true)

# with listing all the possibiilties
# likely to give the least precise estimate
# (because of randomness in openEligibleDoor! and swapChoice!)
map(didTraderWin ∘ openEligibleDoor!, getAllDoorSets(5)) |> getAvg
map(didTraderWin ∘ swapChoice! ∘ openEligibleDoor!, getAllDoorSets(5)) |> getAvg


###############################################################################
#                               7 doors per set                               #
###############################################################################
# with Bayes's theorem
df = Dfs.DataFrame(Dict("Door" => 1:7))
df.prior = repeat([1/7], 7)
# no matter which door is opened, no matter where is the car
# here, trader's choice Door 1, opened Door 2 (without car)
df.likelihood = [1/6, 0, 1/5, 1/5, 1/5, 1/5, 1/5]
bayesUpdate!(df)
df # to see as floats: convert.(Flt, df.posterior)

# with a computer simulation
getProbOfWinningDoorsGame(7, false), getProbOfWinningDoorsGame(7, true)

# with listing all the possibiilties
# likely to give the least precise estimate
# (because of randomness in openEligibleDoor! and swapChoice!)
map(didTraderWin ∘ openEligibleDoor!, getAllDoorSets(7)) |> getAvg
map(didTraderWin ∘ swapChoice! ∘ openEligibleDoor!, getAllDoorSets(7)) |> getAvg
