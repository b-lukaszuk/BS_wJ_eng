# Overpayment {#sec:overpayment}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/overpayment)
(without explanations).

## Problem {#sec:overpayment_problem}

We finished the previous section (@sec:mortgage) with the discussion about
paying off a mortgage. In general, banks allow their clients to overpay their
mortgages, which should be beneficial to the borrowers. So here is a task for
you.

Write a computer program, that will estimate the savings you make by overpaying
a mortgage (assume an overpayment completely overpays the principal and
reduces the number of installments).

Use the program to answer a few questions.

How much money do you save in the case of `mortgage1` (\$200,000, 6.49%, 20 years) and `mortgage2` (\$200,000, 4.99%, 30 years) (see @sec:mortgage_solution) if you overpay them regularly every month with \$200 dollars.

For the `mortgage1` which one is more worth it: to overpay it every month with
\$200 dollars or to overpay it only once let's say in month 13 with \$20,000?

Which scenario will give you more profit (in nominal value): to overpay `mortgage1` with \$20,000 in month 13, or to put this \$20,000 into a bank deposit that pays 5% yearly for the 19 years (roughly the remaining duration of the mortgage)?

## Solution {#sec:overpayment_solution}

There's no need to (completely) reinvent the wheel so we will use `Mortgage`,
`fmt` and `getInstallment` we developed in @sec:mortgage_solution. The function
we'll define is `payOffMortgage`

```jl
s = """
# single month payment of mortgage, returns
# (remainingPrincipal, pincipalPaid, interestPaid)
function payOffMortgage(
    m::Mortgage, curPrincipal::Real, installment::Real,
    overpayment::Real)::Tuple{Real, Real, Real}

    r::Real = m.interestPercYr / 100 / 12
    newPrincipal::Real = curPrincipal - overpayment
    interestPaid::Real = newPrincipal * r
    principalPaid::Real = installment - interestPaid

    return (newPrincipal - principalPaid,
               principalPaid + overpayment, interestPaid)
end
"""
sc(s)
```

The function accepts (among others) `curPrincipal`, `installment` and
`overpayment` and does a payment for a single month. To that end first we
subtract `overpayment` from `curPrincipal` to get `newPrincipal`. We use
`newPrincipal` to calculate the amount of money paid this month as interest
(`interestPaid`). Then, we get estimate which part of the principal we paid in
our installment (`principalPaid`). Finally, we return a tuple with 3 values: 1)
remaining principal (after the payment), 2) principal paid this month (from
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
looks something like:

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
        r::Real = m.interestPercYr / 100 / 12
        newPrincipal::Real = curPrincipal - overpayment
        interestPaid::Real = newPrincipal * r
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

To be continued...
