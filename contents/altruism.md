# Altruism {#sec:altruism}

In this chapter you may or may not use the following external libraries.

```jl
s2 = """
import Random as Rnd
"""
sc(s2)
```

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/altruism)
(without explanations).

## Problem {#sec:altruism_problem}

The following problem was inspired by the lecture of a Richard Dawkins' book and
his considerations about altruism. Alas, I borrowed the book and it's been
like 15-20 years since I read it, so I don't even remember its title. Shortly,
if I mess things up, the fault is mine.

Anyway, there is this interesting game theory problem called [the prisoner's
dilemma](https://en.wikipedia.org/wiki/Prisoner%27s_dilemma). Imagine two
accomplices being interrogated by the police for the crime they committed. The
investigators separate them and try to convince them to testify against each
other (good cop, bad cop isn't it):

- if both of them remain silent, there is enough evidence to sentence them for
  one year each
- if both of them incriminate each other, each of them faces the sentence of two
  years in prison
- if one of them tells on the other (but the other remains silent), then the
  informer is free to go and the other person serves three years sentence

Imagine, that you are one of the two. Pause for a moment and think which is the
best option for you (use pure logic, not emotions, it is guaranteed that nobody
will know what you did).

If you stay silent you will be punished for sure, if you betray then you may
walk away free. That being said, the betrayal is often considered to be the
optimal strategy.

You could say that was a no-brainer, but the problem is deeper than you may
think.  Imagine there are two monkeys each got a
[tick](https://en.wikipedia.org/wiki/Tick) on their back that they cannot
remove themselves. A tick decreases survival of an animal (it spreads diseases),
so does the removal of the tick (less time to find food). Therefore assume that,
when:

- one monkey betrays the other, the winner gets 3 survival points, the looser
  gets -2 points
- both monkeys cooperate they get +2 survival points each
- both monkeys refuse to help each other, each looses 1 survival point

To make it more realistic assume that the monkeys are neighbors that will
interact with each other a few hundred times in their lives (but they don't know
exactly how long), and get a tick just as many times. Does this new situation
makes a difference, is it worth the while to be altruistic?

Let's use Julia to answer that question. To that end we assume there are 6
monkeys in the group:

- three good:
  + naive - it always cooperates
  + unforgiving - if you betray it more than three times, it will never trust
    you again
  + paybacker - first it cooperates, then it replays its partner's last move
- three evil:
  + unfriendly - got a bad mood at random and may betray with the probability of
    30% (p = 0.3)
  + abusive - got a bad mood at random and may betray with the probability of
    80% (p = 0.8)
  + egoist - always betrays its partner

Test which monkey ends on top if every animal interacts a random number of times
(let's say 50 to 300 times) with all the other animals.

Does it make a difference, if you replace the unforgiving monkey with a gullible
one (it cooperates at random 80% of the times)?

> **_Note:_** You don't need to strictly adhere to the above task
> description, feel free to adjust it to your level/liking.

## Solution {#sec:altruism_solution}

Since this is a game theory problem, then we're going to use game terminology in
the solution. Ready. Let the games begin.

First, let's define all the possible values for players (i.e. monkeys)
and moves (i.e. choices) by using Julia's
[enums](https://docs.julialang.org/en/v1/base/base/#Base.Enums.Enum).

```jl
s = """
@enum Player naive unforgiving paybacker unfriendly abusive egoist
@enum Choice cooperate=0 betray=1
"""
sc(s)
```

Now, whenever we use `Player` in our code (as a variable type) we will be able
to use one of the six informative and mnemonic names (`naive unforgiving
paybacker unfriendly abusive egoist`). The same goes for `Choice` our players
will make (`cooperate` and `betray`). Note, however, that in this last case the
`Choices` are followed by the number code. We didn't have to do that since by
default the enums are internally stored as consecutive integers that start
at 0. Still, we did it to emphasize our plan to use this property of our new
type in the near future.

We did this because per problem description `unforgiving` monkey always betrays
its partner when it was itself betrayed more than three times in the past. To
that end we will need to count the betrayals.

```jl
s = """
import Base: +

function +(c1::Choice, c2::Choice)::Int
    return Int(c1) + Int(c2)
end

function +(n::Int, c::Choice)::Int
    return n + Int(c)
end
"""
sc(s)
```

We start by importing the `+` function from `Base` package and make the
versions of it (aka methods) that know how to handle our `Choice` enum. Simply,
if we add two `Choices` (`c1` and `c2`) together, we add the underlying integers
(`Int(c1) + Int(c2)`) and when we add an integer (`n`) to a `Choice` then again
we add the integer to the `Choice`'s integer representation (`n + Int(c)`).
Thanks to this little trick, we will be able to count the total of
betrayals in a vector of `Choice`s with the build in `sum` function (it relies
on `+`)

> **_Note:_** Do not overuse this technique. In general, you should redefine the
> built in `Base` functions (like `+`) only on the types that you have defined
> yourself.

Time to write a function that will return the Player's move. According to the
problem description all it needs know to do its job correctly is the `Player`'s
type and its opponents previous moves.

```jl
s = """
import Random as Rnd

function getMove(p::Player, opponentMoves::Vec{Choice})::Choice
    prob::Flt = Rnd.rand() # random float in range [0.0-1.0)
    if p == naive
        return cooperate
    elseif p == unforgiving
        return sum(opponentMoves, init=0) > 3 ? betray : cooperate
    elseif p == paybacker
        return isempty(opponentMoves) ? cooperate : opponentMoves[end]
    elseif p == unfriendly
        return prob <= 0.3 ? betray : cooperate
    elseif p == abusive
        return prob <= 0.8 ? betray : cooperate
    else # egoist player
        return betray
    end
end
"""
sc(s)
```

The function is a bit cumbersome to type because Julia does not have [a switch
statement](https://en.wikipedia.org/wiki/Switch_statement) known from other
programming languages. If you really must have it, then consider using
[Match.jl](https://github.com/JuliaServices/Match.jl) as a replacement. Anyway,
the code is pretty simple if you are familiar with [the decision making in
Julia](https://b-lukaszuk.github.io/RJ_BS_eng/julia_language_decision_making.html). One
point to notice is that here we used the `init=0` keyword argument in `sum`.
This is a default value from which we start counting the total, and it makes
sure that an empty vector (`sum(opponentMoves, init=0)`) returns `0` instead of
an error.

Time to award our players with survival points per a round (interaction) and
their choices.

```jl
s = """
function getPts(c1::Choice, c2::Choice)::Tuple{Int, Int}
    if c1 == c2 == cooperate
        return (2, 2)
    elseif c1 > c2
        return (3, -2)
    elseif c1 < c2
        return (-2, 3)
    else # both betray
        return (-1, -1)
    end
end
"""
sc(s)
```

Notice, that the `enum` defined by us (`Choice`) got a built in ordering that by
default goes in an ascending order from left to right (`cooperate` < `betray`
per `@enum Choice cooperate betray`) which we used to our advantage here.

Time to write a function that takes two players as an argument and runs a random
number of games (50:300 interactions) between them. In the end it returns the
survival points each player obtained.

```jl
s = """
function playRoundsGetPts(p1::Player, p2::Player)::Tuple{Int, Int}
    pts1::Int, pts2::Int = 0, 0 # total pts
    pt1::Int, pt2::Int = 0, 0 # pts per round
    mvs1::Vec{Choice}, mvs2::Vec{Choice} = [], [] # all moves
    mv1::Choice, mv2::Choice = cooperate, cooperate # move per round
    nRounds::Int = Rnd.rand(50:300)
    for _ in 1:nRounds
        mv1, mv2 = getMove(p1, mvs2), getMove(p2, mvs1)
        pt1, pt2 = getPts(mv1, mv2)
        push!(mvs1, mv1)
        push!(mvs2, mv2)
        pts1 += pt1
        pts2 += pt2
    end
    return (pts1, pts2)
end
"""
sc(s)
```

We begin by defining and initializing variables to store:

1) total number of points obtained by each player (`pts1`, `pts2`)
2) the number of points obtained by the players per single interaction (`pt1`, `pt2`)
3) all the moves made by the players during their interactions (`mvs1`, `mvs2`)
4) the moves made by each player per single interaction (`mv1`, `mv2`)
5) the number of interactions (rounds) between the players (`nRounds`)

We update the above mentioned variables after every round/interaction took place
(in the `for` loop). Finally, we return the number of points obtained by each
player.

Time to set things into motion and make all the players play with each other.

```jl
s = """
function playGame()::Dict{Player, Int}
    players::Vec{Player} = [
        naive, unforgiving, paybacker, unfriendly, abusive, egoist]
    playersPts::Dict{Player, Int} = Dict(p => 0 for p in players)
    alreadyPlayed::Dict{Player, Bool} = Dict()
    for player1 in players, player2 in players
		if player1 == player2 || haskey(alreadyPlayed, player2)
			continue
        end
        pts1, pts2 = playRoundsGetPts(player1, player2)
        playersPts[player1] += pts1
        playersPts[player2] += pts2
        alreadyPlayed[player1] = true
    end
    return playersPts
end
"""
sc(s)
```

Again, we start by initializing the necessary variables: list of players
(`players`), the result (`playersPts`) and players that already played in our
game (`alreadyPlayed`). Next, we use Julia's simplified nested for loop syntax
(that we met in @sec:mat_multip_solution) to make all players play with each
other. We prevent the player playing with themselves (`player1 == player2`). We
also stop the players from playing with each other two times. Without
`haskey(alreadyPlayed, player2)`, e.g. `naive` would play with `egoist` twice
[once as `player1` (`naive` vs `egoist`), the other time as `player2` (`egoist`
vs `naive`)]. We update the points scored by each player after every pairing
(`playerPts[player1] += pts1`, `playerPts[player2] += pts2`) and return them as
a result (`return playersPts`).

Let's see how it works.

```jl
s = """
Rnd.seed!(401) # needed to make it reproducible
playGame()
"""
sco(s)
```

First three competitors (monkeys) are: `unforgiving` followed by `egoist`
and `paybacker`. Run the simulation a couple of times (with different `seed`s)
and see the results. In general the good players (monkeys) win the podium with
the evil ones in 2:1 (sometimes even 3:0) ratio.

Interestingly, if we replace the `unforgiving` with `gullible` (it cooperates at
random 80% of the times) we get something entirely different.

<pre>
Rnd.seed!(401) # needed to make it reproducible
playGame()
</pre>

<pre>
Dict{Player, Int64} with 6 entries:
 paybacker => 470
 gullible => 386
 unfriendly => 538
 abusive => 378
 naive => 240
 egoist => 899
</pre>

The situation seems to be reversed, The evil players (monkeys) win the podium
with the good ones in 2:1 ratio. So I guess: "The only thing necessary for evil
to triumph in the world is that [good men do
nothing](https://en.wikipedia.org/?title=The_only_thing_necessary_for_evil_to_triumph_in_the_world_is_that_good_men_do_nothing&redirect=no)"
