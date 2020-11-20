# TP NGS CHAUVE-SOURIS2
Objectif: Identifier les gènes stimulés par la réponse interféron (ISGs) chez l'espèce de chauve-souris Myotis velifer
Problème: Pas de datas de transcriptomique pour l'espèce Myotis velifer disponibles dans les bases de données
Moyen: Production et analyse de données transcriptomique pour caractériser  le profil d'expression des gènes en réponse interféron de Myotis velifer

Etape
1) Assemblage du transcriptome et annotations
2) Quantification de l'expression des gènes suite à la stimulation IFN

## Protocole biologique
Données RNA-seq obtenues sur culture de fibroblastes de chauve souris Myotis Velifer 
Culture de fibroblastes Cotrôles ou incubées 6h avec l'IFN
## Téléchargement des données de RNA-seq (Lundi 16)

2 populations d'échantillons: Contrôle (CTRL) et Traités (IFN) 
Données RNA-seq des 6 échantillons téléchargées sur le site de l'igfl 
Cf:telechargement_rnadata_vp.sh OU /tp_ngs_chauvesouris/telechargement_rnadata_git.sh (depot git)
Type de fichier: fasta ou fastq?
fastq = Combinaison de données biologiques (fichier fasta (fa)) et de données concernant la qualité

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





## A la 2 eme semaine: 
-Revoir les scripts, faire tourner (sauf Trinity --> faire un kill)
-Revoir le protocole de création de Library
-Revoir Salmon : principe + script opérationnel? (non testé)
