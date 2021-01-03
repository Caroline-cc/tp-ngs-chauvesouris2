---
output:
  pdf_document: default
  html_document: default
---
# TP NGS CHAUVE-SOURIS2

##Introduction
Bats are frequently exposed to  a large spectrum of viruses but seem asymptomaric. This suggest specific bat's immunity responses developed through a long -term cohabitation with viruses. Bat's immunity would have reached an equilibrium between viral resistance and tolerance. High tolerance to viruses is thought to be due to a particularly performant antiviral interferon (IFN) response. Indeed, among innate immune responses to viral agents, interferon synthesis activate the expression of hundred of genes: Insterferon Stimulated Genes (ISG). Some ISG protect from viral infection impairing viral replication steps. The IFN system has been largely studied in megabats but fewer studies have been done in microbats.  
Here we aimed at identifying genes stimulated by the interferon response in Myotis velifer specie of microbat. Analyses were performed on transcriptomic data collected by L.E's scientific team. Analyses first consisted in transcriptome assembly and annotation steps. Then trancripts level under interferon stimulation or not were estimated through reads quantification. Finally associated  genes were identified comparing with known human corresponding ISGs.  

Problème: Pas de datas de transcriptomique pour l'espèce Myotis velifer disponibles dans les bases de données
Moyen: Production et analyse de données transcriptomique pour caractériser  le profil d'expression des gènes en réponse interféron de Myotis velifer


## Obtention of biological datas
Analyzed RNA-seq datas derives  from 6 samples of Myotis velifer's fibroblasts cultures.  Cultured fibroblasts had been incubated with interferon for 6hours (IFN samples) or not, for control (CTL )samples. mRNA seq libraries  were obtained through reverse transcription of transcripts into double-stranded complementary DNA. To amplify libraries, PCR was performed on those cDNA fragments fused with a  adaptaters pairs, forming reads (read 1 and read 2 corresponding to each of DNA strand) .Quality control was performed to assess DNA concentration before sequencing DNA reads  through Ilumina Seq technique. Read 1 and read 2 constructs enabled Paired-end sequencing.  DNA reads were sequenced from both ends for high- quality sequencing.   Biological and associated quality sequencing datas and associated quality evaluation were combined in fastq files that are the feeding  datas of our analyses.
![GitHub Logo](/images/paired-end-read-1.png) 

## Téléchargement des données de RNA-seq (Lundi 16)



Reading: single-end ou paired-end?
RNA-seq en single-end: lit le fragment d'ARN d'un bout à l'autre,
RNA-seq en paired-end:"sorte d'aller -retour" 2 reads, un sur chacun des brins, orientés dans des sens opposés

RNA seq en paired-end est plus cher et plus long mais meilleure capacité à identifier la position relative des fragments dans le génome: meilleure gestion des réarrangements de séquence (insertion, délétion,inversion)
Historiquement, single end arrivé en premier puis paired end, aujourd'hui le séquençage RNA standard utilisé. 
Ici, pour chaque échantillon, on a bien un Read 1 et un Read 2, chacun d'environ 150pb (assez court). Théoriquement les 2 reads ne sont pas censés se chevaucher mais c'est arrivé
/!\ On n'a pas la séquence entre les reads

--> Ces datas de RNA-seq peuvent-elles êtres utilisées pour un assemblage du transcriptome de Myotis velifer?

## Test de qualité des données de RNA-seq avant assemblage : Fastqc (Mard 17)

Programme fastqc Cf: Testdequalite.sh  in /mydatalocal/tp_ngs_chauvesouris/src
Utilisation d'une boucle for pour appliquer la commande fast qc à tous les échantillons 
Analyse de qualité stockée dans output_fastqc
Lecture des fichiers html
"Per base sequence quality"Diminution de la qualité du séquençage avec l'augmentation de la longueur du read. 
"Per tile sequence quality" Distribution de la qualité moyenne pour chaque séquence
"Per base sequence content" On s'attend à ce que ce soit linéaire, plat


--> Qualité moyenne des donées de RNA-seq, nécessité d'un nettoyage pour ségréger les read appariés et non appariés 

## Nettoyage des données de RNA seq : Trimommatic (Mar 17)
L'objectif est d'éliminer des données à assembler les débuts et fins de séquences de mauvaise qualité. 
2 possibilités intégrer l'étape de Nettoyage à l'Assemblage (intégrer Trimommatic à Trinity) ou séparément
Choix de faire séquentiellement: Trimommatic puis Trinity pour faire un nouveau ontrôle (fastqc) après nettoyage.

