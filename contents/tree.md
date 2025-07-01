# Tree {#sec:tree}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/tree)
(without explanations).

## Problem {#sec:tree_problem}

There is this nice little command
[tree](https://en.wikipedia.org/wiki/Tree_(command)) that recursively lists
files and subdirectories in a given location. Let's try to get some of that with
Julia.

Write a function `printCatalogTree` that for a given directory it prints its
contents, like so (the output doesn't have to be exact):

```
~/Desktop/catalog_x
|---catalog_y/
|   |---catalog_z/
|   |   |---file_y.txt
|   |---file_y.txt
|---file_x.txt

2 directories, 3 files
```

If your stuck, you may start by reading about Julia's
[Filesystem](https://docs.julialang.org/en/v1/base/file/).

## Solution {#sec:tree_solution}

The solution goes here.
