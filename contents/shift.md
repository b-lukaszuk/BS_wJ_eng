# Shift {#sec:shift}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise.

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/shift)
(without explanations).

## Problem {#sec:shift_problem}

Imagine that one day you were looking for a radio station that plays a good
music. You searched through a range of different frequencies and found a strange
gibberish on one of them. You recorded it and used speech to text conversion
tool to obtain the content of `trarfvf.txt` ([see the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/shift)).

It turns out the text got some regularity, so it might be a coded message. A
simple method to code something is to use a shift cipher (see @fig:codingDiscs).

![Coding Discs. The outer disc contains the original alphabet. The inner disc
contains the alphabet shifted by 2
characters](./images/codingDiscs.png){#fig:codingDiscs}

To that end you cut two discs out of paper with all the characters from the
alphabet on them. You shift the inner disk by a certain number of fields (+2
under A in @fig:codingDiscs). In order to encode a letter you move the red tick
around the circle to that character (in the outer circle). Next you read the
encoded letter in the inner circle (as pointed by the tick). If a letter or a
symbol from the original text is not in the disk you just retype it as it is.

This way, coding the phrase "JULIA :)" with shift +2 from @fig:codingDiscs would
give us "LWNKC :)"

Anyway, here is a task for you. Use a [frequency
analysis](https://en.wikipedia.org/wiki/Letter_frequency) to figure out the
shift (rotation) used to code the message found in `trarfvf.txt`.

## Solution {#sec:shift_solution}

The solution goes here.