Entrée des commandes de nettoyage à Trimmomatic:
- Indiquer que  les reads sont appariés: pour chaque sample, 2 inputs : R1 et R2
-Indiquer le nombre de coeurs disponibles pour exécuter la commande (thread)
-Le score de qualité d'une base nucléotidique: phred 33
Cf un phred de 30 correspond à une P(identification nucléotidique incorrecte)= 1. 10 E-3
- Paramètres du nettoyage

ILLUMINACLIP: enlever les adaptateurs Illumina et autoriser des mismatchs entre séquence read et séquence adaptateur 
HEADCROP: 9 
MINLEN (enlever les séquences trop petites)
TRAILING (couper les bases en dessous d'un seuil de qualité)


Certaines séquences sont supprimées et vont se retrouver non appariées
Création de 4 fichiers de sortie pour chaque échantillon:
Une version paired et unpaired pour chacun des reads (left ou R1 et right ou R2)

## Nouveau tets de la qualité des données de RNA-seq après nettoyage: fastqc

(Personnellement non réalisé, retard,)

## Assemblage des données transcriptomiques: Trinity (Mercre 18)

Trinity:
Comprend 3softwares indépendants: inchworm, chrysalis, butterfly. Appliqués séquentiellement.
Les transcripts sont regroupés en cluster, selon le contenu en séquence partagé (1 cluster est associé grossièrement à 1 gène)
Chaque cluster est assemblé séparément.
La stratégie Trinity se base sur le Graphe de Debreuil : reconstruction de la séquence totale à partir de fragment, le Graphe de Debreuil aborde le cas de fragments répétés dans la séquence


Stratégie de l'assemblage: Assemblage à partir de l'ensemble des échantillons (IFN et CTRL)
Sélection des reads bien appariés après nettoyage (exclusion des unpaired pour l'assemblage)

Paramètre de commande:

Indiquer le CPU et le max mémory 


2 séquences nucléotides à assembler parallèlement, correspondant aux 2 brins (associés à un read chacun)
Read 1 correspond au Read apparié à gauche, Read 2 à doite, 
-Indiquer le type du fichier (--seqType): fastq
-Indiquer comment lire les reads (SS--lib--type): indique la position des reads sur les brins, leur sens d'orientaion  
fr firststrand correspond à rf sur trinity
R1 dans le sens 5'3', R1 sur le brin reverse de l'arnm
R2 ont une séquence équivalente à ARNm
CF: point Q1.9 (orientation of SENSE reads)
https://www.lexogen.com/sense-mrna-sequencing/

NB: de nombreuses stratégies de séquençage en paired-end possibles 
Cf image corentin 
https://ue-ngs-students.slack.com/files/U01DH0HMTDZ/F01F066R259/image.png

-Indiquer le nombre de coeurs disponible pour l'exécution (CPU 4)

/!\ Données de RNA-seq très lourdes, (Trinity prendrait 2 jours et plus de 16 giga de ram) chaque membre du TP traite un échantillon.
Test de lancement de Trinity puis arrêt du programme avec "kill"
Données assemblées (obtenues précédemment) fournies par les encadrants Cf dossier transfer_trinity

## 

Chauve-souris groupe 2: travail sur la quantification de l'expression génique (gènes ISGs)suite à la stimulation IFN
Chauve-souris groupe 1: Travail sur la phylogénie des duplications de PKR
Alignement multi-séquences avec PRANK

Analyse des sorties de Trinity:

Sorties de trinity dans un fichier Trinity.fasta (transfert par Marie, données non obtenues par running du programme)
Chaque transcript assemblé est signalé par une ligne commençant par un chevron.
Un transcript est noté sous un format :  >TRINITY_DN1000_c115_g5_i1 indiquant le cluster du read (DN []_C[]), le gène (g[]) et l'isoforme 

Sortie du nombre de transcripts assemblés par Trinity: envrion 400 mille transcripts. 
Comptage du nombre de gènes (exclusion des isofromes) : 300 000 gènes, nombre excessif sans doute dû à des reads trop courts assemblés. 

## Présentation Lucie Etienne (Mecredi 18): faire le topo  question biologique etc...


## Remappin des reads sur le transcriptome assemblé: Salmon (Mercredi 18)

Quantification consiste basiquement à déterminer combien de reads s'alignent sur un transcript. 
Génération d'un index pour faciliter (plus rapide) l'alignement des reads sur le transcript via salmon index.

Quantification via salmon quant. 
Indication d'un squençage en paired end 
ésultats du running de  salmon quant jugés bons pour plus de 80% des reads alignés
Sorties de salmons indiquent le transcript ID pas le gène ID

To summarize the transcript-level into gene level: tximport
Tximport outputs "abundance","counts", length""



## A la 2 eme semaine: 
-Revoir les scripts, faire tourner (sauf Trinity --> faire un kill)
-Revoir le protocole de création de Library
-Revoir Salmon : principe + script opérationnel? (non testé)


## Annoter les gènes transcripts : 2 approches
Objectif:   avoir une vision fonctionnelle des transcripts dans le cadre de l'étude la réponse antivirale chez les chauve souris en cherchant des homologies de séquence.

Blast: programme pour trouver des alignements locaux. Adapté pour la recherche d'alignements de séquences PKR avec la basse de données obtenue. Pour létude fonctionnelle des transcripts, comparaison avec des CDS humains, car CDS humains mieux annotés en identifiant des homologues de gènes bien caractérisés.

Transdecoder: Permet d'identifier les contigs de Trinity contenant des séquences codantes.  C

#Blast sur séquences CDS humaines

On charge les inputs, les CDS humains sur des bases de données 
Première étape : préparation d'une banque de data adaptée pour y faire tourner blast. Blast outputs: presented in 12 colnames 
colnames(res) = c('qseqid', 'sseqid', 'pident', 'length', 'mismatch', 'gapopen', 'qstart', 'qend', 'sstart', 'send', 'evalue', 'bitscore')
(16/12 matin : mise au point de salmon quant et salmon index)
# Expression différentielle

Premier étape: To import estimates of transcripts-level abundance, we use tximport pipeline  importer les données de quantification des transcripts (fichiers salmon, paired end ) pour l'analyse par DESeq
Deuxième étpe: lecture du mapping de trinity et sélection des colonnes d'intérêt
Construction d'une table associant données de quantitification et transcriptiomiqe 
Création d'un data set pour y appliquer la fonction DESeq avec DESeq2 
*class: DESeqDataSet 
dim: 311364 6 
metadata(1): version
assays(2): counts avgTxLength
rownames(311364): TRINITY_DN0_c0_g1 TRINITY_DN0_c0_g2 ... TRINITY_DN99998_c0_g1
  TRINITY_DN99999_c0_g1
rowData names(0):
colnames(6): Lib1_31_20_S1 Lib2_31_20_S2 ... Lib5_31_20_S5 Lib6_31_20_S6
colData names(2): run condition*

Outputs de DESeq donnent le niveau d'expression en condition test normalisé par le niveau d'expression en condition contrôle,  log2foldchange qui correspond au rapport des moyennes d'expression dans les 2 conditions: IFN et CTRL 

Anlayse pour les 311364 types de transcripts différents (~gènes) dans les 6 échantillons 
Analysing all 6 samples (libraries) 1745 genes with a significantly different expression were found on 294034
Analysing the 5 samples (libraries) 1896 genes on 287 553 analyzed were fund with a significantly different expression comparing control and interferon treatment 


#Caractérisation des gènes présentant une expression différentielle en condition interféron

Association  des données d'alignement des transcripts de blast avec des noms correspondants de  gènes humains , par la commande merge
Association des données d'expression différentielle de DESeq2 (res) aux noms d'homologues de gènes humains trouvés 
Comparaison des gènes présentant une DE avec ceux de Holzer: study to annotate non coding RNA from bats (many non coding genes from bats are not annotated) . Lead in 16 bats genomes . Annotations compatible with NCBI and Ensembl (what does it mean ???)(CF yes annotations are availbale for bats!)Studied genes induced by IFN directly or IFN-inducing viruses, exclusively in Myotis or in both Myotis and Humans . Study led on M. daubentonii, 
/!\ The used a kidney -cel line 
Results Holzer : "When cells were treated for 6 h with IFN, 195 genes were strongly upregulated (i.e., substantially more than after
6 h of Clone 13 infection). No gene was downregulated (Figures 3A and 3B). The IFN-regulated genes encompassed prototypical (OAS1, ISG15, Mx1, IFIT3, BST2, DHX58) but also less known ISGs (BCL2L14, RNF213, ESIP1)."

"predominant biological processes both at 6 and 24 h post infection
encompassed antigen processing and presentation, antiviral defense, immune response, and NF-kB regulation (Figure S4B). Additionally, at 6 h there are indications of both up- and downregulation of intracellular
and transmembrane transport, and at 24 h oxidoreductase activity is mostly downregulated.
"Overall, running the two transcriptomes next to each
other showed once more that at 6 h Clone 13 infection stimulated less genes (denominated as being ‘‘downregulated’’) than 6-h IFN treatment (Figures 4A and 4B). We could identify some genes that are upregulated
exclusively by Clone 13, most prominently the prototypical, IRF3-driven virus-response gene IFNB1."




## Ideas:

-Why not comparing woth other bats : annotations available
