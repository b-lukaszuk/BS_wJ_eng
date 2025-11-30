# The Doors {#sec:the_doors}

In this chapter I did not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/the_doors)
(without explanations).

## Problem {#sec:the_doors_problem}

There is this famous game-show host problem, also known as [the Monty Hall
problem](https://en.wikipedia.org/wiki/Monty_Hall_problem) that goes something
like this.

Imagine there is a game-show in which a person may win a new car. The car is
hidden behind one of three doors. The host chooses a player (called a trader)
from the people in the studio and asks them to pick one door. The choice is
Door 1. The host knows what's behind all the doors. He decided to open Door 2,
behind which there's a goat. Now the trader got a choice: stay with their
initial choice, or switch to still unopened Door 2.

Imagine you are the trader. What would you do? Is it in your interest to make a
switch? Use Julia to answer that question.

## Solution {#sec:the_doors_solution}

One way to answer the question is to use the so called Bayes's Theorem, as
explained by Allen B. Downey
[here](https://allendowney.github.io/ThinkBayes2/chap02.html#the-monty-hall-problem).

> **_Note:_** Below, you will find a shortened explanation. To understand this
> topic more satisfactorily you will likely need to read the first two chapters
> of [Think Bayes](https://allendowney.github.io/ThinkBayes2/index.html) by
> Allen B. Downey.

First the theorem:

$P(A|B) = \frac{P(A) * P(B|A)}{P(B)}$

which can be also written as:

$$P(H|D) = \frac{P(H) * P(D|H)}{P(D)}$$ {#eq:bayesTheorem}

where:

- P(H|D) - probability of the hypothesis given the obtained data (aka **posterior**)
- P(H) - probability of a given hypothesis upfront (aka **prior**)
- P(D|H) - probability of obtaining such data given the discussed hypothesis is true (aka **likelihood**)
- P(D) - the total probability of the data under all the considered hypothesis.

Regarding the **priors** or P(H), initially it is equally likely for the car to
be behind any of the three doors. Therefore, the probability that the car is
behind Door X is: 1 out of 3, so 1/3. This can be represented as:

```jl
s = """
import DataFrames as Dfs

df = Dfs.DataFrame(Dict("Door" => 1:3))
df.prior = repeat([1//3], 3) # 1//3 is Rational (a fraction)
df
Options(df, caption="The doors. Priors.", label="theDoorsPriors")
"""
replace(sco(s), Regex("Options.*") => "", "1//1" => "1", "2//1" => "2", "3//1" => 3)
```

Let's move to **likelihood** or P(D|H). If the car was behind Door 1, then the
host may open either Door 2 or Door 3. Hence, the probability of him opening
Door 3 (as he did in the problem description) is 1 out of 2, so 1/2 or 0.5. If
the car was behind Door 2, then the host had no other option but to open Door 3
(since Door 1 is the trader's choice and he doesn't want to reveal the car
behind Door 2). Therefore, in this case the probability is equal to 1 (certain
event). If the car were behind Door 3, then there is no way the host would have
opened it (since it would reveal the car and spoil the game). So, in this case
the probability is 0.

Let's add this information to the table.

```jl
s = """
df.likelihood = [1//2, 1, 0]
df
Options(df, caption="The doors. Likelihoods.", label="theDoorsLikelihood")
"""
replace(sco(s), Regex("Options.*") => "", "1//1" => "1", "2//1" => "2", "3//1" => 3)
```

Now we perform a so called Bayesian update, e.g. per the formula in
@eq:bayesTheorem: first we multiply $P(H)$ (prior) by $P(D|H)$ (likelihood) then
we divide it by $P(D)$ (sum of all probabilities) like so:

```jl
s = """
function bayesUpdate!(df::Dfs.DataFrame)
    df.unnorm = df.prior .* df.likelihood
    df.posterior = df.unnorm ./ sum(df.unnorm)
    return nothing
end

bayesUpdate!(df)
df
Options(df, caption="The doors. Posteriors.", label="theDoorsPosterior")
"""
replace(sco(s), Regex("Options.*") => "", "1//1" => "1", "2//1" => "2", "3//1" => 3)
```

Clearly, switching to Door 2 gives the trader a better chance of winning the car
($P = \frac{2}{3} \approx 0.66$) than remaining with the original choice ($P =
\frac{1}{3} \approx 0.33$).
