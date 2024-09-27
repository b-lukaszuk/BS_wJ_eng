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

Since rewriting the wikipedia's table from the link above is mundane and boring,
then I paste the genetic code below in Julia's dictionary format.

```jl
s = """
# codon - triplet, aa - aminoacid
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
# aa - aminoacid,
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

So as a final touch rewrie the aminoacid sequence using the one-letter
abbreviations above. As a result you should obtain the following sequence:
"MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEALYLVCGERGFFYTPKTRREAEDLQVGQVELGGGPGA
GSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN".

## Solution {#sec:translation_solution}

The solution goes here.
