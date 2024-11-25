# Bile {#sec:bile}

In this chapter may or may not use the following external libraries.

```jl
s2 = """
import CairoMakie as Cmk
import Symbolics as Sym
"""
sc(s2)
```

You may compare your own solution with the one in this chapter's text (with
explanations) of with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/bile)
(without explanations).


## Problem {#sec:bile_problem}

There are different types of nutrients to be found in food, but they can be
roughly divided into: sugars (carbohydrates), proteins and fats (lipids). Your
liver produces [bile](https://en.wikipedia.org/wiki/Bile) that is stored in
gallbladder and released to duodenum (part of small intestine). As far as I
remember my biology classes bile facilitates digestion by breaking large lipid
(fat) droplets into smaller. Thanks to that it increases the total surface area
in contact with digestive enzymes (lipases). So much for the theory, but I
always wondered if that's true.

Use Julia to demonstrate that total surface area of a few small lipid droplets
is actually greater than the surface area of one big droplet. Of course, the big
droplet and small droplets should contain the same volume of lipids.

## Solution {#sec:bile_solution}

To me the shape that resembles the droplet the most is
[sphere](https://en.wikipedia.org/wiki/Sphere). Luckily, it also got well
defined formulas for surface area and volume (see the link above), so this is
what we will use in our solution.

```jl
s = """
struct Sphere
    radius::Float64
end

# formula from Wikipedia
function getVolume(s::Sphere)::Float64
    return (4/3) * pi * s.radius^3
end

# formula from Wikipedia
function getSurfaceArea(s::Sphere)::Float64
    return 4 * pi * s.radius^2
end
"""
sc(s)
```

Now, let's define a big lipid droplet with a radius of, let's say, 10 [μm].

```jl
s = """
bigS = Sphere(10) # 10 um
bigV = getVolume(bigS)
bigA = getSurfaceArea(bigS)

bigV
"""
sco(s)
```

In the next step we will split this big droplet into a few smaller ones of equal
sizes. Splitting the volume is easy, we just divide `bigV` by `n` droplets.
However, we need a way to determine the size (`radius`) of each small droplet.
Let's try to transform the formula for a sphere's volume and see if we can get
radius from that.

$$ v = \frac{4}{3} * \pi * r^3 $$ {#eq:sphere1}

If a = b, then b = a, so we may swap sides.

$$ \frac{4}{3} * \pi * r^3 = v $$ {#eq:sphere2}

The multiplication is commutative (the order does not matter), i.e. 2 * 3 * 4 is
the same as 4 * 3 * 2 or 2 * 4 * 3, therefore we can rearrange elements on the
left side of @eq:sphere2 to:

$$ r^3 * \frac{4}{3} * \pi = v $$ {#eq:sphere3}

Now, one by one we can move \*$\frac{4}{3}$ and \*$\pi$ to the right side of
@eq:sphere3. Of course, we change the mathematical operation to the opposite
(division instead of multiplication) and get:

$$ r^3 = v / \frac{4}{3} / \pi $$ {#eq:sphere4}

All that's left to do is to move exponentiation ($x^3$) to the right side of
@eq:sphere4 while changing it to the opposite mathematical operation
(cube root, i.e. $\sqrt[3]{x}$).

$$ r = \sqrt[3]{v / \frac{4}{3} / \pi} $$ {#eq:sphere5}

Now, you might wanted to quickly verify the solution using
`Symbolic.symbolic_linear_solve` we met in @sec:bat_and_ball_solution.
Unfortunately, we cannot use `r^3` (`r` to the 3rd power) as an argument (and
solve for `r`), since then it wouldn't be a linear equation (to be linear the
maximum power must be equal to 1) required by `_linear_solve`. We could have
used other, more complicated solver, but instead we will keep things simple and
apply a little trick:

```jl
s = """
# fraction - 4/3, p - π, r3 - r^3, v - volume
Sym.@variables fraction p r3 v
Sym.symbolic_linear_solve(fraction * p * r3 ~ v, r3)
"""
sco(s)
```

So, instead of writing the formula as it is, we just named our variables
`fraction`, `p`, `r3` and `v`. Anyway, according to `Sym.symbolic_linear_solve`
$r^3 = v / (\frac{4}{3} * \pi)$, which is actually the same as @eq:sphere4 above
[since e.g. 18 / 2 / 3 == 18 / (2 * 3)]. Ergo, we may be fairly certain we
correctly solved @eq:sphere4 and therefore @eq:sphere5.

Once, we confimed the validity of formula in @eq:sphere5, all that's left to do
is to translate it into Julia code.

```jl
s = """
function getSphere(volume::Float64)::Sphere
    # cbrt - fn that calculates cube root of a number
    radius::Float64 = cbrt(volume / (4/3) / pi)
    return Sphere(radius)
end
"""
sc(s)
```

Time to test how it works. Let's see if we can divide `bigS` (actually its
volume: `bigV`) into 4 smaller drops of total volume equal to `bigV`.

```jl
s = """
isapprox(
    getSphere(bigV / 4) |> getVolume,
    bigV / 4
)
"""
sco(s)
```

Once we got that working, we evaluate the total area of the droplets of
different size.

```jl
s = """
areas = [bigA]
volumes = [bigV]
radii = [bigS.radius]

numsOfDroplets = collect(4:4:12)
for nDrops in numsOfDroplets
    # local variables smallS, smallV, smallA, sumSmallAs, sumSmallVs
    smallS = getSphere(bigV / nDrops)
    smallV = getVolume(smallS)
    smallA = getSurfaceArea(smallS)
    sumSmallAs = smallA * nDrops
    sumSmallVs = smallV * nDrops
    push!(areas, sumSmallAs)
    push!(volumes, sumSmallVs)
    push!(radii, smallS.radius)
end

prepend!(numsOfDroplets, 1)
"""
sc(s)
```

We begin by initializing vectors that will hold the `areas`, `volumes`, and
`radii` of our lipid droplets. Then we define the number of droplets that we
want to split our big droplet into (`numsOfDroplets`). For each of those (`for
nDrops in numsOfDroplets`) we determine the radius (`smallS = getSphere`),
volume (`smallV`) and surface area (`smallA`) of a single small droplet as well
as total area (`sumSmallAs`) and total volume (`sumSmallVs`) of `nDrops`. We
add the total area, total volume and radius of a single droplet to the `areas`,
`volumes`, and `radii` vectors, respectively. In the end we `prepend` 1 to the
`numOfDroplets`, since we started with one big droplet (`bigS`).

BTW. Notice that `smallS`, `smallV`, `smallA`, `sumSmallAs`, `sumSmallVs` are
all local variables defined for the first time in the `for` loop and visible
only inside of it. If you try to print out their values outside of the loop you
will get an error like `ERROR: UndefVarError: 'smallS' not defined`.

Anyway, now, we can either examine the vectors (`areas`, `volumes`, `radii`,
`numOfDroplets`) one by one, or do one better and present them on a graph with
e.g. CairoMakie (I'm not going to explain the code below, for reference see [my
previous book](https://b-lukaszuk.github.io/RJ_BS_eng/) or [CairoMakie
tutorial](https://docs.makie.org/stable/tutorials/getting-started)).

<pre>
fig = Cmk.Figure();
ax = Cmk.Axis(fig[1, 1],
              title="Lipid droplet size vs. summaric surface area",
              xlabel="number of lipid droplets",
              ylabel="total surface area [μm²]", xticks=0:13);
Cmk.scatter!(ax, numsOfDroplets, areas, markersize=radii .* 5,
             color="gold1", strokecolor="black");
Cmk.xlims!(ax, -3, 16);
Cmk.ylims!(ax, 800, 3000);
Cmk.text!(ax, numsOfDroplets, areas .- 150,
    text=map(r -> "radius: $(round(r, digits=2)) [μm]", radii),
    fontsize=12, align=(:center, :center)
);
Cmk.text!(ax, numsOfDroplets, areas .- 250,
    text=map(r -> "total volume: $(round(r, digits=2)) [μm³]", volumes),
    fontsize=12, align=(:center, :center)
);
fig
</pre>

Behold.

![Bile. Splitting a big lipid droplet into a few smaller one and the effect it has on their total surface area.](./images/bile.png){#fig:bile}

So it turns out that what they taught me in the school all those years ago is
actually true. But only now I can finally see it. Nice.
