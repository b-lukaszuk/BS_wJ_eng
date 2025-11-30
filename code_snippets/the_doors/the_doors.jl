import DataFrames as Dfs
import Random as Rnd

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly

const Flt = Float64
const Vec = Vector

# https://en.wikipedia.org/wiki/Monty_Hall_problem
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

# computer simulation
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

function openFirstEmptyNonChosenDoor!(doors::Vec{Door})::Vec{Door}
    for d in doors
        if !d.isCar && !d.isChosen
            d.isOpen = true
            break
        end
    end
    return doors
end

function swapChoice!(doors::Vec{Door})::Vec{Door}
    for d in doors
        if d.isChosen
            d.isChosen = false
            continue
        end
        if !d.isChosen && !d.isOpen
            d.isChosen = true
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

function getResultOfDoorsGame(shouldSwap::Bool=false)::Bool
    doors::Vec{Door} = get3RandDoors()
    openFirstEmptyNonChosenDoor!(doors)
    if shouldSwap
        swapChoice!(doors)
    end
    return didTraderWin(doors)
end

function getAvg(successes::Vec{Bool})::Flt
    return sum(successes) / length(successes)
end

function getProbOfWinningDoorsGame(shouldSwap::Bool=false,
                                   nSimul::Int = 10_000,)::Flt
    return [getResultOfDoorsGame(shouldSwap) for _ in 1:nSimul] |> getAvg
end

getProbOfWinningDoorsGame(false), getProbOfWinningDoorsGame(true)

# just listing all possibilities
function getAllDoorSets()::Vec{Vec{Door}}
    allDoorSets::Vec{Vec{Door}} = []
    for i in 1:3, j in 1:3
        subset = [Door(false, false, false) for _ in 1:3]
        subset[i].isCar = true
        subset[j].isChosen = true
        push!(allDoorSets, subset)
    end
    return allDoorSets
end

map(didTraderWin, getAllDoorSets()) |> getAvg
map(didTraderWin ∘ swapChoice!, getAllDoorSets()) |> getAvg
