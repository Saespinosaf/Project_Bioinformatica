
## Códigos necesarios
# La carpeta debe tener 'muscle3.8.31_i86linux64'

# Descargar informacion sobre los datos con los que se va a trabajar porque es una familia de genes con las que voy a trabajar (no tienen el mismo nombre, ni IDS)

export PATH=$PATH:/u/scratch/d/dechavez/Bioinformatica-PUCE/MastBio/edirect # Este comando es necesario unicamente si se lo va a correr con q sub, ya que no encuentra edirect

/u/scratch/d/dechavez/Bioinformatica-PUCE/MastBio/edirect/esearch -db nuccore -query "reflectin[All Fields] AND Cephalopods[Organism]" | 
efetch -format docsum | 
xtract -set Set -rec Rec -pattern DocumentSummary -block DocumentSummary -pkg Common -wrp Accession -element AccessionVersion -wrp Organism -element Organism -wrp Title -element Title | 
xtract -head accession -pattern Rec -def "-" -element Accession -element Organism -element Title > Reflectin_Gene

# Descargar secuencias segun los IDS
# Primero dividimos en dos grupos

## Los que tienen completos los genes (estos llevan el nombre del gen, solo son uno)

cat Reflectin_Gene | head | grep "reflectin" | sort -n | uniq | cut -f1 > IDS.txt # obtenemos una lista de los IDS
epost -db nucleotide -input IDS.txt | efetch -format fasta > Reflectin.fasta # Descarga las secuencias en base de la lista de IDS en formato .fasta

## Los que son contigs (contienen varios genes de la misma familia, con zonas no codificantes)

cat Reflectin_Gene | head | grep -v "reflectin" | sort -n | uniq | cut -f1 > IDS_C.txt # obtenemos una lista de los IDS
export PATH=$HOME/edirect:$PATH # Si se trabaja con qsub (recomendable por el tiempo que toma)
split -l 50 IDS_C.txt ids_chunk_ # Divide la lista de IDS en lotes de 50 (al ser una lista muy larga)

> Reflectin_raw.fasta

for chunk in ids_chunk_*; do # Descarga por lotes y concadena todo en un solo .fasta
  ids=$(paste -sd, "$chunk")
  echo "→ Descargando lote: $chunk"

  efetch -db nuccore -id "$ids" -format fasta_cds_na >> Reflectin_raw.fasta

  sleep 1          
done

awk 'BEGIN{RS=">"; ORS=""} # Filtra las zonas codificantes para genes reflectin
     NR>1 && (tolower($0)~/reflectin/ || $0~/gene=REF[0-9]+/) {print ">"$0}
' Reflectin_raw.fasta > Reflectin_cds.fasta

awk 'NR>1 {print $1"\t"$2" "$3}' Contig_Reflectin.txt > map.txt # Crea mapa de acceso-organismo

awk ' # Añade el nombre de la especie al encabezado .fasta
  NR==FNR {org[$1]=$2; next}           # map.txt => org[Acc] = Sepia_pharaonis
  /^>/ {
      split($0,a,"|")
      split(a[2],b,"_")
      acc=b[1]
      if (acc in org)
          sub(/\]$/, " [organism="org[acc]"]]", $0)
  }
  {print}
' map.txt Reflectin_cds.fasta > Reflectin_cds_organism.fasta

rm tmp_ids.list ids_chunk_* Reflectin_raw.fasta map.txt # Limpieza de documentos no necesarios generados en el proceso (opcional)

## Ejecutar Atom

# Para las secuencias que tenian el gen completo 
perl -per 's/>(\w+.\d)\s(\w)\w+\s(\w)\w+\s\w+\s(\d).+/>\1_Ref.\4_\2\3' Reflectin.fasta > A.Reflectin.fasta
# Para secuencias con contigs
perl -per 's/>(\w+.\d)\s(\w)\w+\s(\w)\w+\s\w+.(\w+).\w+\s(\w+).+/>\1_Ref.\4\5_\2\3' Reflectin_cds_organism.fasta > A.Reflectin_cds.fasta
# Juntar los documentos
cat A* >> Reflectin_All.fasta

## Alinear secuencias
./muscle3.8.31_i86linux64 -in Reflectin_All.fasta -out Muscle_Reflectin_All -maxiters 1 -diags

## Crear filogenia con IQTREE
module load iqtree/2.2.2.6 # carga IQTREE
iqtree2 -s Muscle_Reflectin_All

## La filogenia es la que tiene .treefile
# Se extrae y corre con figtree
