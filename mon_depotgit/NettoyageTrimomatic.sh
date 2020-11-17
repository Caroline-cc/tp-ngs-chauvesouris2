#! /bin/bash


# Créer un dossier pour les inputs

#dossier dataclean
dataclean = "/home/rstudio/data/mydatalocal/dataclean"
mkdir -p $dataclean
cd $dataclean

# on Crée la variable read
reads = "/home/rstudio/data/mydatalocal/sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/FASTQ/"


libs=`ls $reads| cut -f1,2,3,4 -d "_" | sed 's/ /_/g'|uniq` 

for lib in libs 
do echo $lib
java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE-threads 8 -phred33
$read/${lib}_R1_001.fastq.gz $read/${lib}_R2_001.fastq.gz
$dataclean/lib_R1_paired.fastq.gz $dataclean/lib_R1_unpaired.fastq.gz $dataclean/lib_R2_paired.fastq.gz $dataclean/lib_R2_unpaired.fastq.gz ILLUMINACLIP:$data/mydatalocal/adapt.fasta:2:30:10 HEADCROP:9 MINLEN:100

done
