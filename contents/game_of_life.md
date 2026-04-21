# Game of Life {#sec:game_of_life}

In this chapter I did not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

I recommend you try to solve the task on your own first. Once you finish you may
compare your own solution with the one in this chapter (with explanations) or
with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/game_of_life)
(without explanations).

## Problem {#sec:game_of_life_problem}

Let's finish with another classic. This time your job is to implement [Conway's
Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life) with a
finite two dimensional grid called the universe. Each cell on the grid
got some initial probability (let's say [0.2-0.5]) of being alive. Per the Wikipedia's
description the next state of the universe is calculated as follows:

> 1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
> 2. Any live cell with two or three live neighbours lives on to the next generation.
> 3. Any live cell with more than three live neighbours dies, as if by overpopulation.
> 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.

The end result may look something like @fig:gameOfLife.

![A frame from the Conway's Game of Life.](./images/gameOfLife.png){#fig:gameOfLife}

## Solution {#sec:game_of_life_solution}

The solution goes here.
