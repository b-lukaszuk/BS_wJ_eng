const Vec = Vector

# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
function getPrimes(maxIncl::Int)
    @assert maxIncl >= 2 "maxIncl must be >= 2"
    maybePrimes::Vec{Bool} = ones(Bool, maxIncl)
    maybePrimes[1] = false # first prime is: 2
    for num in 2:maxIncl
        for multiple in (num*2):num:maxIncl
            maybePrimes[multiple] = false
        end
    end
    return collect(1:maxIncl)[maybePrimes]
end
