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

Anyway, there is this interesting problem called [the prisoner's
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
interact with each other a few hundred of times in their lives, and catch a tick
just as many times. Does this new situation makes a difference, is it worth the
while to be altruistic?

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

The solution goes here.
