# Transcription {#sec:transcription}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you (you're an adult, right?) go and get it.

You may compare your own solution with the one in this chapter's text (with
explanations) of with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/transcription)
(without explanations).

## Problem {#sec:transcription_problem}

The genetic material of an eucariotic cell is located in its nucleus in the form
of a nucleic acid ([DNA](https://en.wikipedia.org/wiki/DNA) to be precise). At
one point DNA fragments serve as matrices to produce proteins that build our
bodies and perform some actions within it (e.g. like hormones). Such a
transformation takes two steps called
[transcription](https://en.wikipedia.org/wiki/Transcription_(biology)) and
[translation](https://en.wikipedia.org/wiki/Translation_(biology)).

During the first process, DNA's double helix is unwind and one of the strands
(called template strand) is rewritten to mRNA (hence transcription) according to
the table presented below.

<pre>
 DNA | mRNA
-----+------
 'c' | 'g'
 'g' | 'c',
 'a' | 'u',
 't' | 'a'
</pre>

Here: `a`, `c`, `g`, `t`, `u` are the shortcuts (also written in uppercase) for
the nucleic acids' molecular components (nucleotide bases) called `adenine`,
`cytosine`, `guanine`, `thymine`, and `uracil`.

And here is your task. Read the data from the file:
`dna_seq_template_strand.txt` (to be found in [the code snippets for this
chapter](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/transcription)).
The file contains a sequence of nucleotide bases of some gene. Splice its coding
parts (aka. [exons](https://en.wikipedia.org/wiki/Exon)), which encompass the
molecules at positions 2424-2610 and 3397-3542. Transcribe the obtained strand
to an mRNA molecule according to [the complementarity
rule](https://en.wikipedia.org/wiki/Complementarity_(molecular_biology)#DNA_and_RNA_base_pair_complementarity)
presented in the table above.

## Solution {#sec:transcription_solution}

The solution

```jl
s = """
struct Sphere
    radius::Float64
end
"""
sc(s)
```
End of solution
