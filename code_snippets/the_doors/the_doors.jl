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
df

# Solution 2 and 3 common code
mutable struct Door
    isCar::Bool
    isChosen::Bool
    isOpen::Bool

    Door() = new(false, false, false)
    Door(car, chosen, open) = new(car, chosen, open)
end

function getNRandDoors(n::Int=3)::Vec{Door}
    @assert 2 < n < 11 "n must be in range [3-10]"
    cars::Vec{Bool} = zeros(Bool, n)
    cars[Rnd.rand(1:n)] = true
    chosen::Vec{Bool} = zeros(Bool, n)
    chosen[Rnd.rand(1:n)] = true
    return [Door(car, chosen, false) for (car, chosen) in zip(cars, chosen)]
end

# open first non-chosen, non-car doors
function openNonChosenDoor!(doors::Vec{Door})::Vec{Door}
    for d in doors
        if !d.isCar && !d.isChosen
            d.isOpen = true
            break
        end
    end
    return doors
end

# swap to first non-chosen, non-open door
function swapChoice!(doors::Vec{Door})::Vec{Door}
    alreadySwapped::Bool = false
    alreadyUnselected::Bool = false
    for d in doors
        if !alreadyUnselected && d.isChosen
            d.isChosen = false
            alreadyUnselected = true
            continue
        end
        if !alreadySwapped && !d.isChosen && !d.isOpen
            d.isChosen = true
            alreadySwapped = true
        end
        if alreadySwapped && alreadyUnselected
            break
        end
    end
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

function getAvg(successes::Vec{Bool})::Flt
    return sum(successes) / length(successes)
end

# Solution 2
# computer simulation
# single doors game
function getResultOfDoorsGame(shouldSwap::Bool=false, nDoors::Int=3)::Bool
    doors::Vec{Door} = getNRandDoors(nDoors)
    openNonChosenDoor!(doors)
    if shouldSwap
        swapChoice!(doors)
    end
    return didTraderWin(doors)
end

function getProbOfWinningDoorsGame(nDoors::Int=3, shouldSwap::Bool=false,
                                   nSimul::Int = 10_000)::Flt
    return [getResultOfDoorsGame(shouldSwap, nDoors) for _ in 1:nSimul] |> getAvg
end

Rnd.seed!(1492)
getProbOfWinningDoorsGame(3, false), getProbOfWinningDoorsGame(3, true)

# Solution 3
# list all the possibilities, calculate the probabilities
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
map(didTraderWin ∘ openNonChosenDoor!, getAllDoorSets()) |> getAvg
map(didTraderWin ∘ swapChoice! ∘ openNonChosenDoor!, getAllDoorSets()) |> getAvg

# answers for 5 doors per set
# with computer simulation
Rnd.seed!(1492)
getProbOfWinningDoorsGame(5, false), getProbOfWinningDoorsGame(5, true)

# listing all possibiilties
map(didTraderWin ∘ openNonChosenDoor!, getAllDoorSets(5)) |> getAvg
map(didTraderWin ∘ swapChoice! ∘ openNonChosenDoor!, getAllDoorSets(5)) |> getAvg

# answers for 7 doors per set
# with computer simulation
Rnd.seed!(1492)
getProbOfWinningDoorsGame(7, false), getProbOfWinningDoorsGame(7, true)

# listing all possibiilties
map(didTraderWin ∘ openNonChosenDoor!, getAllDoorSets(7)) |> getAvg
map(didTraderWin ∘ swapChoice! ∘ openNonChosenDoor!, getAllDoorSets(7)) |> getAvg
