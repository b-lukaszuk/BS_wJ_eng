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
14.4%, 11.4%, and 3.6%. If on December 31, 2019 my monthly salary was $10,000
(I wished) then how much I would have to earn in January 2025 to be able to buy
the same amount of goods like on that date?

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

### Answer 1 {#sec:compound_interest_problem_a1}

Before we begin a quick refresher on percentages. As explained, e.g.
[here](https://b-lukaszuk.github.io/RJ_BS_eng/statistics_intro_probability_definition.html)
per definition a percentage is a hundredth part of the whole and can be
represented in a few equivalent forms, i.e.

- 0% = $\frac{0}{100}$ = 0/100 = 0.00 = 0
- 1% = $\frac{1}{100}$ = 1/100 = 0.01
- 5% = $\frac{5}{100}$ = 5/100 = 0.05
- 10% = $\frac{10}{100}$ = 10/100 = 0.10 = 0.1
- 20% = $\frac{20}{100}$ = 20/100 = 0.20 = 0.2
- 50% = $\frac{50}{100}$ = 50/100 = 0.50 = 0.5
- 100% = $\frac{100}{100}$ = 100/100 = 1.00 = 1
- 105% = $\frac{105}{100}$ = 105/100 = 1.05

For calculations it is especially useful to use them as decimals, hence we will
often divide a percentage by one hundred. Now, let's say that I got $100 (my
initial capital) on a deposit that pays 5% interest yearly. That means that
after one year I will get $105 or 105% of my initial capital. I can express this
mathematically as `$100 * 105% = $105` or to make it easier to type with a
calculator `100 * 1.05 = 105`. If the deposit lasted two years then I would have
to repeat the process one more time for year number two, i.e.
`$105 * 105% = $110.25` (105% of my new capital), also to be expressed as
`105 * 1.05 = 110.25`. Since the `$105` is actually `100 * 1.05` then I can
rewrite it as `(100 * 1.05) * 1.05 = 110.25`. For year number three I got
`$110.25 * 105% = $115.7625` or `110.25 * 1.05 = 115.7625` or
`((100 * 1.05) * 1.05) * 1.05 = 115.7625`. Hence a pattern emerges:

$deposit\ value = \$100 * 1.05^{number\ of\ years}$

or more generally

$total\ value = initial\ capital * (1 + percentage/100)^{number\ of\ years}$

Let's put that into a Julia's function.

```jl
s = """
function getValue(capital::Real, avgPercentage::Real, years::Int)::Flt
    @assert years > 0 "years must be greater than 0"
    @assert capital > 0 "capital must be greater than 0"
    return capital * (1+avgPercentage/100.0)^years
end
"""
sc(s)
```

And test it on our previous example.

```jl
s = """
round.([getValue(100, 5, i) for i in 1:3], digits=4)
"""
sco(s)
```

Now, we are ready to see if Fry is a billionaire.


```jl
s = """
# Futurama s1e6: 93 cents (\$0.93), 2.25%, 1_000 years
frysMoney = getValue(0.93, 2.25, 1_000)
frysMoney |> getFormattedMoney
"""
sco(s)
```

