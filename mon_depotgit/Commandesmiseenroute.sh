#! /bin/bash

MISE EN ROUTE NGS

#Pour télécharger les data sur le site de l'igfl 

wget -r --ftp-user=igfl-UE_NGS_2020 --ftp-password=UE_NGS_2020 ftp://sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/

# Test de qualité-boucle for et fast qc

for i in sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/FASTQ/*.gz
do echo $i
fastqc $i --outdir mydatalocal/outputfastqc/
done