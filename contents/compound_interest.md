# Compound interest {#sec:compound_interest}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/compound_interest)
(without explanations).

## Problem {#sec:compound_interest_problem}

There is this cartoon [Futurama](https://en.wikipedia.org/wiki/Futurama) that
tells the story of a guy named Fry. The character was accidentally frozen on
December 31, 1999 and wakes up back to life on December 31, 2999. In season 1
episode 6 Fry visits his old bank. The teller informs him that he had on his
account 93 cents in 1999. However, with an average yearly interest of 2.25% over
the period of 1000 years it gives $4.3 billion.

Read about [compound interest](https://en.wikipedia.org/wiki/Compound_interest)
and use Julia to answer a few questions.

### Question 1 {#sec:compound_interest_problem_q1}

Is Fry really a billionaire?

### Question 2 {#sec:compound_interest_problem_q2}

According to [this
page](https://pl.wikipedia.org/wiki/Inflacja_w_Polsce#Historia) (careful its in
Polish) the inflation in Poland over the period 2020-2024 was: 3.4%, 5.1%,
14.4%, 11.4%, and 3.6%. If on December 31, 2019 my monthly salary was $10'000 (I
wished) then how much I would have to earn in January 2025 to be able to buy the
same amount of goods like on that date?

### Question 3 {#sec:compound_interest_problem_q3}

Imagine that on January 1, 2020 I opened a bank deposit for 5 years with a
yearly interest rate of 6%. Given the inflation rates from the question 2 would
I make any real profit on January 2, 2025?

## Solution {#sec:compound_interest_solution}

Before we begin let's write a helper function that will nicely display the
amount of money we get and improve the readability of our results.

```jl
s = """
function getFormattedMoney(money::Real, sep::Char=',')::Str
    digits::Str = round(Int, money) |> string
    result::Str = ""
    counter::Int = 0
    for digit in reverse(digits) # digit is a single digit (type Char)
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

The function may not be the most performant, but it was pretty easy to write. It
receives money as a [Real](https://docs.julialang.org/en/v1/base/numbers/)
number and sets apart every three digits with a separator (`sep`) of our choice.
Since in English decimal separator is `.` (dot) and thousand separator is `,`
(comma) then that's what we used here. We round the number to integer
(`round(Int, money)`) and convert it to `string`. Next we traverse all the
digits (`for digit`) in the opposite direction (from right to left) thanks to the
`reverse(digits)`. Every third digit (`if counter == 3`) we place our `sep` to
the `result` and count to three a new (`counter = 0`). Otherwise, we prepend our
`digit` to the `result` (`digit * result`) and increase the counter
(`counter +=1`). In the end we return the formatted number (`result * " usd"`).

Let's see how it works.

```jl
s = """
getFormattedMoney(12345.06)
"""
sco(s)
```

I think that twelve thousand three hundred and forty five is much easier to
process this way than in its alternative transcription form (`12345`).
