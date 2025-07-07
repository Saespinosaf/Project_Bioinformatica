
## Códigos necesarios

# Descargar informacion sobre los datos con los que se va a trabajar

export PATH=$PATH:/u/scratch/d/dechavez/Bioinformatica-PUCE/MastBio/edirect #Este comando es necesario unicamente si se lo va a correr con q sub, ya que no encuentra "edirect"

/u/scratch/d/dechavez/Bioinformatica-PUCE/MastBio/edirect/esearch -db nuccore -query "reflectin[All Fields] AND Cephalopods[Organism]" | efetch -format docsum | xtract -set Set -rec Rec -pattern DocumentSummary -block DocumentSummary -pkg Common -wrp Accession -element AccessionVersion -wrp Organism -element Organism -wrp Title -element Title | xtract -head accession -pattern Rec -def "-" -element Accession -element Organism -element Title > 2.Reflectin_Gene
