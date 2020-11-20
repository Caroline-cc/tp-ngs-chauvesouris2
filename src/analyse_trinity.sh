## Analyse du run de Trinity   A REVOIR PR RENDRE FONCTIONNEL 

## Comptage du nombre de transcripts assemblés

grep > Trinity_RF.fasta |less

## Comptage du nombre de gènes

### Nécessité d'exclure la distinction des isoformes

### |cut -f1,2,3,4 -d"_" |less
### |sort|unique|wc -l

