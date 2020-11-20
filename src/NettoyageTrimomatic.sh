#! /bin/bash


# Créer un chemin
data="/ifb/data/mydatalocal/data"
cd $data

#Dossier spécifique pour les outputs de Trimmomatic

output_trimmomatic="/ifb/data/mydatalocal/outputs/output_trimmomatic"
#ou output_trimmomatic=$data"/outputs/output_trimmomatic"
mkdir -p $output_trimmomatic
cd $output_trimmomatic

# Création de la variable read

reads="/home/rstudio/data/mydatalocal/download/sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/FASTQ/"
## cd $readspas nécessaire

libs=`ls $reads| cut -f1,2,3,4 -d "_" | sed 's/ /_/g'|uniq`

for lib in $libs 
do echo $lib

java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 8 -phred33\
  $reads/${lib}_R1_001.fastq.gz $reads/${lib}_R2_001.fastq.gz\
  $dataclean/${lib}_R1_paired.fastq.gz $dataclean/${lib}_R1_unpaired.fastq.gz $dataclean/${lib}_R2_paired.fastq.gz $dataclean/${lib}_R2_unpaired.fastq.gz\
  ILLUMINACLIP:$data/adapt.fasta:2:30:10 HEADCROP:9 MINLEN:100

done

## cut -..... on garde les 4 premiers caractères du nom du fichier, délimités par "_"
##tout mettre sur une ligne de script ou utliser l'antislash avec éventuellement tabulation

