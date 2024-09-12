# Bat and Ball

## Problem

Let's start small. Recently someone told me an interesting small mathematical problem that I happened to knew from my youth:

> A bat and a ball cost in total $1.1. The bat costs $1 more than the ball. How
> much costs the ball?

Pause for a moment and try to give an answer.

## Solution

My first impulse (before the recollections of the past kicked in) was that the ball should cost $0.1 or 10 cents. It's the only logical solution, right? Or maybe not? Let's summon primary school math to the rescue and settle this once and for all. From the task description we know that:

$bat + ball = 1.1$
$bat - ball = 1$

Therefore, we can rewrite the second expression (move `- ball` to the other side and change mathematical operation to the opposite) we get:
$bat = 1 + ball$

Finally, by substituting `bat` from equation 1 with `bat` (`bat = 1 + ball`) from equation 2 we get.

$1 + ball + ball = 1.1$

which we can simplify to

$1 + 2*ball = 1.1$

$2*ball + 1 = 1.1$
$2*ball = 1.1 - 1$
$2*ball = 0.1$

We divide both sides by 2, and get:

$ball = 0.05$

So it turns out that, counter-intuitively, the ball costs $0.05 or 5 cents.

That's all very interesting, but what any of this got to do with Julia?
Well we can solve this and more complicated equations with it. For that purpose we will use matrices and their multiplications as explained in [this ](https://www.youtube.com/watch?v=Awcj447pYuk) and [that](https://www.youtube.com/watch?v=AUqeb9Z3y3k) Khan Academy's video.

```julia
variables = [
    1 1; # equation 1, 1 bat + 1 ball
    1 -1 # equation 2, 1 bat - 1 ball
]
prices = [1.1, 1] # equation 1 (= 1.1), equation 2 (= 1)

(variables, prices)
```

now, in line with the videos we multiply the matrix `variables` by the inverse of `prices` using `\` operator

```julia
result = variables \ prices
round.(result, digits=4)
```

Here we see the prices of `bat` (1.05) and `ball` (0.05) calculated by Julia.
