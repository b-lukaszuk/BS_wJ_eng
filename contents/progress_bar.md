# Progress Bar {#sec:progress_bar}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/progress_bar)
(without explanations).

## Problem {#sec:progress_bar_problem}

While running a time consuming program we may see a progress bar that will
provide the user with visual cues as to the course of its execution.

So here is a task for you. Write a computer program that will animate a mock
progress bar that goes from 0% to 100% (if you want make it similar to
the one in @fig:progressBar1). You may imitate some complex calculations with
[sleep](https://docs.julialang.org/en/v1/base/parallel/#Base.sleep). In order to
redraw a bar in a terminal you may want to read about [ANSI escape
codes](https://en.wikipedia.org/wiki/ANSI_escape_code). If the above is too much
for you try to use [carriage
return](https://en.wikipedia.org/wiki/Carriage_return),
i.e. `print(progress_bar)`, `print("\r")` and `print(updated_progress_bar)`.

![A mock progress bar (animation works only in an HTML document)](./images/progressBar1.gif){#fig:progressBar1}

## Solution {#sec:progress_bar_solution}

The solution goes here.
