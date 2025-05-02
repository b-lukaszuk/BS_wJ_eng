# Mortgage {#sec:mortgage}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/compound_interest)
(without explanations).

## Problem {#sec:mortgage_problem}

Sooner or later most of us ordinary folk end up taking a mortgage to buy an
apartment or a house.

So here are two scenarios for you:

1. you borrow $200,000 (principal) for 20 years at 6.49% yearly interest rate
2. you borrow $200,000 (principal) for 30 years at 4.99% yearly interest rate

Write a Julia program that will tell you:

1. How much money will you pay every month (installment) in both cases (assume
   fixed rate mortgage)?
2. How much principal you will still owe to the bank at year 15 in each
   case?
3. After how many years your debt will be $\le$ $100'000?
4. Which of the two mortgages is more worth it for you (the smaller total cost
   and total interest you pay to the bank)?

Feel free to add some visual flair to your solution.

BTW. You may read about mortgages,
e.g. [here](https://en.wikipedia.org/wiki/Mortgage_calculator#).

## Solution {#sec:mortgage_solution}

Before we begin a few short definitions so that we are on the same page.

- principal - the money you borrow form a bank
- interest - the money you pay extra (except for the money you borrowed)
- interest rate - a percentage of principal which you will pay as interest
- installment - fixed monthly payment to the bank in order to cover you debt,
  part of it goes to pay off the principal and part to pay the interest

Next, let's use the formatting function from @sec:compound_interest_solution.

```jl
s = """
# getFormattedMoney from chapter: compound interest, renamed
function fmt(money::Real, sep::Char=',',)::Str
    @assert money >= 0 "money must be >= 0"
    amount::Str = round(Int, money) |> string
    result::Str = ""
    counter::Int = 0
    for digit in reverse(amount) # digit is a single digit (type Char)
        if counter == 3
            result = sep * result
            counter = 0
        end
        result = digit * result
        counter += 1
    end
    return result * " USD"
end
"""
sc(s)
```

Time to define a `struct` that will contain all the data necessary to perform
calculations for a given mortgage.

```jl
s = """
struct Mortgage
    principal::Real
    interestPercYr::Real
    numMonths::Int

    Mortgage(p::Real, i::Real, n::Int) = (p < 0 && i < 0 && 12 < n < 480) ?
        error("incorrect field values") : new(p, i, n)
end

mortgage1 = Mortgage(200_000, 6.49, 20*12)
mortgage2 = Mortgage(200_000, 4.99, 30*12)
"""
sc(s)
```

Finally we are ready to calculate our monthly payment to the bank.

```jl
s = """
# calculate c - money paid to the bank every month
function getInstallment(m::Mortgage)::Flt
    p::Real = m.principal
    r::Real = m.interestPercYr / 100 / 12
    n::Int = m.numMonths
    if r == 0
        return p / n
    else
        numerator::Flt = r * p * (1+r)^n
        denominator::Flt = ((1 + r)^n) - 1
        return numerator / denominator
    end
end
"""
sc(s)
```

All the formulas are based on [this Wikipedia's
page](https://en.wikipedia.org/wiki/Mortgage_calculator#). Notice that the
function arguments (and `Mortgage` fields) contain longer (more descriptive)
names, whereas inside the functions we use the abbreviations (case insensitive)
found in the above-mentioned formulas .

With that done, we can answer how much money will we have to pay to the bank
every month for the duration of our mortgage.

```jl
s = """
(
    getInstallment(mortgage1) |> fmt,
    getInstallment(mortgage2) |> fmt
)
"""
sco(s)
```

The money we still own to the bank will change month after month (because every
month we pay off a fraction of it with our installment), so let's calculate just
that.

```jl
s = """
# amount of money owned after every month
function getPrincipalAfterMonth(prevPrincipal::Real,
                                interestPercYr::Real,
                                monthlyPayment::Flt)::Flt
    @assert (prevPrincipal >= 0 && interestPercYr > 0 && monthlyPayment > 0)
            "incorrect argument values"
    p::Real = prevPrincipal
    r::Real = interestPercYr / 100 / 12
    c::Flt = monthlyPayment
    return (1 + r) * p - c
end
"""
sc(s)
```

Not much to explain here, just a simple rewrite of the formula into Julia's
code, but now we can estimate principal owned to the bank each year.

```jl
s = """
# paying off mortgage year by year
# returns principal still owned every year
function getPrincipalOwnedEachYr(m::Mortgage)::Vec{Flt}
    monthlyPayment::Flt = getInstallment(m)
    principalStillOwnedYrs::Vec{Flt} = [m.principal]
    principal::Real = m.principal
    for month in 1:m.numMonths
        principal = getPrincipalAfterMonth(
            principal, m.interestPercYr, monthlyPayment)
        if month % 12 == 0
            push!(principalStillOwnedYrs, principal)
        end
    end
    return round.(principalStillOwnedYrs, digits=2)
end
"""
sc(s)
```

Here we calculate the principal owned after every month, and once a year (`month
% 12 == 0`) we push it to a vector tracking its yearly change
(`principalStillOwnedYrs`). Let's see how it works, if we did it right then in
the end the principal should drop to zero.

```jl
s = """
principals1 = getPrincipalOwnedEachYr(mortgage1)
principals2 = getPrincipalOwnedEachYr(mortgage2)

(
    principals1[end],
    principals2[end]
)
"""
sco(s)
```

So how much principal we still own to the bank at the beginning of year 15 in
each scenario?

```jl
s = """
(
    principals1[15] |> fmt,
    principals2[15] |> fmt
)
"""
sco(s)
```

Hmm, quite a lot. And when will this value drop to $\le$ 100,000 USD?

```jl
s = """
(
    findfirst(p -> p <= 100_000, principals1),
    findfirst(p -> p <= 100_000, principals2)
)
"""
sco(s)
```

In general, for quite some time the money we pay to the bank mostly pay off the
interest and not the capital (see @fig:mortgagePrincipalsYrByYr).

![Principal still owned to the bank year by year. Mortgage: $200,000 at 6.49% yearly for 20 years. The estimation may not be accurate.](./images/mortgagePrincipalsYrByYr.png){#fig:mortgagePrincipalsYrByYr}
