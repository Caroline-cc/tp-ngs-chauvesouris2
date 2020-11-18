#! /bin/bash

# Indication du dossier par défaut

data="/home/rstudio/data/mydatalocal/data" 
## ici ne pas mettre d'espace ni avant ni après le nom de la variable
mkdir -p $databats
cd $data

#Dossier spécifique fastqc
outputfastqc="fastqc-data"
mkdir -p $outputfastqc
cd $outputfastqc

#Récupérer les données
storage_fastq="/ifb/data/mydatalocal/sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/FASTQ/"
fastq=$storage_fastq/"*.gz"

# Test de qualité-boucle for et fast qc

for sample in $fastq
do 
echo $sample
fastqc $sample --outdir $data/ifb/data/mydatalocal/outputfastqc/
done