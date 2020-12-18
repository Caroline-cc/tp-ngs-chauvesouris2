#bash

# Recherche d'alignements locaux: Blast

## Database reference building (création d'une data base pour blast à partir de nos fichiers de trinity?)

output_sapiens_cds="home/rstudio/mydatalocal/outputs"
mkdir $output_sapiens_cds

wget -O $output_sapiens_cds/Homo_sapiens.GRCh38.cds.fa.gz ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/cds/Homo_sapiens.GRCh38.cds.all.fa.gz





output_sapiens_cds="/home/rstudio/"
mkdir $output_sapiens_cds
wget -O ${output_sapiens_cds}"banque_blast/Homo_sapiens.GRCh38.cds.fa.gz"\
ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/cds/Homo_sapiens.GRCh38.cds.all.fa.gz
gunzip $outputs/*

BLASTDB_hum=$BLASTDBDIR/"Homo_sapiens.GRCh38.db"

#To build database
db_hum= $BLASTDB_hum.nhr

query=$TRANSDECODERTRANSCRIPTOMES/"Trinity.fast.transdecoder.cds"

FASTAREFERENCE_hum =$banque_blast/Homo_sapiens.GRCh38.cds.fa.gz
"/softwares/ncbi-blast-2.10.1+/bin/makeblastdb"-in $FASTAREFERENCE_hum -dbtype nucl -parse_sequids-out  $BLASTDB_hum


##parse_sequid permet d'avoir une entrée fasta. Format de banque blast

query=$TRANSDECODER

FASTAREFERENCE_hum=$BLASTDBDIR.sapiens.GRCh38.cds.fa

for Trinity.fasta makeblastdb from 
.
##comparasion de la data base auw fichiers fasta de blast .
##y'a les fichiers fasta de nous et ceux de blast. 
""="data/mydatalocal/download"
#install.packages("seqinr")
library(seqinr)
f=read.fasta("mart_export.txt")
write.fasta(sequences=sequences, names=names,  file.out="mart_no_redondancy.fa")


mk-dir data/mydatalocal/outputs/output_transdecoder
TransDecoder.LongOrfs -t/data/mydatalocal/transfer_trinity/Trinity.fasta.gene_trans_map
-O $data/output_transdecoder/long_orfs -m 100 -S


##transdecoder
data=/ifb/data/mydatalocal
TransDecoder.LongOrfs -t $data/transfer_trinity/Trinity.fasta.gene_trans_map $data
s/Trinity_FR.fasta.gene_trans_map --output_dir $data/transdecoder_results/long_orfs -m 100 -S

TransDecoder.Predict -t $data/trinity_results/Trinity_RF.fasta -O $data/transdecoder_results/predict



