# Translation {#sec:translation}

In this chapter I will not use any external libraries. Still, once you read the
problem description you may decide to do otherwise. In that case don't let me
stop you (you're an adult, right?) go and get it.

You may compare your own solution with the one in this chapter's text (with
explanations) of with [the code
snippets](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/translation)
(without explanations).

## Problem {#sec:translation_problem}

Let's start from where we left. Read the data from the file: `mrna_seq.txt` (to
be found in [the code snippets for this
chapter](https://github.com/b-lukaszuk/BS_wJ_eng/tree/main/code_snippets/translation)). It
contains the mRNA sequence we obtained previously (see
@sec:transcription_solution).

Your task is to translate the language of nucleic acids to the language of
proteins. To do that you will operate on triplets of nucleotide bases (also
called codons). You start with the `AUG` triplet (the sequence starts with it)
and replace it with a proper amino acid (proteins are build of it), in this case
its methionine. Then you move to another triplet (there are no 'commas' in the
genetic code) and assign the proper amino acid according to the [standard
genetic
code](https://en.wikipedia.org/wiki/DNA_and_RNA_codon_tables#Translation_table_1). You
finish the protein synthesis once you encounter a stop codon (`UAA`, `UAG`,
`UGA`).

Since rewriting the Wikipedia's table from the link above is mundane and boring,
then I paste the genetic code below in Julia's dictionary format.

```jl
s = """
# codon - triplet, aa - amino acid
codon2aa = Dict(
	"UUU"=> "Phe", "UUC"=> "Phe", "UUA" => "Leu", "UUG" => "Leu",
	"CUU" => "Leu", "CUC" => "Leu", "CUA" => "Leu", "CUG" => "Leu",
	"AUU" => "Ile", "AUC" => "Ile", "AUA" => "Ile", "AUG" => "Met",
    "GUU" => "Val", "GUC" => "Val", "GUA" => "Val", "GUG" => "Val",
	"UCU" => "Ser", "UCC" => "Ser", "UCA" => "Ser", "UCG" => "Ser",
	"CCU" => "Pro", "CCC" => "Pro", "CCA" => "Pro", "CCG" => "Pro",
    "ACU" => "Thr", "ACC" => "Thr", "ACA" => "Thr", "ACG" => "Thr",
	"GCU" => "Ala", "GCC" => "Ala", "GCA" => "Ala", "GCG" => "Ala",
	"UAU" => "Tyr", "UAC" => "Tyr", "UAA" => "Stop", "UAG" => "Stop",
    "CAU" => "His", "CAC" => "His", "CAA" => "Gln", "CAG" => "Gln",
	"AAU" => "Asn", "AAC" => "Asn", "AAA" => "Lys", "AAG" => "Lys",
	"GAU" => "Asp", "GAC" => "Asp", "GAA" => "Glu", "GAG" => "Glu",
    "UGU" => "Cys", "UGC" => "Cys", "UGA" => "Stop", "UGG" => "Trp",
	"CGU" => "Arg", "CGC" => "Arg", "CGA" => "Arg", "CGG" => "Arg",
	"AGU" => "Ser", "AGC" => "Ser", "AGA" => "Arg", "AGG" => "Arg",
    "GGU" => "Gly", "GGC" => "Gly", "GGA" => "Gly", "GGG" => "Gly"
)
"""
sc(s)
```

For convenience scientists often use one letter abbreviations of the amino acids
as defined by
[IUPAC](https://en.wikipedia.org/wiki/International_Union_of_Pure_and_Applied_Chemistry)
and displayed below.

```jl
s = """
# aa - amino acid,
# iupac - International Union of Pure and Applied Chemistry
aa2iupac = Dict(
    "Ala" => "A", "Arg" => "R", "Asn" => "N", "Asp" => "D",
    "Cys" => "C", "Gln" => "Q", "Glu" => "E", "Gly" => "G",
    "His" => "H", "Ile" => "I", "Leu" => "L", "Lys" => "K",
    "Met" => "M", "Phe" => "F", "Pro" => "P", "Ser" => "S",
    "Thr" => "T", "Trp" => "W", "Tyr" => "Y", "Val" => "V",
    "Stop" => "Stop"
)
"""
sc(s)
```

So as a final touch rewrite the amino acid sequence using the one-letter
abbreviations above. As a result you should obtain the following sequence:

```jl
s = """
# AA - amino acids
expectedAAseq = "MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEAL" *
	"YLVCGERGFFYTPKTRREAEDLQVGQVELGGGPGA" *
	"GSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN"
"""
sc(s)
```

## Solution {#sec:translation_solution}

Let's start as we did before by checking the file size.

```jl
s = """
#in 'code_snippets' folder use "./translation/mrna_seq.txt"
#in 'transcription' folder use "./dna_seq_template_strand.txt"
filePath = "./code_snippets/translation/mrna_seq.txt"
filesize(filePath)
"""
sco(s)
```

OK, it's less than 1 KiB. Let's read it and get a preview of the data.

```jl
s = """
mRna = open(filePath) do file
	read(file, String)
end
mRna[1:60]
"""
sco(s)
```

It looks good, no spaces between the letters, no newline (`\n`) characters (we
removed them previously). The only issue here is that `codon2aa` contains codons
(keys) in uppercase letters. All we need to do is to uppercase the letters in
`mRna` using Julia's function of the same name.

```jl
s = """
mRna = uppercase(mRna)
mRna[1:5]
"""
sco(s)
```

OK, time to start the translation. First let's translate a triplet of nucleotide
bases (aka codon) to an amino acid.

```jl
s = """
# translates codon/triplet to amino acid IUPAC
function getAA(codon::String)::String
    @assert length(codon) == 3 "codon must contain 3 nucleotide bases"
    aaAbbrev::String = get(codon2aa, codon, "???")
    aaIUPAC::String = get(aa2iupac, aaAbbrev, "???")
    return aaIUPAC
end
"""
sc(s)
```

The function is rather simple. It accepts a codon (like `"AUG"`), next it
translates a codon to an amino acid (abbreviated with 3 letters) using
previously defined `codon2aa` dictionary. Then the 3-letter abbreviation is
coded with a single letter recommended by IUPAC (using `aa2iupac` dictionary).
If at any point no translation was found `"???"` is returned.

Now, time for translation.

```jl
s = """
function translate(mRnaSeq::String)::String
    len::Int = length(mRnaSeq)
    @assert len % 3 == 0 "the number of bases is not multiple of 3"
    aas::Vector{String} = fill("", Int(len/3))
    aaInd::Int = 0
    for i in 1:3:len
        aaInd += 1
        codon = mRnaSeq[i:(i+2)] # variable local to for loop
        aa = getAA(codon) # variable local to for loop
        if aa == "Stop"
            break
        end
        aas[aaInd] = aa
    end
    return join(aas)
end
"""
sc(s)
```

We begin with some checks for the sequence. Then, we define the vector `aas`
(`aas` - amino acids) holding our result. We initialize it with empty strings
using `fill`. We will assign the appropriate amino acid to `aas` based on the
`aaInd` (`aaInd` - amino acid index) which we increase with every iteration
(`aaInd += 1`). In `for` loop we iterate over each consecutive index with which
a triple begins (`1:3:len` will return numbers as `[1, 4, 7, 10, 13, ...]`).
Every consecutive `codon` (3 nucleotic bases) is obtained from `mRNASeq` using
indexing by adding `+2` to the index that starts a triple (e.g. for i = 1, the
three bases are at positions 1:3, for i = 4, those are 4:6). The `codon` is used
to obtain the corresponding amino acid (`aa`) with `getAA`. If the `aa` is a
so-called stop codon, then we immediately `break` free of the loop. Otherwise,
we insert the `aa` to the appropriate place [`aaInd`] in `aas`. In the end we
collapse the vector of strings into one long string with `join`. It is as if we
used `aas[1] * aas[2] * aas[3] * ...`. Notice, that e.g. `"A" * ""` is
`"A"`. This effectively gets rid of any empty `aas` elements that remained after
reaching `aa == "Stop"` and `break` early.

Let's does it work.

```jl
s = """
protein = translate(mRna)
protein == expectedAAseq
"""
sco(s)
```

Congratulations, you have successfully synthesized pre-pro-insulin. It could be
only a matter of time before you achieve something greater still.

The above (`translate`) is not the only possible solution. For instance, if you
are a fan of [functional
programming](https://en.wikipedia.org/wiki/Functional_programming) paradigm you
may try something like.

```jl
s = """
import Base.Iterators.takewhile as takewhile

function translate2(mRnaSeq::String)::String
    len::Int = length(mRnaSeq)
    @assert len % 3 == 0 "the number of bases is not multiple of 3"
    ranges::Vector{UnitRange{Int}} = map(:, 1:3:len, 3:3:len)
    codons::Vector{String} = map(r -> mRnaSeq[r], ranges)
    aas::Vector{String} = map(getAA, codons)
    return takewhile(aa -> aa != "Stop", aas) |> join
end
"""
sc(s)
```

We start by defining `ranges` that will help us get particular `codons` in
the next step. For that purpose you take two sequences for start and end of a
codon and glue them together with `:`. For instance `map(:, 1:3:9, 3:3:9)`
roughly translates into `map(:, [1, 4, 7], [3, 6, 9])` which yields
`[1:3, 4:6, 7:9]`, i.e. a vector of `UnitRange{Int}`. A `UnitRange{Int}` is a
range composed of `Int`s separated by one unit, so by 1, like in `4:6` (`[4, 5,
6]` after expansion) mentioned above]. Next, we map over those ranges and use
each one of them (`r`) to get (`->`) a respective codon (`mRnaSeq[r]`). Then, we
map over the `codons` to get respective amino acids (`getAA`). Finally, we move
from left to right through the amiono acids (`aas`) vector and take its elements
(`aa`) as long as they are not equal `"Stop"`. As the last step, we collapse the
result with `join` to get one big string.

```jl
s = """
protein2 = translate2(mRna)
expectedAAseq == protein2
"""
sco(s)
```

Works as expected. The functional solution (`translate2`) often has fewer lines
of code. It also consists of a series of consecutive logical steps, which is
quite nice. However, for a beginner (or someone that doesn't know this paradigm)
it appears more enigmatic (and therefore ofputting). Moreover, in general it is
expected to be a bit slower than the for loop version (`translate`). This
should be more evident with long sequences [try `@btime translate(mRna ^ 20)` vs
`@btime translate2(mRna ^ 20)` in the REPL (type it after `julia>` prompt)].

> Note `^` replicates a string `n` times, e.g. `"ab" ^ 3` = `"ababab"`.

Anyway, both @sec:transcription and @sec:translation were inspired by the
lecture of [this ResearchGate
entry](https://www.researchgate.net/publication/16952023_Sequence_of_human_insulin_gene)
based on which the DNA sequence was obtained (`dna_seq_template_strand.txt` from
@sec:transcription).
