#! /bin/bash
# Local alignements with human cds : blastn

# Create a working diectory 

data="/home/rstudio/data/mydatalocal"
mkdir -p $data
cd $data

# Import human CDS from ensembl database

output_blast="$data/outputs/output_blast"
mkdir $output_blast

wget -O $output_blast/Homo_sapiens.GRCh38.cds.fa.gz ftp://ftp.ensembl.org/pub/release-101/fasta/homo_sapiens/cds/Homo_sapiens.GRCh38.cds.all.fa.gz

gunzip $output_blast/Homo_sapiens.GRCh38.cds.fa.gz

# Create a database for blast

##Define inputs files for blast
hu_cds=$output_blast/Homo_sapiens.GRCh38.cds.fa  # human coding sequence
transdec_cds=$data/outputs/transdec_data/Trinity.fasta.transdecoder.cds  # transdecoder coding sequences (query)

##Create output directories
humCDS_db="$data/outputs/output_blast/humCDS_db"
blastdb_hum="$data/outputs/output_blast/blastdb_hum"
mkdir -p $humCDS_db
mkdir -p $blastdb_hum

## Makeblastdb to create it
/softwares/ncbi-blast-2.10.1+/bin/makeblastdb -in $hu_cds -dbtype 'nucl' -out "humCDS_db" -parse_seqids

## Blastn to align our identied coding sequences (query) on the database
/softwares/ncbi-blast-2.10.1+/bin/blastn -db "humCDS_db" -query $transdec_cds -evalue 1e-4 -outfmt 6 -out "blastdb_hum" -max_target_seqs 1


##parse_sequid permet d'avoir une entrée fasta. Format de banque blast
##comparasion de la data base aux fichiers fasta de blast .


