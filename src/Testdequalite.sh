#! /bin/bash
# Analysis of RNA-seq data quality with fastqc

# Create a working directory

data="/home/rstudio/data/mydatalocal/data"
mkdir -p $data
cd $data

# Create a directory for fastqc outputs 

output_fastqc="fastqc-data"
mkdir -p $output_fastqc
cd $output_fastqc

# Importation of downloaded RNA-seq data

home_fastq="home/rstudio/data/mydatalocal/download/sharegate-igfl.ens-lyon.fr"
fastq=$home_fastq/"*.gz"
## le * indique qu'on le fait sur tous les fichiers dans repertory home_fastq

# Run quality test with fastqc

for sample in  $fastq
do
echo $sample
fastqc $sample --outdir $data/$output_fastqc
done
## on aurait pou dire v ou i à la place de sample