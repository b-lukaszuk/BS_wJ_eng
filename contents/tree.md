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
~/Desktop/catalog_x/
|---catalog_y/
|   |---catalog_z/
|   |   |---file_z.txt
|   |---file_y.txt
|---file_x.txt

2 directories, 3 files
```

If your stuck, you may start by reading about Julia's
[Filesystem](https://docs.julialang.org/en/v1/base/file/).

## Solution {#sec:tree_solution}

Let's start small with an initial definition of `printCatalogTree`.

```jl
s1 = """
function printCatalogTree(path::Str, pad::Str)
    for name in readdir(path)
        newPath::Str = joinpath(path, name)
        newPad::Str = pad * "   "
        if isfile(newPath)
            println(newPad, name)
        else
            println(newPad, name, "/")
            printCatalogTree(newPath, newPad)
        end
    end
    return nothing
end

function printCatalogTree(path::Str)
    println(path, "/")
    printCatalogTree(path, "")
    return nothing
end
"""
sc(s1)
```

The function is rather simple. We walk through every entry (`for name`) in the
examined directory (`path`). As we go `name` is converted to `newPath` which
will be examined in a moment. If `newPath` is a file (`isfile`) we just print
it, otherwise (`else`) it is a directory and we print it with `"/"` to
make it stand out. Moreover we go inside it with `printCatalogTree` (recursive
call) to print its contents. For every nesting of `printCatalogTree` we update
the padding `newPad` by increasing the left side indentation with `* " "`. We
conclude with another version of `printCatalogTree`, the method will make its
invocation slightly easier and will add a header line for us.

Let's see how it works (remember to create `catalog_x`, with its contents, on
the desktop first).

```
printCatalogTree(joinpath(homedir(), "Desktop", "catalog_x"))
```

```
/home/user_name/Desktop/catalog_x/
   catalog_y/
      catalog_z/
         file_z.txt
      file_y.txt
   file_x.txt
```

It looks quite alright. Time to replace the spaces on the left with some
guideways that we may follow with our eyes.

```jl
s2 = """
function printCatalogTree(path::Str, pad::Str)
    for name in readdir(path)
        newPath::Str = joinpath(path, name)
        newPad::Str = pad * "---"
        if isfile(newPath)
            println(newPad, name)
        else
            println(newPad, name, "/")
            printCatalogTree(newPath, pad * "   |")
        end
    end
    return nothing
end

function printCatalogTree(path::Str)
    println(path, "/")
    printCatalogTree(path, "|")
    return nothing
end
"""
sc(s2)
```

To that end we changed the `pad`s. We begin with the first column on the left
that should start with the pipe character (`printCatalogTree(path, "|")`). Each
line containing a file or directory should continue with hyphens "---"
(`newPad::Str = pad * "---"`), whereas a nested directory and its contents
should be indented and start with the pipe character as well
(`printCatalogTree(newPath, pad * " |")`). Let's see did it work as intended.

```
/home/user_name/Desktop/catalog_x/
|---catalog_y/
|   |---catalog_z/
|   |   |---file_z.txt
|   |---file_y.txt
|---file_x.txt
```
