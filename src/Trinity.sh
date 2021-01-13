#! /bin/bash
# De novo transcriptome assembly with Trinity

#Create working directory
data="/ifb/data/mydatalocal/outputs"
mkdir -p $data
cd $data

# Create an output directory for trinity 
output_trinity=$data/"output_trinity"
mkdir -p $output_trinity
cd $ouput_trinity 

#Indicate Trinity inputs (=Trimmomatic outputs)
home_trinity=$data/"output_trimmomatic"
leftseq=$(ls $home_trinity/*R1_paired.fastq.gz |paste -d "," -s)
rightseq=$(ls $home_trinity/*R2_paired.fastq.gz |paste -d "," -s)
echo $leftseq
echo $rightseq


#Run Trinity 
Trinity --seqType fq --max_memory 14G --left $leftseq --right $rightseq --CPU 4 --SS_lib_type RF --output $data/output_trinity

#Analysis of the assembled transcriptome (in transferred trinity outputs)

##Count isoform-specific transcripts identified by Trinity
grep -c ">" mydatalocal/transfer_trinity/Trinity.fasta

#Count corresponding (different transcripts independently from isoforms)

grep ">" mydatalocal/transfer_trinity/Trinity.fasta |cut -f1,2,3,4 -d "_"|sort |uniq |wc -l

## fonction paste pour coller des chaînes de caractères
## -d "," pour délimiter les séquences nucléotides des reads forward/reverse par des virgules
## -s pour mettre toute la chaîne nucléotidique sur une seule ligne
## le $  avant le ls indique qu'on va bien stocker le résultat et non le fichier correspondant dans la liste.