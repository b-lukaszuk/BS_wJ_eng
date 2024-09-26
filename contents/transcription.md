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

The file `dna_seq_template_strand.txt` is quite small as you can see by using
your file manager or Julia

```jl
s = """
# in 'code_snippets' folder use: "./transcription/dna_seq_template_strand.txt"
# in 'transcription' folder use: "./dna_seq_template_strand.txt"
const filePath = "./code_snippets/transcription/dna_seq_template_strand.txt"
filesize(filePath)
"""
sco(s)
```

Here we defined `filePath` to our file with
[const](https://docs.julialang.org/en/v1/base/base/#const) keyword, to signify
that we do not plan to change the value for as long as the program runs.  Next,
we checked its size with
[filesize](https://docs.julialang.org/en/v1/base/file/#Base.filesize) to see it
is equal to `jl filesize(filePath)` bytes. This is slightly more than
 `jl round(Int, filesize(filePath) / 1024)` kilobytes (KiB). Such a small file
 can be easily swallowed by
 [read](https://docs.julialang.org/en/v1/base/io-network/#Base.read) and
 returned as a one long `String`.

```jl
s = """
dna = read(filePath, String)
dna[1:80]
"""
replace(sco(s), Regex("\ncggtcccac") => "\\\\ncggtcccac")
```

The nucleotide bases (`a`, `c`, `t`, `g`) are grouped by 10. Moreover, notice
the `\n` character on the right. It is a
[newline](https://en.wikipedia.org/wiki/Newline) character that tells the
computer to print the subsequent characters from a new line. We need to splice
sequence at positions 2424-2610 and 3397-3542 so let's get rid of those extra
characters to make the counting easier.


```jl
s = """
dna = replace(dna, " " => "", "\n" => "")
dna[1:80]
"""
sco(s)
```

This couldn't be simpler, we just use `replace` and `itIs => shouldBe` syntax.
The spaces (`" "`) are replaced with nothing (`""`, empty string) and newlines
(`"\n"`) with nothing (`""`, empty string) as well. Efectively this removed them
from our `dna` string.

String splicing is easily done with indexing and string concatenation opeartor
(`*`) like so.

```jl
s = """
dnaExonsOnly = dna[2424:2610] * dna[3397:3542]
dnaExonsOnly[1:80]
"""
sco(s)
```

All that's left to do is to transcribe to mRNA using the complementarity rule
mentioned above. First, let's rewrite it to Julia's
[dictionary](https://b-lukaszuk.github.io/RJ_BS_eng/julia_language_decision_making#sec:julia_language_dictionaries).

```jl
s = """
dna2mrna = Dict(
    'a' => 'u',
    'c' => 'g',
    'g' => 'c',
    't' => 'a'
)
"""
sc(s)
```

An now the transcription itself.

```jl
s = """
function transcribe(
    nucleotideBase::Char,
    complementarityMap::Dict{Char, Char} = dna2mrna
    )::Char
    return get(dna2mrna, nucleotideBase, nucleotideBase)
end

(
	transcribe('a'),
	transcribe('g'),
	transcribe('x')
)
"""
sco(s)
```

Our transcribe function takes a character (`Char`, `String` is build of
individual characters) called `nucleotideBase` and a default
`complementarityMap` set to `dna2mrna`. It uses `get` to return a complementary
base to `nucleotideBase` (its second argument) or a default (its third argument,
in this case just return `nucleotideBase`) if a match was not found.

All that's left is to write a `transcribe` function for the whole string
(`dnaExonsOnly`).

```jl
s = """
function transcribe(dnaSeq::String)::String
    return map(transcribe, dnaSeq)
end

mRna = transcribe(dnaExonsOnly)
(
	dnaExonsOnly[1:10],
	mRna[1:10]
)
"""
replace(sco(s), Regex(", \"") => "\n \"")
```

Here a map function applies previously defined `transcribe` on every character
of `dnaSeq` and glues the obtained characters into a string.

Instead of the above two functions we could have just written

```jl
s = """
mrna = map(base -> get(dna2mrna, base, base), dnaExonsOnly)
(
	dnaExonsOnly[1:10],
	mRna[1:10]
)
"""
replace(sco(s), Regex(", \"") => "\n \"")
```

with the same result, but I felt that the longer version was clearer.
