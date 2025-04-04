# About {#sec:about}

Hi, I'm Bart and this is my second open access book entitled:

"Build SH\*T with Julia".

The book contains a set of challenges of varying level of complexity (most
likely in the range of easy to moderate). The exercises are for the problems
that, for whatever reason, I found interesting. The tasks are accompanied by
exemplary solutions in [Julia](https://julialang.org/) (with explanations).
Still, I recommend you try to solve the tasks yourself.

For practical reasons, I will assume this book to be read by curious readers of
non-mathematical (i.e. resembling mine) background. Moreover, I expect that the
readers have already mastered the language basics and now are on a lookout for a
way to hone their newly acquired skills. To that end, I'll imagine you have read
[my previous open access book](https://b-lukaszuk.github.io/RJ_BS_eng/). I'll do
this not not because it is the best book in the world (which it is), but because
of the [DRY principle](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)
(I'm going to apply similar writing conventions without delving too much into
the previously mentioned topics).

Additionally, henceforth I will define a few type aliases, like:

```jl
s = """
const Flt = Float64
const Str = String
const Vec = Vector
"""
sc(s)
```

This will allow for a shorter code when type declarations are used,
e.g. `Vec{Int}` instead `Vector{Int}`. Notice, that the type synonyms are
declared with `const` keyword, since they will not change for as long as a
program runs.

If, for any reason, this book is not to your liking then feel free to visit,
e.g. Adam Wysokinski's the [Big Book of
Julia](https://adamwysokinski.codeberg.page/bbj/) and choose a learning
resource of your liking. Alternatively you may visit [Rosetta Code
web-page](https://rosettacode.org/wiki/Category:Solutions_by_Programming_Task)
that contains over 1'000 programming exercises with solutions in different
programming languages. Chances are many of the exercises presented here are to
be found there.

Finally, just like in the previous book, I'll try to write in a possibly simple
(clarity over cleverness and performance) and correct manner. Still, I'm only
human, so watch out for possible errors and bugs. Anyway, I hope the book will
satisfy your appetite, it is available freely under [Creative Commons
Attribution-NonCommercial-ShareAlike 4.0
International](http://creativecommons.org/licenses/by-nc-sa/4.0/) license.
