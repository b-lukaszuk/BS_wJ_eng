const Vec = Vector

# version 1: trial division
# https://en.wikipedia.org/wiki/Prime_number#Trial_division
function isPrime(n::Int)::Bool
    @assert n > 1 "n must be > 1"
    if n < 4
        return true
    end
    upto::Int = round(Int, ceil(sqrt(n)))
    for i in 2:upto
        if n % i == 0
            return false
        end
    end
    return true
end

function getPrimesV1(maxIncl::Int)::Vec{Int}
    @assert maxIncl >= 2 "maxIncl must be >= 2"
    return filter(isPrime, 2:maxIncl)
end

# version 2: sieve of Eratosthenes
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
function getXmultiples(x::Int, upto::Int)::StepRange{Int, Int}
    return (x*2):x:upto
end

function getPrimesV2(maxIncl::Int)
    @assert maxIncl > 1 "maxIncl must be > 1"
    maybePrimes::Vec{Bool} = ones(Bool, maxIncl)
    nums::Vec{Int} = 1:maxIncl |> collect
    maybePrimes[1] = false # first prime is: 2
    for num in 2:maxIncl
        maybePrimes[getXmultiples(num, maxIncl)] .= false
    end
    return nums[maybePrimes]
end

primesFromWiki = [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97]
getPrimesV1(100) == primesFromWiki
getPrimesV2(100) == primesFromWiki
