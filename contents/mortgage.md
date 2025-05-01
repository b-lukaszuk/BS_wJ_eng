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
   and interest you pay to the bank)?

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
    return result * " usd"
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
