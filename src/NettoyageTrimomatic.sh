#! /bin/bash


# Créer un chemin
data="/ifb/data/mydatalocal"

#dossier dataclean
dataclean="/ifb/data/mydatalocal/dataclean"
#ou dataclean=$data"/dataclean"
mkdir -p $dataclean
cd $dataclean

# on Crée la variable read
## Ne pas mettre d'espace nomdevarible="/ /"   ni avant ni après .
reads="/home/rstudio/data/mydatalocal/sharegate-igfl.ens-lyon.fr/Projet_31_20_UE_NGS_2020/FASTQ/"
## cd $readspas nécessaire

libs=`ls $reads| cut -f1,2,3,4 -d "_" | sed 's/ /_/g'|uniq`

for lib in $libs 
do echo $lib

java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 8 -phred33\
  $reads/${lib}_R1_001.fastq.gz $reads/${lib}_R2_001.fastq.gz\
  $dataclean/${lib}_R1_paired.fastq.gz $dataclean/${lib}_R1_unpaired.fastq.gz $dataclean/${lib}_R2_paired.fastq.gz $dataclean/${lib}_R2_unpaired.fastq.gz\
  ILLUMINACLIP:$data/adapt.fasta:2:30:10 HEADCROP:9 MINLEN:100

#tout sur une ligne de script
done



#Pour exécuter faire ./nomfichier.sh
#Si "permission denied" faire chmod u+x NettoyageTrimomatic.sh
