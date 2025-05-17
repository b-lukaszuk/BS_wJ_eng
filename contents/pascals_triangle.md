# Pascal's triangle {#sec:pascals_triangle}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/pascals_triangle)
(without explanations).

## Problem {#sec:pascals_triangle_problem}

Imagine that you are a basketball coach in a local school. A basketball team is
composed of 5 players. Nine kids attends your classes. You would like the kids
to play in every possible configuration so that you could choose the best team
to represent the school next month. You wonder how many different teams of 5
players can you compose out of 9 candidates.

Such a question could be answered with the
[binomial](https://docs.julialang.org/en/v1/base/math/#Base.binomial) function
or [Pascal's triangle](https://en.wikipedia.org/wiki/Pascal%27s_triangle).

So here is a task for you, write a program that will display the Pascal's
triangle that will help you to answer the question mentioned above.

Compare its output with `binomial`.

The function can display a bare (right) triangle

```
[1]
[1, 1]
[1, 2, 1]
[1, 3, 3, 1]
```

or if you like challenges a slightly formatted output (it doesn't have to be
exact):

```
   1
  1 1
 1 2 1
1 3 3 1
    ∆
```

The above indicates how many pairs of 2 people out of 3 candidates can we get
(e.g in order to play doubles in tennis).

## Solution {#sec:pascals_triangle_solution}

The solution goes here.
