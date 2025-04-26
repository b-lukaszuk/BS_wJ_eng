# Recursion {#sec:recursion}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/matrix_multiplication)
(without explanations).

## Problem {#sec:recursion_problem}

[Recursion](https://en.wikipedia.org/wiki/Recursion_(computer_science)) is a
programming technique where a function invokes itself. It relies on two simple
principles:

1. know when to stop
2. split the problem into a single step and a smaller problem

And that's it. Let's see how this works in practice.

For that we'll write a recursive function that sums the elements of a vector of
integers.

```jl
s = """
function recSum(v::Vec{Int})::Int
    if isempty(v)
        return 0
    else
        return v[1] + recSum(v[2:end])
    end
end
"""
sc(s)
```

We begin by defining our edge case (know when to stop). If the vector (`v`) is
empty (`if isempty(v)`) we return 0 (BTW. Notice that zero is a neutral
mathematical operation for addition, any number plus zero is just itself).
Otherwise (`else`) we add the first element of the vector (`v[1]`, single step)
to whatever number is returned by `recSum` with rest of the vector (`v[2:end]`)
as an argument (smaller problem).

Time for a couple of examples.

For

```jl
s = """
recSum([1])
"""
sco(s)
```

the execution of the program looks something like

```
recSum([1]) # triggers else branch
	1 + recSum([]) # triggers if branch (stop)
		1 + 0 # stop reached, time to return
1
```

Whereas for

```jl
s = """
recSum([1, 2, 3])
"""
sco(s)
```

we get

```
recSum([1, 2, 3]) # triggers else branch
	1 + recSum([2, 3]) # triggers else branch
		1 + 2 + recSum([3]) # triggers else branch
			1 + 2 + 3 + recSum([]) # triggers if branch (stop)
				1 + 2 + 3 + 0 # stop reached, time to return
6
```

Although difficult to imagine `recSum` works equally well for broader range of
numbers.

```jl
s = """
1:100 |> collect |> recSum
"""
sco(s)
```

Believe it or not, but that last one you can calculate fairly easily yourself if
you apply [the Gauss
method](https://www.nctm.org/Publications/TCM-blog/Blog/The-Story-of-Gauss/).

Anyway, usually recursion is not very effective and it can be rewritten with
loops. Still, for some problems it is an easy to implement and elegant
solution. Therefore, it worth to have this technique in your programming
toolbox.

Classical examples of recursive process in action are
[factorial](https://en.wikipedia.org/wiki/Factorial) and [Fibonacci
sequence](https://en.wikipedia.org/wiki/Fibonacci_sequence). For this task your
job is to implement the functions to calculate both the numbers.

## Solution {#sec:recursion_solution}

The solution goes here.
