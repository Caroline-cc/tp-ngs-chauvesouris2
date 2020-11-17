data= "/home/rstudio/data/mydatalocal/data"
mkdir -p $data
cd $data

output_trimomatic

for number in "1 2 3 4 5 6"
do
mkdir /ifb/data/mydatalocal/TP-NGS-chauvesouris/trimmomatic_outputs/Lib$number
done


for number in 1 2 3 4 5 6
do

java -jar /softwares/Trimmomatic-0.39/trimmomatic-0.39.jar PE -threads 8 -phred33 $data/fastqc_sequences/Lib${number}_31_20_S${number}_R1_001.fastq.gz $data/fastqc_sequences/Lib${number}_31_20_S${number}_R2_001.fastq.gz $data/trimmomatic_outputs/Lib${number}_output_forward_paired.fq.gz $data/trimmomatic_outputs/Lib${number}_output_forward_unpaired.fq.gz $data/trimmomatic_outputs/Lib${number}_output_reverse_paired.fq.gz $data/trimmomatic_outputs/Lib${number}_output_reverse_unpaired.fq.gz ILLUMINACLIP:$data/fastq_sequences/adapt.fasta:2:30:10 MINLEN:100 HEADCROP:9