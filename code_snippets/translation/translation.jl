# codon - triplet, aa - aminoacid
codon2aa = Dict(
    "UUU"=> "Phe", "UUC"=> "Phe", "UUA" => "Leu",
    "UUG" => "Leu", "CUU" => "Leu", "CUC" => "Leu",
    "CUA" => "Leu", "CUG" => "Leu", "AUU" => "Ile",
    "AUC" => "Ile", "AUA" => "Ile", "AUG" => "Met",
    "GUU" => "Val", "GUC" => "Val", "GUA" => "Val",
    "GUG" => "Val", "UCU" => "Ser", "UCC" => "Ser",
    "UCA" => "Ser", "UCG" => "Ser", "CCU" => "Pro",
    "CCC" => "Pro", "CCA" => "Pro", "CCG" => "Pro",
    "ACU" => "Thr", "ACC" => "Thr", "ACA" => "Thr",
    "ACG" => "Thr", "GCU" => "Ala", "GCC" => "Ala",
    "GCA" => "Ala", "GCG" => "Ala", "UAU" => "Tyr",
    "UAC" => "Tyr", "UAA" => "Stop", "UAG" => "Stop",
    "CAU" => "His", "CAC" => "His", "CAA" => "Gln",
    "CAG" => "Gln", "AAU" => "Asn", "AAC" => "Asn",
    "AAA" => "Lys", "AAG" => "Lys", "GAU" => "Asp",
    "GAC" => "Asp", "GAA" => "Glu", "GAG" => "Glu",
    "UGU" => "Cys", "UGC" => "Cys", "UGA" => "Stop",
    "UGG" => "Trp", "CGU" => "Arg", "CGC" => "Arg",
    "CGA" => "Arg", "CGG" => "Arg", "AGU" => "Ser",
    "AGC" => "Ser", "AGA" => "Arg", "AGG" => "Arg",
    "GGU" => "Gly", "GGC" => "Gly", "GGA" => "Gly",
    "GGG" => "Gly"
)

# aa - aminoacid,
# iupac - International Union of Pure and Applied Chemistry
aa2iupac = Dict(
    "Ala" => "A", "Arg" => "R", "Asn" => "N",
    "Asp" => "D", "Cys" => "C", "Gln" => "Q",
    "Glu" => "E", "Gly" => "G", "His" => "H",
    "Ile" => "I", "Leu" => "L", "Lys" => "K",
    "Met" => "M", "Phe" => "F", "Pro" => "P",
    "Ser" => "S", "Thr" => "T", "Trp" => "W",
    "Tyr" => "Y", "Val" => "V", "Stop" => "Stop"
)

# AA - aminoacids
expectedAAseq = "MALWMRLLPLLALLALWGPDPAAAFVNQHLCGSHLVEAL" *
	"YLVCGERGFFYTPKTRREAEDLQVGQVELGGGPGA" *
	"GSLQPLALEGSLQKRGIVEQCCTSICSLYQLENYCN"

filePath = "./mrna_seq.txt"
filesize(filePath)

mRna = open(filePath) do file
    read(file, String)
end
mRna[1:75]

# uppercasing the letters
mRna = uppercase(mRna)
mRna[1:5]

# translates codon/triplet to amino-acid IUPAC
function getAA(codon::String)::String
    aaAbbrev::String = get(codon2aa, codon, "???")
    aaIUPAC::String = get(aa2iupac, aaAbbrev, "???")
    return aaIUPAC
end

function getCodon(
    span::UnitRange{Int}, mRnaSeq::String = mRna)::String
    return mRnaSeq[span]
end

function getRange(first::Int, finalLen::Int = 3)::UnitRange{Int}
    return first:(first+finalLen-1) # () are optional
end

function translate(mRnaSeq::String)
    @assert length(mRnaSeq) % 3 == 0
    codonRanges::Vector{UnitRange{Int}} = map(getRange, 1:3:length(mRnaSeq))
    triplets::Vector{String} = map(getCodon, codonRanges)
    aas::Vector{String} = map(getAA, triplets)
    return aas
end

protein = translate(mRna)
any(protein .== "???")
any(protein .== "Stop")
stopInd = findfirst(aa -> aa == "Stop", protein)
protein = protein[1:(stopInd-1)]
protein = join(protein)

expectedAAseq == protein
