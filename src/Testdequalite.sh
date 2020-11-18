#! /bin/bash

# Indication du dossier par défaut

data="/home/rstudio/data/mydatalocal/data"
mkdir -p $data
cd $data

#Dossier spécifique d'outputs de fastqc

outputfastqc="fastqc-data"
mkdir -p $outputfastqc
cd $outputfastqc

# Récupération des données de RNA-seq téléchargées

home_fastq="home/rstudio/data/mydatalocal/download/sharegate-igfl.ens-lyon.fr"
fastq=$home_fastq/"*.gz"
## le * indique qu'on le fait sur tous les fichiers dans repertory home_fastq

# Test de qualité fast qc
## Utilisation d'une boucle for

for sample in  $fastq
do
echo $sample
fastqc $sample --outdir $data/$output_fastqc
done
## on aurait pou dire v ou i à la place de sample