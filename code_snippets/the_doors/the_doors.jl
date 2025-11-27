# https://en.wikipedia.org/wiki/Monty_Hall_problem
import Random as Rnd

# the code in this file is meant to serve as a programming exercise only
# it may not act correctly
#
const Flt = Float64
const Vec = Vector

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

function openFirstEmptyNonChosenDoor!(doors::Vec{Door})
    for d in doors
        if !d.isCar && !d.isChosen
            d.isOpen = true
            break
        end
    end
    return nothing
end

function swapChoice!(doors::Vec{Door})
    for d in doors
        if d.isChosen
            d.isChosen = false
            continue
        end
        if !d.isChosen && !d.isOpen
            d.isChosen = true
        end
    end
    return nothing
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

function getProb(successes::Vec{Bool})::Flt
    return sum(successes) / length(successes)
end

function getProbOfWinningDoorsGame(shouldSwap::Bool=false,
                                   nSimul::Int = 100_000,)::Flt
    return [getResultOfDoorsGame(shouldSwap) for _ in 1:nSimul] |> getProb
end

getProbOfWinningDoorsGame(false), getProbOfWinningDoorsGame(true)
