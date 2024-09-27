const filePath = "./dna_seq_template_strand.txt"
filesize(filePath)

dna = read(filePath, String)
dna[1:80]

dna = replace(dna, " " => "", "\n" => "")
dna[1:80]

dnaExonsOnly = dna[2424:2610] * dna[3397:3542]
dnaExonsOnly[1:80]

# https://en.wikipedia.org/wiki/Complementarity_(molecular_biology)
# DNA template strand to mRNA
dna2mrna = Dict(
    'a' => 'u',
    'c' => 'g',
    'g' => 'c',
    't' => 'a'
)

function transcribe(
    nucleotideBase::Char,
    complementarityMap::Dict{Char, Char} = dna2mrna
    )::Char
    return get(complementarityMap, nucleotideBase, nucleotideBase)
end
(
    transcribe('a'),
    transcribe('g'),
    transcribe('x')
)

function transcribe(dnaSeq::String)::String
    return map(transcribe, dnaSeq) # map uses transcribe from above
end

mRna = transcribe(dnaExonsOnly)
(
    dnaExonsOnly[1:10],
    mRna[1:10]
)

# or shortly
mRna = map(base -> get(dna2mrna, base, base), dnaExonsOnly)
(
    dnaExonsOnly[1:10],
    mRna[1:10]
)