And indeed he is (four billion two hundred eighty three million, etc.). Still,
before you head towards cryogenic clinic to duplicate Fry's success be aware of
all the issues with
[cryonics](https://en.wikipedia.org/wiki/Cryonics#History) and that most of the
people frozen in 1960s' are not preserved today. Therefore, the profit seems to
be purely theoretical.

Anyway, as said the function could be used to estimate the nominal value that
you will get from your deposit (with a stable yearly interest rate). You could
also look at it from the other end and estimate how much you would have to earn
to cover up for an average inflation rate over a few years. Keep that in mind as
we go to the solution for Question 2 (see @sec:compound_interest_problem_q2).

### Answer 2 {#sec:compound_interest_problem_a2}

What about Question 2. If on December 31, 2019 my monthly salary was
$10,000 then how much I would have to earn in January 2025 to maintain my
purchasing power given that the inflation rates for years 2020-2024 were equal:
3.4%, 5.1%, 14.4%, 11.4%, and 3.6%. To answer that we will use the same
reasoning as in the previous section (@sec:compound_interest_problem_a1), but
since the percentages differ from year to year will will use a `for` loop to
cover for that.

```jl
s = """
function getValue(capital::Real, percentages::Vec{<:Real})::Flt
    @assert capital > 0 "capital must be greater than 0"
    for p in percentages
        capital *= 1 + (p / 100.0)
    end
    return capital
end
"""
sc(s)
```

Second `getValue` method defined, time to put it into good use.

```jl
s = """
money2019 = 10_000 # Dec 31, 2019
inflPoland = [3.4, 5.1, 14.4, 11.4, 3.6] # yrs: 2020-2024
money2025infl = getValue(money2019, inflPoland) # Jan 1, 2025
(
    getFormattedMoney(money2019),
    getFormattedMoney(money2025infl)
)
"""
sco(s)
```

So I would need to earn roughly $14,348 to be able to buy the same amount of
goods in 2025 as I could with $10,000 in 2019. Not sure why, but that doesn't
put a smile on my face.

### Answer 3 {#sec:compound_interest_problem_a3}

As a final step let's think was it worth a while to open a 5 years long bank
deposit (6% yearly interest rate) on January 1, 2020 given the inflation rates
discussed in the previous section (@sec:compound_interest_problem_a2). Would I
make any real profit on January 2, 2025?

In order to figure that out we need to counterbalance two factors. The increase
in the nominal value that we get due to the interest rate and a drop in the real
value of money due to the inflation rate. In other words, we might want to
calculate the real percentage change in money value given the two factors
combined. For that we should either implement a suitable formula from a reliable
source or come with the one ourselves. In order to learn we will try the other
(no pain, no gain).

To that end we will use proportions (they taught me that in the high school) and
some simple imaginable example. To make sure we are on the same page let's talk
briefly about the proportions.

Imagine that for $10 (`usd` below) I can buy 1 bread loaf (`bl` below). If so,
then how much bread can I buy for $5? Easy, its half of a bread loaf. You can
solve it with proportions like so:

$$10\ usd - 1\ bl$$ {#eq:prop1}

$$5\ usd - x\ bl$$ {#eq:prop2}

We set the same units on the same sides (left - right). Next, in order to get
$x$ we multiply numbers on the diagonals: 5 * 1 goes to the numerator and 10
goes into denominator (since it got no pair on the diagonal it falls to the
bottom):

$x = \frac{5\ usd\ *\ 1\ bl}{10\ usd}$

Then we forward to a solution.

$x = \frac{5 * 1}{10} = \frac{5}{10} = \frac{1}{2} = 0.5$

This works because @eq:prop1 and @eq:prop2 could be rewritten as:

$\frac{10}{1} = \frac{5}{x}$

or

$\frac{1}{10} = \frac{x}{5}$

The above is basically just finding an equivalent fraction that we learned in
our primary schools. Still, I like and remember the proportions example better.

With that under our belt let's follow with a simple example. Imagine that in
this year for $100 (`usd` below) we can buy 100 chocolate bars (`cb` below). Due
to the yearly inflation that is let's say 2% the same 100 chocolate bars will
cost after a year $102 dollars. Luckily, thanks to the let's say 5% interest
rate in a year on our deposit we will have $105 in banknotes. So how many
chocolate bars will we be able to buy after a year?

That's easy thanks to the proportions.

$$102\ usd - 100\ cb$$ {#eq:prop3}

$$105\ usd - x\ cb$$ {#eq:prop4}

Which gives us:

$x = \frac{105\ usd\ * 100\ cb}{102\ usd}$

and

$x = \frac{105 * 100}{102} = calculator\ does\ pip,\ pip,\ ...\ \approx 102.94$

Therefore, we can see that in this scenario the $105 in banknotes will allow us
to buy 102.94 chocolate bars (we think of it as a stable product that by itself
does not gain or loose value over time). Based on the chocolate bars we can
evaluate the real percentage gain/loss of our nominal money to be:
`102.94 - 100 = 2.94 chocolate bar` or 2.94% (chocolate bars were just an
abstraction needed as a reference point). To put it all together in a formula,
we get:

$$real\ percentage = \frac{105\ usd\ *\ 100}{102\ usd} - 100$$ {#eq:prop5}

Just like chocolate bars also dollars are a placeholder in our example (the more
material and concrete the objects are the easier it is to think about them and
manipulate them in our heads). Notice that `105 usd` in @eq:prop5 and @eq:prop4
actually stands for percentage gain in value (`100 + inflation rate`) of our
money (the 105% that we used in our explanation in the calculations in
@sec:compound_interest_problem_a1). On the other hand, `102 usd` in @eq:prop5
and @eq:prop3 is actually a placeholder for percentage change in value due to
the inflation (we divide by it, so we decrease our gain in numerator by it).
Therefore we can rewrite @eq:prop5 to:

$$real\ percentage = \frac{(100\ +\ interest\ rate) * 100}{100\ +\ inflation\ rate} - 100$$ {#eq:prop6}

Now let's put @eq:prop6 into a Julia's function.

```jl
s = """
function getRealPercChange(interestPerc::Real, inflPerc::Real)::Flt
    return ((100 + interestPerc) * 100) / (100 + inflPerc) - 100
end
"""
sc(s)
```

Now we can use it to write our final, third method, for `getValue`.

```jl
s = """
function getValue(capital::Real,
                  interestPercs::Vec{<:Real},
                  inflationPercs::Vec{<:Real})::Flt
    @assert capital > 0 "capital must be greater than 0"
    for (intr, infl) in zip(interestPercs, inflationPercs)
        capital = getValue(capital, getRealPercChange(intr, infl), 1)
    end
    return capital
end
"""
sc(s)
```

We will use it to answer our question.

```jl
s = """
interestDeposit = 6.0 # yrs: 2020-2025
numYrs = length(inflPoland)
money2025deposit = getValue(money2019,
	interestDeposit, numYrs) # Jan 1, 2025
money2025depositInflation = getValue(
    money2019,
	repeat([interestDeposit], numYrs), inflPoland) # Jan 1, 2025


(
    getFormattedMoney(money2019),
    getFormattedMoney(money2025deposit),
    getFormattedMoney(money2025depositInflation)
)
"""
sco(s)
```

And again, reality turns out to be disappointing. The initial capital of
$10,000 (January 1, 2020) was increased by 6% yearly which gave me $13,382 in
banknotes on January 1, 2025 for which I can buy the same amount of goods that I
could for $9,327 on January 1, 2020. So despite more money in my wallet
(nominal increase) I actually lost some real value. Eh.

OK, let's try to be optimists here. The glass is half full. By putting the money
on the deposit (5% yearly) we lost some money. Still, if we left it on an
ordinary account with a lousy 0.5% interest rate we would have lost even more
money.

```jl
s = """
(
	# nominal gain
	getFormattedMoney(
		getValue(money2019, 0.5, numYrs)),
	# real value
	getFormattedMoney(
		getValue(money2019, repeat([0.5], numYrs), inflPoland))
)
"""
sco(s)
```

So always look on the bright side of life, but look for a better investment
opportunities.
