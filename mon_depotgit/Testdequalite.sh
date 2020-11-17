#! /bin/bash

# Indication du dossier par défaut

databats= "/home/rstudio/data/mydatalocal/databats"
mkdir -p $databats
cd $databats

#Dossier spécifique fastqc
outputfastqc= "fastqc-data"
mkdir -p $outputfastqc
cd $outputfastqc
# Test de qualité-boucle for et fast qc

for i in  /ifb/data/mydatalocal/sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/FASTQ/*.gz
do echo $i
fastqc $i --outdir /ifb/data/mydatalocal/outputfastqc/
done