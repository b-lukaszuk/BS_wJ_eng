# Logo {#sec:logo}

In this chapter you may or may not use the following external libraries.

```jl
s2 = """
import CairoMakie as Cmk
"""
sc(s2)
```

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/logo)
(without explanations).

## Problem {#sec:logo_problem}

Julia is a nice programming language with over 10'000 registered packages for
community use. Some of them come with cool logos.

In this task your job is to use you favorite plotting library to reproduce the
logo of [JuliaStats](https://juliastats.org/) that you may find
[here](https://juliastats.org/images/logo.png) (it doesn't have to be exact).

## Solution {#sec:logo_solution}

The logo is composed of three disks build of points (scatter-plot) of three
colors, red, green and purple. So let's start small and try to replicate it by
placing the points on a graph in correct locations.

```jl
s = """
function drawLogo()::Cmk.Figure
    centersXs::Vec{Flt} = [1, 5.5, 10]
    centersYs::Vec{Flt} = [1, 6, 1]
    colors::Vec{Str} = ["red", "green", "purple"]
    fig::Cmk.Figure = Cmk.Figure()
    ax::Cmk.Axis = Cmk.Axis(fig[1, 1])
    Cmk.scatter!(ax, centersXs, centersYs, color=colors, markersize=50)
    return fig
end
"""
sc(s)
```

The function if pretty simple. First we defined the locations of the points
with respect to the x- (`centersXs`) and y-axis (`centersYs`), as well as their
colors. Next we added the points (`scatter!`) to the axis object (`ax`) attached
to the figure object (`fig`).

Time to take a look.

<pre>
drawLogo()
</pre>

![Replicating JuliaStats logo. Attempt 1.](./images/logo1.png){#fig:logo1}

So far, so good. Now instead of a 1 big point we will need a few thousand
smaller points (let's say `markersize=10`) concentrated around the center of a
given group. Moreover, the points should be partially transparent [to that end
we will use `alpha` keyword argument (`alpha=0` - fully transparent, `alpha=1` -
fully opaque)]. One more thing, the points need to be randomly scattered, but
with a greater density closer to the group's center. This last issue will be
solved by obtaining random numbers from [the normal
distribution](https://b-lukaszuk.github.io/RJ_BS_eng/statistics_normal_distribution.html)
with mean = 0 and the standard deviation = 1. This is what `randn` function will
do. Thanks to this a roughly 68% of the numbers will be in the range -1 to 1,
95% in the range -2 to 2, and 99.7% in the range -3 to 3 (greater density around
the mean). Behold.

```jl
s1 = """
function drawLogo()::Cmk.Figure
    centersXs::Vec{Flt} = [1, 5.5, 10]
    centersYs::Vec{Flt} = [1, 6, 1]
    colors::Vec{Str} = ["red", "green", "purple"]
	numOfPoints::Int = 3000
    fig::Cmk.Figure = Cmk.Figure()
    ax::Cmk.Axis = Cmk.Axis(fig[1, 1])
    for i in eachindex(colors)
        Cmk.scatter!(ax,
                     centersXs[i] .+ Rnd.randn(numOfPoints),
                     centersYs[i] .+ Rnd.randn(numOfPoints),
                     color=colors[i], markersize=10, alpha=0.25)
    end
    return fig
end
"""
sc(s1)
```

Let's test it.

<pre>
Rnd.seed!(303) # needed to make it reproducible
drawLogo()
</pre>

![Replicating JuliaStats logo. Attempt 2.](./images/logo2.png){#fig:logo2}

Nice. `CairoMakie` nicely centered the plot, so we don't need to do this
ourselves manually.

Our work is almost done. All that's left to do is to remove the unnecessary
elements from the picture. A brief look into the documentation of the package
indicates that [hidedecorations and
hidespines](https://docs.makie.org/v0.21/reference/blocks/axis#Hiding-Axis-spines-and-decorations)
should do the trick.

```jl
s2 = """
function drawLogo()::Cmk.Figure
    centersXs::Vec{Flt} = [1, 5.5, 10]
    centersYs::Vec{Flt} = [1, 6, 1]
    colors::Vec{Str} = ["red", "green", "purple"]
    numOfPoints::Int = 3000
    fig::Cmk.Figure = Cmk.Figure()
    ax::Cmk.Axis = Cmk.Axis(fig[1, 1])
    Cmk.hidedecorations!(ax)
    Cmk.hidespines!(ax)
    for i in eachindex(colors)
        Cmk.scatter!(ax,
                     centersXs[i] .+ Rnd.randn(numOfPoints),
                     centersYs[i] .+ Rnd.randn(numOfPoints),
                     color=colors[i], markersize=10, alpha=0.25)
    end
    return fig
end
"""
sc(s2)
```

And voila.

<pre>
Rnd.seed!(303) # needed to make it reproducible
drawLogo()
</pre>

![Replicating JuliaStats logo. Attempt 3.](./images/logo3.png){#fig:logo3}

We obtained a decent replica of the original. Of course, kudos go to the authors
of the original image for their creativity and artistic taste.
