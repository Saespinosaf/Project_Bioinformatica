# Análisis filogenético del gen reflectina en la familia Cephalopoda
Autor: Sara A. Espinosa F.

El propósito de este proyecto es analizar la evolución del gen reflectina en diferentes especies de cefalópodos mediante herramientas de bioinformática. El gen reflectina es fundamental porque codifica proteínas únicas responsables de las propiedades ópticas de la piel de los cefalópodos, como el camuflaje dinámico, la reflectancia y, en algunos casos, la bioluminiscencia. Estas proteínas permiten a los cefalópodos cambiar de color y reflejar la luz, habilidades cruciales para la comunicación, depredación y defensa.
A través del estudio comparativo de secuencias genéticas, este proyecto busca comprender cómo ha evolucionado este gen a lo largo del tiempo, identificar posibles eventos de duplicación o especialización funcional, y explorar su relación con las adaptaciones fenotípicas únicas de estos organismos, por lo que, los resultados pueden aportar al conocimiento sobre la evolución de mecanismos moleculares complejos y a futuras aplicaciones en biomateriales inspirados en esta propiedad.

## Requisitos para el programa
* Muscle
* IQTREE
* FIGTREE
* Base de datos NCBI

## Códigos
**Parte 1 - Descarga de secuencias**
Base de datos NCBI

/u/scratch/d/dechavez/Bioinformatica-PUCE/MastBio/edirect/esearch -db nuccore -query "Cephalopoda[ORGN]" | efetch -format docsum | xtract -set Set -rec Rec -pattern DocumentSummary -block DocumentSummary -pkg Common -wrp Accession -element AccessionVersion -wrp Organism -element Organism -wrp Title -element Title | xtract -head accession -pattern Rec -def "-" -element Accession -element Organism -element Title > C.Genes
