# Vigenere {#sec:vigenere}

In this chapter you may or may not use the following external libraries.

```jl
s4 = """
import CairoMakie as Cmk
"""
sc(s4)
```

You may compare your own solution with the one in this chapter's text (with
explanations) or with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/vigenere)
(without explanations).

## Problem {#sec:vigenere_problem}

Let's continue on the topic of ciphers. This time your task is to read the
Wikipedia's description on [the Vigenère
cipher](https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher) and write a program
that allows for coding and decoding of messages with it. Use the Wikipedia's
minimal test to make sure it works correctly, i.e. "attacking tonight" coded
with the key "oculorhinolaryngology" should return "ovnlqbpvt hznzeuz".

Once you got it, use it to code the text in `genesis.txt` (to be found
[here](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/vigenere))
with a passphrase: "Julia rocks, believe in its magic." and compare the letters
distribution in the text before and after coding.  Pause for a moment and think
can the new cipher be easily broken by a frequency analysis we used in
@sec:shift.

## Solution {#sec:vigenere_solution}

The solution goes here.
