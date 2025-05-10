# Overpayment {#sec:overpayment}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/overpayment)
(without explanations).

## Problem {#sec:overpayment_problem}

We finished the previous chapter (@sec:mortgage) with the discussion about
paying off a mortgage. In general, banks allow their clients to overpay their
mortgages, which should be beneficial to the borrowers. So here is a task for
you.

Write a computer program, that will estimate the savings you make by overpaying
a mortgage (assume the whole overpayment goes to overpay the principal and
reduces the number of installments).

Use the program to answer a few questions.

How much money can you expect to save in the case of `mortgage1` (\$200,000,
6.49%, 20 years) and `mortgage2` (\$200,000, 4.99%, 30 years) (see
@sec:mortgage_solution) if you overpay them regularly every month with \$200
dollars.

For `mortgage1` which one is more worth it: to overpay it every month with
\$200 dollars or to overpay it only once, let's say in month 13, with \$20,000?

Which scenario would you expect to give you more profit (in nominal value): to
overpay `mortgage1` with \$20,000 in month 13, or to put this \$20,000 into a
bank deposit that pays 5% yearly for the 19 years (roughly the remaining
duration of the mortgage)?

## Solution {#sec:overpayment_solution}

There's no need to (completely) reinvent the wheel so we will use `Mortgage`,
`fmt` and `getInstallment` we developed in @sec:mortgage_solution. The first
function we'll define in this chapter is `payOffMortgage`

```jl
s = """
# single month payment of mortgage, returns
# (remainingPrincipal, pincipalPaid, interestPaid)
function payOffMortgage(
    m::Mortgage, curPrincipal::Real, installment::Real,
    overpayment::Real)::Tuple{Real, Real, Real}

    interestPercMonth::Real = m.interestPercYr / 100 / 12
    newPrincipal::Real = curPrincipal - overpayment
    interestPaid::Real = newPrincipal * interestPercMonth
    principalPaid::Real = installment - interestPaid

    return (newPrincipal - principalPaid,
               principalPaid + overpayment, interestPaid)
end
"""
sc(s)
```

The function accepts (among others) `curPrincipal`, `installment` and
`overpayment` and does a payment for a single month. To that end, first we
subtract `overpayment` from `curPrincipal` to get `newPrincipal`. We use
`newPrincipal` to calculate the amount of money paid this month as interest
(`interestPaid`). Then, we estimate which part of the principal we paid in
our installment (`principalPaid`). Finally, we return a tuple with 3 values: 1)
the remaining principal (after the payment), 2) principal paid this month (from
`installment` and `overpayment`), and 3) interest paid (from `installment`). The
remaining principal is `newPrincipal - principalPaid`. The principal that we
paid off this month is `principalPaid` (as part of the installment) and
`overpayment`. The interest paid this month is just `interestPaid`.

Right away we see a few reasons why our function is likely not to be accurate
(except for the obvious lack of rounding to 2 decimal points as a bank would do).
For instance, we overpaid the money first with our `overpayment` and only then
calculated the `interestPaid` (and other stuff) which may not be the case
in reality. Secondly, a bank may charge a fee (or some money named otherwise)
for every overpayment we make. Still, since all this section is just a
programming exercise and not a financial advice then we will not be bothered by
that fact.

However, we will improve our `payOffMortgage` a bit, by dealing with some edge
cases: 1) when `curPrincipal` is 0 or negative
(`if curPrincipal <= 0.0` below), 2) when `curPrincipal` is equal to or smaller
than `overpayment` (`elseif curPrincipal <= overpayment` below), and 3) when
`curPrincipal` is equal to or smaller than `overpayment + installemnt`
(`if principalPaid >= newPrincipal` below). Therefore, our `payOffMortgage` will
look something like:

```jl
s = """
# single month payment of mortgage
# (remainingPrincipal, pincipalPaid, interestPaid)
function payOffMortgage(
    m::Mortgage, curPrincipal::Real, installment::Real,
    overpayment::Real)::Tuple{Real, Real, Real}
    if curPrincipal <= 0.0
        return (0.0, 0.0, 0.0)
    elseif curPrincipal <= overpayment
        return (0.0, curPrincipal, 0.0)
    else
        interestPercMonth::Real = m.interestPercYr / 100 / 12
        newPrincipal::Real = curPrincipal - overpayment
        interestPaid::Real = newPrincipal * interestPercMonth
        principalPaid::Real = installment - interestPaid
        if principalPaid >= newPrincipal
            return (0.0, newPrincipal + overpayment, interestPaid)
        else
            return (newPrincipal - principalPaid,
                    principalPaid + overpayment, interestPaid)
        end
    end
end
"""
sc(s)
```

Once we can pay it off for one month, we can pay it off completely and summarize
it. First, summary:

```jl
s = """
struct Summary
    principal
    interest
    months

    Summary(p::Real, i::Real, m::Int) = (
		p < 1 || i < 0 || m < 12 || m > 480) ?
        error("incorrect field values") : new(p, i, m)
end
"""
sc(s)
```

Now, for the complete mortgage pay off.

