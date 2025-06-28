## Código a usar
# Parte 1 - Descarga de secuencias
/u/scratch/d/dechavez/Bioinformatica-PUCE/MastBio/edirect/esearch -db nuccore -query "Cephalopoda[ORGN]" | efetch -format docsum | xtract -set Set -rec Rec -pattern DocumentSummary -block DocumentSummary -pkg Common -wrp Accession -element AccessionVersion -wrp Organism -element Organism -wrp Title -element Title | xtract -head accession -pattern Rec -def "-" -element Accession -element Organism -element Title > C.Genes
