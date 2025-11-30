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

which can be also written as

$P(H|D) = \frac{P(H) * P(D|H)}{P(D)}$

where:

- P(H|D) - probability of the hypothesis given the obtained data (aka **posterior**)
- P(H) - probability of a given hypothesis upfront (aka **prior**)
- P(D|H) - probability of obtaining such data given the discussed hypothesis is true (aka **likelihood**)
- P(D) - the total probability of the data under all the considered hypothesis.