```jl
s = """
# pay off mortgage fully, with overpayment
function payOffMortgage(
    m::Mortgage,
    overpayments::Dict{Int, <:Real})::Summary
    installment::Real = getInstallment(m) # monthly payment
    princLeft::Real = m.principal
    princPaid::Real = 0.0
    interPaid::Real = 0.0
    totalPrincPaid::Real = 0.0
    totalInterestPaid::Real = 0.0
    months::Int = 0
    for month in 1:m.numMonths
        if princLeft <= 0
            break
        end
        months += 1
        princLeft, princPaid, interPaid = payOffMortgage(
            m, princLeft, installment, get(overpayments, month, 0))
        totalPrincPaid += princPaid
        totalInterestPaid += interPaid
    end
    return Summary(totalPrincPaid, totalInterestPaid, months)
end

# pay off mortgage according to the schedule, no overpayment
function payOffMortgage(m::Mortgage)::Summary
    return payOffMortgage(m, Dict{Int, Real}())
end
"""
sc(s)
```

We begin, by defining a few variables. For instance, `princLeft` will hold
principal sill left to pay after a month, `princPaid` will contain the value of
principal paid off in a given month, `intrPaid` will store the interest paid to
a bank in a given month. The above will be used in the `for` loop and will
change month by month. Next, the variables that will be used in the `Summary`
struct returned by our function (`totalInterestPaid`, `totalInterestPaid`,
`months`). In the `for` loop we pay off the mortgage month by month. If there
is no principal to be paid off (`if princLeft <= 0`) we `break`
early. Otherwise, we update the number of `months`, `totalPrincPaid`, and
`totalInterestPaid`. Notice, that we obtain the over-payment for a month from
the `overpayments` dictionary, where the default over-payment (if the key
doesn't exist) is 0 (`get(overpayments, month, 0)`).

Let's do a quick sanity check. Previously (@sec:mortgage_solution), we said that
the regular payment off `mortgage1` (\$200,000 at 6.49% for 20 years) will
roughly yield the principal of \$200,000 and the interest of \$157,593. Let's
see if we get that.

```jl
s = """
payOffMortgage(mortgage1)
"""
sco(s)
```

OK, so finally, we are ready to answer our questions.

How much money can we potentially save in the case of `mortgage1` (\$200,000,
6.49%, 20 years) (see @sec:mortgage_solution) overpaid regularly every month
with \$200 dollars.

```jl
s = """
function getTotalCost(s::Summary)::Real
    return s.principal + s.interest
end

function getTotalCostDiff(m::Mortgage,
	overpayments::Dict{Int, <:Real})::Real
    s1::Summary = payOffMortgage(m)
    s2::Summary = payOffMortgage(m, overpayments)
    return getTotalCost(s1) - getTotalCost(s2)
end

getTotalCostDiff(mortgage1,
	Dict(i => 200 for i in 1:mortgage1.numMonths)) |> fmt
"""
sco(s)
```

Quite a penny (see also @fig:mortgageOverpayment1).

![Overpaying a mortgage (\$200,000, 6.49%, 20 years) with \$200 monthly (estimation may not be accurate).](./images/mortgageOverpayment1.png){#fig:mortgageOverpayment1}

And now let's overpay `mortgage2` (\$200,000, 4.99%, 30 years) with \$200 monthly.

```jl
s = """
getTotalCostDiff(mortgage2,
	Dict(i => 200 for i in 1:mortgage2.numMonths)) |> fmt
"""
sco(s)
```

The total savings appear to be even greater than for `mortgage1`, still the
total cost seems to be greater for `mortgage2` (see @fig:mortgageOverpayment1
and @fig:mortgageOverpayment2).

![Overpaying a mortgage (\$200,000, 4.99%, 30 years) with \$200 monthly (estimation may not be accurate).](./images/mortgageOverpayment2.png){#fig:mortgageOverpayment2}

OK, time for the next question.

For `mortgage1` which one is more worth it: to overpay it every month with \$200
dollars or to overpay it only once, let's say in month 13, with \$20,000?

```jl
s = """
(
	getTotalCostDiff(mortgage1,
		Dict(i => 200 for i in 1:mortgage1.numMonths)) |> fmt,
	getTotalCostDiff(mortgage1, Dict(13 => 20_000)) |> fmt
)
"""
sco(s)
```

Interesting, the above output indicates that we would be able to save more, with
an early (month 13) over-payment of a vast sum of money (\$20,000, 10% of our
initial principal) than just by regularly overpaying the mortgage with small
sums of it (\$200, 0.1% of our initial principal).

Out of pure curiosity, let's see how much we could save when we combine the two
(we overpay \$200 every month, except for month 13, where we overpay \$20,000)

```jl
s = """
customOverpayments = Dict(i => 200 for i in 1:mortgage1.numMonths)
customOverpayments[13] = 20_000
getTotalCostDiff(mortgage1, customOverpayments) |> fmt
"""
sco(s)
```

And now, the final question. Which one is better: to overpay `mortgage1` with
\$20,000 in month 13, or to put this \$20,000 into a bank deposit that pays 5%
yearly for the 19 years (roughly the remaining duration of the mortgage)?

```jl
s = """
(
	getTotalCostDiff(mortgage1, Dict(13 => 20_000)) |> fmt,
	# fn from chapter about compund interest
	getValue(20_000, 5, 19) - 20_000 |> fmt
)
"""
sco(s)
```

So if the calculations were accurate in this scenario in nominal money we would
save \$41,268 in interests, whereas gained extra \$30,593 (to our initial
\$20,000) on the bank deposit (compare with
@sec:compound_interest_problem_a1). Advantage over-payment.
