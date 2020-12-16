
## Dossier par défaut
data="/home/rstudio/data/mydatalocal"

cd $data

## Création de l'index 

salmon index -t $data/transfer_trinity/Trinity.fasta -i $data/outputs/output_index -p 4

## Quantification 

###mkdir /home/rstudio/data/mydatalocal/data/salmon_alignment_paired_end

for n in 1 2 3 4 5 6
do 
#echo $n
salmon quant \
  -i $data/outputs/output_index -l A -1 $data/outputs/output_trimomatic/Lib${n}_31_20_S${n}_R1_paired.fastq.gz \
  -2 $data/outputs/output_trimomatic/Lib${n}_31_20_S${n}_R2_paired.fastq.gz \
--validateMappings -o $data/salmon_alignment_paired_end/quant_${n} --gcBias -p 4
done
 
