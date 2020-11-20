
## Dossier par défaut
data="home/rstudio/data/mydatalocal/data"
mkdir -p $data
cd $data

## Dossier de stockage de l'index
salmon_index=$data"/outputs/salmon_index"
mkdir -p $salmon_index

## Création de l'index 

salmon index -t$data/transfer_trinity/Trinity.fasta -i$data/outputs/output_index -p 4

## Quantification 

for n in 1 2 3 4 5 6
do 
salmon quant\
  -i $data/outputs/salmon_index -l A -1 $data/outputs/output_trinity/Lib${n}_output_forward_paired\ 
  -2 $data/outputs/output_trinity/Lib${n}_output_reverse_paired
done

