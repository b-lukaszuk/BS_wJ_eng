# Bile

Latest update (local time): Sun 15 Sep 2024

## Problem

There are different types of nutrients to be found in food but they can be
broadly divided into three categories, sugars (carbohydrates), proteins and fats
(lipids). Your liver produces [bile](https://en.wikipedia.org/wiki/Bile) that is
stored in gallbladder and released to duodenum (part of small intestine). As far
as I remember my biology classes bile facilitates digestion by breaking large
lipid (fat) droplets into smaller. Thanks to that it increases the surface area
in contact with digestive enzymes (lipases). So much for the theory, but I
always wondered if it's true.

Use Julia to demonstrate that total surface area of a few small lipid droplets
is really greater than the surface area of one big droplet. Of course, the big
droplet and small droplets should contain the same volume of lipids.

## Solution

To me the shape that resembles the droplet the most is
[sphere](https://en.wikipedia.org/wiki/Sphere).  It also got well defined
formulas for surface and volume (see the link above), so this is what we will
use in our solution.

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
function getArea(s::Sphere)::Float64
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
bigA = getArea(bigS)

bigV
"""
sco(s)
```

In the next step we will split this big drop into a few smaller ones. Splitting
the volume is easy, we just divide `bigV` by `n` droplets. However, we need a
way to determine the size (`radius`) of each small droplet. Let's try to
transform the formula for sphere volume.

$v = \frac{4}{3} * \pi * r^3 $ {#eq:sphere1}

If a = b, then b = a, so we swap sides

$\frac{4}{3} * \pi * r^3 = v$ {#eq:sphere2}

The multiplication is commutative (the order does not matter), i.e. 2 * 3 * 4 is
the same as 4 * 3 * 2, therefore we can rearrange elements on the left side of
@eq:sphere2.

$r^3 * \pi * \frac{4}{3} = v$ {#eq:sphere3}

Now, on by one we can more \*$\pi$ and \*$frac{4}{3}\ to the right side of
@eq:sphere3 with the opposite mathematical operation (division instead of
multiplication) to get.

$r^3 = v / \pi / \frac{4}{3}$ {#eq:sphere4}

All that's left to do is to move exponentiation ($x^3$) to the right side of
@eq:sphere4 while changing it to the opposite mathematical operation
($\sqrt[3]{x}$).

$r = \sqrt[3]{v / \pi / \frac{4}{3}}$ {#eq:sphere4}

All that's left to do is to translate it into Julia code.

```jl
s = """
function getSphere(volume::Float64)::Sphere
    radius::Float64 = cbrt(volume / pi / (4/3))
    return Sphere(radius)
end
"""
sc(s)
```

Let's test does it work. Let's say we divide `bigS` (actually its volume:
`bigV`) into 4 smaller drops of the same total volume.

```jl
s = """
smallS = getSphere(bigV/4)
round(getVolume(smallS)*4, digits=2) == round(bigV, digits=2)
"""
sco(s)
```

Once we got that working, it's time to evaluate the total area of different size
droplets.

```jl
s = """
areas = [bigA]
volumes = [bigV]
radii = [bigS.radius]

numsOfDroplets = collect(4:4:12)
for nDrops in numsOfDroplets
    smallS = getSphere(bigV / nDrops)
    smallV = getVolume(smallS)
    smallA = getArea(smallS)
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
want to split our big droplet in (`numsOfDroplets`). For each of those (`for
nDrops`) we determine the radius (`smallS = getSphere`), volume (`smallV`) and
surface area (`smallA`) of a single small droplet as well as total area
(`sumSmallAs`) and total volume (`sumSmallVs`) of `nDrops`.  We add the total
area, total volume and radius of a single droplet to the `areas`, `volumes`, and
`radii` vectors, respectively. In the end we `prepend` 1 to the `numOfDroplets`,
since we started with one big droplet (`bigS`).

Now, we can either examine the vectors (`areas`, `volumes`, `radii`,
`numOfDroplets`) one by one, or do one better and present it on the graph with
e.g. CairoMakie (I'm not going to explain the code below, for reference see [my
previous book](https://b-lukaszuk.github.io/RJ_BS_eng/) or [CairoMakie
tutorial](https://docs.makie.org/stable/tutorials/getting-started)).

```jl
s = """
fig = Cmk.Figure();
Cmk.scatter(fig[1, 1], numsOfDroplets, areas,
            markersize=radii .* 5,
            color="gold1", strokecolor="black",
            axis=(;title="Lipid droplet size vs. summaric surface area",
                  xlabel="number of lipid droplets",
                  ylabel="total surface area [μm²]",
                  xticks=0:13)
            );
Cmk.xlims!(-3, 16)
Cmk.ylims!(800, 3000)
Cmk.text!(fig[1, 1], numsOfDroplets, areas .- 150,
          text=map(r -> "radius: $(round(r, digits=2)) [μm]", radii),
          fontsize=12, align=(:center, :center)
    )
Cmk.text!(fig[1, 1], numsOfDroplets, areas .- 250,
          text=map(r -> "total volume: $(round(r, digits=2)) [μm³]", volumes),
          fontsize=12, align=(:center, :center)
    )
fig
"""
sc(s)
```

Behold.

![Bile. Splitting a big lipid droplet on a few smaller and the effect it has on their total surface area.](./images/bile.png){#fig:bile}

