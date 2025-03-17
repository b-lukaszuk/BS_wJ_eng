# Toothpaste {#sec:toothpaste}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/toothpaste)
(without explanations).

## Problem {#sec:toothpaste_problem}

There is a story (perhaps it is just an urban legend) that in the the 1960s a
toothpaste manufacturer faced a financial crisis. They were desperate to make
the sales go up, but nothing seemed to work. Finally, a guy came by and offered
to increase their sales by at least 50% in exchange for $100'000. At first the
company declined the proposal on account of being to expensive and coming from a
person with no track record. However, after a year the management saw no other
option, but to accept the offer. After all the legal details were set, the guy
spoke only one sentence: "Make the hole bigger".

> **_Note:_** $100'000 may not sound like a tone of money today, but if you
> update it for an inflation rate of let's say 3.6% you will get roughly
> $1'000'000. Example calculations: 100'000*(1.036^65) $\approx$ 996'000'000. In
> that case 65 is the number of years between 1960 and 2025, whereas 1.036 is
> how much more money you must spend every year on the same product due to the
> assumed inflation).

Try to figure out does making the hole bigger actually moves the sales up by
$\geq$ 50%. Test different scenarios, e.g. different initial hole size, and
see what would have happened if the customers tried to counteract this idea by
squeezing less toothpaste (shorter strip) on the toothbrush.

## Solution {#sec:toothpaste_solution}

First, let me define some abbreviations to use in the code later on.

<pre>
const Vec = Vector
const Flt = Float64
</pre>

Now, based on my own observations I would say that a
[cylinder](https://en.wikipedia.org/wiki/Cylinder) is a good approximation of
the toothpaste that is squezed out of the tube. Time to define some helper
functions that will help us to evaluate the amount of a toothpaste on a
toothbrush.

```jl
s = """
struct Cylinder
    radius::Int
    height::Int
end

function getVolume(c::Cylinder)::Flt
    return c.height * pi * c.radius^2
end
"""
sc(s)
```

We will skip the detailed explanations, as the above are just translations of
the Wikipedia's formulas into Julia's code.

Now, in order to answer how much the sales will increase we need to estimate the
increase in our toothpaste's usage when the radius and height of our cylinder
changes.

```jl
s = """
function getRatios(cylinders::Vec{Cylinder},
                   radiusChange::Int, heightChange::Int)::Vec{Flt}
    ratios::Vec{Flt} = []
    for cyl1 in cylinders
        # newRadius, newHeight, cyl2, vol1, vol2 - local variables
		# visible only in the for loop
        newRadius = cyl1.radius + radiusChange
        newHeight = cyl1.height + heightChange
        cyl2 = Cylinder(newRadius, newHeight)
        vol1 = getVolume(cyl1)
        vol2 = getVolume(cyl2)
        push!(ratios, round(vol2/vol1, digits=2))
    end
    return ratios
end
"""
sc(s)
```

To that end we defined the `getRatios` function that accepts a vector of
`cylinders` and the number by which we change their radiuses (`radiusChange`)
and heights (`heightChange`). `for` each cylinder (`cyl1`) in the initial
`cylinders` we create its counterpart `cyl2` with the applied size changes.
Next, we obtain the volumes (`vol1` and `vol2`) for the two cylinders. All
that's left to do is to `push` the volume ratio (`vol2/vol1`) into the vector of
results (`ratios`) and to `return` it from the function.

Time to test some scenarios.

### Scenario 1

We increase the radius of the hole. We assume the change is so small that the
customers wouldn't notice (the height remains constant).

```jl
s = """
# radius and height in millimeters
# radius+1, height = const
getRatios(Cylinder.(1:5, 5), 1, 0) .* 100
"""
sco(s)
```

> **_Note:_** `Cylinder.(1:5, 5)` creates a vector of `Cylinder`s with different
> radii (1:5) and the same height (5). Moreover, we multiplied (`.*`) the
> obtained vector of ratios by 100 in order to obtain the change expressed in %.

The data demonstrates that the smaller the initial hole the greater the increase
in our toothpaste consumption and therefore the expected sales growth (here in
the range of +300% to +44%).

### Scenario 2

We increase the radius of the hole, and observe what happens with the
consumption of our product if the customers try to squeeze less (shorter strip)
of our toothpaste by the very same amount that we increased our radius.

```jl
s = """
# radius and height in millimeters
# radius+1, height-1
getRatios(Cylinder.(1:5, 5), 1, -1) .* 100
"""
sco(s)
```

Again, we observe a significant growth (although smaller than in the previous
scenario) in toothpaste consumption and expected sales (here in the range of
+220% to +15%).

### Scenario 3

We increase the radius of the hole, and observe what happens with the
consumption of our product if the customers try to squeeze less of our
toothpaste (they decrease the length of the strip by two units, when we changed
the radius by one unit).

```jl
s = """
# radius and height in millimeters
# radius+1, height-2
getRatios(Cylinder.(1:5, 5), 1, -2) .* 100
"""
sco(s)
```

This time the result is inconclusive, because in the two last cases the
customers actually use less of our product, and therefore the sales are expected
to drop.

### Conclusions

In summary, we see that increasing the radius of the whole in a toothpaste is
an effective strategy to increase the sales of our product. However, we should
restrain ourselves and not overdo it, since if the customers notice they may
squeeze shorter toothpaste strips which may undermine our efforts (or even
backfire on us).
