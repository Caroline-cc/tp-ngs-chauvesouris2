#! /bin/bash
#ORFs detection with Transdecoder

#Create working directory

data="/ifb/data/mydatalocal"
mkdir -p $data
cd $data

#Create an output directory for Transdecoder results

output_transdeco=$data/outputs/"transdec_data"
mkdir -p $output_transdeco

#Run Transdecoder

## Identification of the long open reading frames
TransDecoder.LongOrfs -t $data/transfer_trinity/Trinity.fasta --gene_trans_map $data/transfer_trinity/Trinity.fasta.gene_trans_map -S -O $output_transdeco

## Selection of the most likely coding sequences

TransDecoder.Predict -t $data/transfer_trinity/Trinity.fasta --single_best_only -O $output_transdeco