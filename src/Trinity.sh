#! /bin/bash

data="/ifb/data/mydatalocal"
mkdir -p $data
cd $data

# Dossier doutput de trinity ()
output_trinity="ifb/data/mydatalocal"
mkdir -p $output_trinity
cd $ouput_trinity 

#Récupération des outputs de trimomatic
home_trinity=$data/"dataclean"
leftseq=$(ls $home_trinity/*R1_paired.fastq.gz |paste -d "," -s)
rightseq=$(ls $home_trinity/*R2_paired.fastq.gz |paste -d "," -s)
echo $leftseq
echo $rightseq


#Pour exécuter faire ./nomfichier.sh
#Si "permission denied" faire chmod u+x Trinity.sh

#Commande trinity 

Trinity --seqType fq --max_memory 14G --left $leftseq --right $rightseq --CPU 4 --SS_lib_type RF --output $data/output_trinity


## fonction paste pour coller des chaînes de caractères