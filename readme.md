
---
output:
  html_document: default
  pdf_document: default
---

# Characterization of the Interferon transcriptomic response  in a microbat species


## Introduction

Bats are frequently exposed to  a large spectrum of viruses but seem asymptomaric. This suggest specific bat's immunity responses developed through a long -term cohabitation with viruses. Bat's immunity would have reached an equilibrium between viral resistance and tolerance. High tolerance to viruses is thought to be due to a particularly performant antiviral interferon (IFN) response. Indeed, among innate immune responses to viral agents, interferon synthesis activate the expression of hundred of genes: Insterferon Stimulated Genes (ISG). Some ISG protect from viral infection impairing viral replication steps. The IFN system has been largely studied in megabats but fewer studies have been done in microbats.  
Here we aimed at identifying genes stimulated by the interferon response in Myotis velifer specie of microbat. Analyses were performed on transcriptomic data collected by L.E's scientific team. Analyses first consisted in transcriptome assembly and annotation steps. Then trancripts level under interferon stimulation or not were estimated through reads quantification. Finally associated  genes were identified comparing with known human corresponding ISGs.  

Problème: Pas de datas de transcriptomique pour l'espèce Myotis velifer disponibles dans les bases de données
Moyen: Production et analyse de données transcriptomique pour caractériser  le profil d'expression des gènes en réponse interféron de Myotis velifer


## Obtention of biological datas

Analyzed RNA-seq datas derives  from 6 samples of Myotis velifer's fibroblasts cultures.  Cultured fibroblasts had been incubated with interferon for 6hours (IFN samples) or not, for control (CTL )samples. mRNA seq libraries  were obtained through reverse transcription of transcripts into double-stranded complementary DNA. To amplify libraries, PCR was performed on those cDNA fragments fused with a  adaptaters pairs, forming reads (read 1 and read 2 corresponding to each of DNA strand) .Quality control was performed to assess DNA concentration before sequencing DNA reads  through Ilumina Seq technique. Read 1 and read 2 constructs enabled Paired-end sequencing.  DNA reads were sequenced from both ends for high- quality sequencing.   Biological and associated quality sequencing datas and associated quality evaluation were combined in fastq files that are the feeding  datas of our analyses.
![GitHub Logo](/images/paired-end-read-1.png){width="28px"} 

*from thesequencingcenter.com*

## Téléchargement des données de RNA-seq 
Reading: single-end ou paired-end?
RNA-seq en single-end: lit le fragment d'ARN d'un bout à l'autre,
RNA-seq en paired-end:"sorte d'aller -retour" 2 reads, un sur chacun des brins, orientés dans des sens opposés
RNA seq en paired-end est plus cher et plus long mais meilleure capacité à identifier la position relative des fragments dans le génome: meilleure gestion des réarrangements de séquence (insertion, délétion,inversion)
Historiquement, single end arrivé en premier puis paired end, aujourd'hui le séquençage RNA standard utilisé. 
Ici, pour chaque échantillon, on a bien un Read 1 et un Read 2, chacun d'environ 150pb (assez court). Théoriquement les 2 reads ne sont pas censés se chevaucher mais c'est arrivé
/!\ On n'a pas la séquence entre les reads

We first assessed the quality of reads' sequencing to determine if sequencing datas were reliable for transcriptome assembly. 

## Assessment of RNA-seq datas' quality: Fastqc 

To determine reads'quality we ran the fastqc program on each type of reads (forward and reverse) in all samples. 
-Cf:Testdequalite file-
Fastqc report present quality analysis at  different sequencing level.
-Cf html files in outputs/output_fastqc-
"Per base sequence quality" shows a drop in sequencing quality for final bases.Decreasing sequencing quality with increasing read length is due to tecnical defects. Indeed, in the Ilumina platform, among clusters of identical DNA molecule, sequencing of some DNA reads will desynchronize over runs. Consequently, probe signal for nucleotide identification will be less pure, increasing sequencing errors in last runs. 
![GitHub Logo](/images/perbasequality_lib1.png){width=30%} 
-Bases quality score in function of base position in the read, quality report for Lib1 library reads-

The "Per sequence quality scores" indicated a good overall quality score in the great majority of reads in the different libraries. However the per sequence GC contents scores suggested unreliable read quality. In some libraries, the G proportion was sigificantly higher whereas we would expect similar proportions of A and T, and G and C, and consequently linear curves. This could be due to a biaised sequencing. 
![GitHub Logo](/images/perbaseseqcontent.png){width=20%} 
-Graphical representation of the per base sequence content from the fastqc report of R1 reads, library 1-
"Per tile sequence quality" Distribution de la qualité moyenne pour chaque séquence


Considering the relative quality of RNA-seq datas, especially the dropping at sequences'end, we cleaned the datas. Indeed, a low row datas quality could biased following analysis.; 
--> Qualité moyenne des donées de RNA-seq, nécessité d'un nettoyage pour ségréger les read appariés et non appariés 

## Cleaning of RNA-seq datas: Trimommatic 

Before genome assembly we cleaned datas with Trimommatic.
Note that cleaning step can also be treated with genome assembly combining program running. To treat paired reads, we ran Trimmomatic in a paired-end (PE) mode distinguishing froward and reverse read files as inputs.Nucleotides with a quality score or phred score threhold of 33 were filtered. In others words, bases with an incorrect probability call superior to 10^E -3 were eliminated. Short reads with a length below 100 bases were removed with MINLEN software, and the first 9 bases of each reads were suppressed (HEADCROP). Adaptators and illumina related sequences were also suppressed of reads (ILLUMINACLIP) Indeed adaptaters can be sequenced when if they dimerize or if they are readen as the prolongement of short DNA fragments by the sequencer. We could have removed starting or ending bases of reads, below a defined quality threshold with leading and trailing.  
Paired and unpaired  reads resulting from Trimmomatic cleaning were  distinguished  in dedicated output files, for each forward and reverse reads 
Reads quality was performed again with fastqc to assess trimming efficiency. 

A second quality testing of RNA datas was made to assess the cleaning.



## Transcriptome assembly with Trinity
Since no genome is available for Myotis Velifer, we performed de novo genome assembly using transcriptomic datas from both interferon and control conditions.In line with a paired-end analysis, for all six libraries only paired reads outputs of Timommatic were used. Trinity assembles the transcriptome using a Debreui Graph strategy. Transcripts with similar sequences are grouped in clusters that roughly correspond to a gene. Each clusters are treated separately to finally reconstruct the genome.  

To run Trinity, we indicated the fastqc format of the input files (--seqType) and precised left reads (R1_paired) and rights reads (R2_paired)files so that Trinity could process both reads types' informations separately.
We also mentioned reads position and orientation on  fragments strains (SS--lib--type) for correct lecture of the reads. In this study, sequencing was performed in "firstrand " (fr) or rf in Trinity. 
For more information on Trinity commands (memory and CPU), see Trinity.sh script

Trinity distinguishes transcripts isoforms (Trinity.fasta) and associate them to the corresponding gene (Trinity.fasta.gene_tras_map). In the assembled transcriptome outputs  processed reads are associated to a cluster (DN []_C[]), a gene (g[]) and an isoform (i []). 400 000 distinct transcripts were identified by Trinity and 311 364 genes (excluding  isoforms distinctions). These results are abnormally high if we compare with the 20 000 genes of human genome. This could be due to the inclusion of excessively short read for genome assembly.

Once the transcriptom assembled, next step was to annotate it to identify transcripts' functions. Indeed, our final goal was to characterize gene differential expresion in antiviral responses in yotis Velufer.

#Transcriptome annotation

To identify coding regions within trinity transcripts sequences we used TransDecoder. ORFs were first identified running Transdecoder.Longorfs on assembled transcriptome (Trinity.fasta) with the gene correspondance (Trinity.fasta.gene_trans_map.). We retained only transcripts sequences encoding for proteins of at least 100 amino acidslong, with the m-parameter, see Transdecoder.sh
Then, coding regions (CDS) candidates were detected by Transdecoder.Predict. We filtered regions with best coding , that appear in trinity.fasta.transdecoder.cds file. In this This final output are reported nucleotide sequences of the selected coding sequences.
To infer the biological function of  these CDS we searched for sequence homologies with human CDS. Indeed, human CDS are better annotate than the genome of bats species  phylogenetically closer to Myotis velifer. 
Homologies between Myotis Velifer identified CDS and Human CDS were searched with Blast. 
Blast running requires to build a database listing human CDS. Those were downloaded from Ensembl online database with wget command. Then makeblastdb application enabled to organize those CDS in a database assigning an unique identifier to every sequence. Nucleotidic nature of the sequences and fasta format of downloaded CDS were indicated respectively with dbtype 'nucl'and -parse_seqids parameters.

To  find sequences homologies, we align Myotis velifer selected CDS on human CDS database with the blastn program. Indeed both sequences in blast database (subjects sequences) and Transdecoder CDS outputs (query sequences) are nucleotidic. We chose to only select one hit result for every asembled contig (-max_target_seqs parameter) and limited blast e-value of 10<sup>-4</sup>, meaning that the probability this hit occured by chance would be one on 10 000. The first 6 aligned CDS were visualized with -outfmt parameter. 
 -faire code transdecoder + blast
In parallel with the annotation of the assembled transcriptome another step was to quantify transcripts expression.

## Transcripts quantification


To determine transcripts levels in control and interferon conditions,we used Salmon software. It aligns reads on corresponding transcripts for quantification.  


*Building of an index for Salmon quasi-mapping

Salmon quantification requires an index listing  fragments of a fixed length k (k-mères) that could sequence each given transcript. Indeed, Salmon does not perform a per base alignment but rather detect matches with transcripts sequences for quantification.  We thus establish salmon index with trinity outputs keeping the default value k=31 for listed k-mères. 


*Salmon quantification

For analysis reliability, we quantified only the paired reads, previously trimmed with Trimmomatic. We also implement Salmon quantification accuracy through the GC bias inclusion (--gcBias command) and a more selective mapping algorithm for alignement (--validateMappings command).
Among quant outputs, we focused on the transcripts per million (TPM)results. It corresponds to an fine estimation of transcripts quantities through gene length   and deepthness sequencing normalization of row counts. 

Surprisingly, on average only  40% of reads were aligned by Salmon (mapping rate result), which suggests an important loss of data and a possible underestimated quantification. Indeed, Salmon excludes reads with insufficient alignment and imperfect final sequence matches. 

![GitHub Logo](/images/head-quantoutputs_lib1.png|width=30%)

*Extract of salmon quantification outputs for paired reads of the first library (CTL). 


As shown above, Salmon provide probabilistic values of 

quantification is isoform specific. To determine gene- level  expression  we used the tximport package that sums same-gene-derived transcripts informations. To this purpose we create a dataframe (tx2gene=trini1) based on  Trinity gene transmap associating transcripts ID to gene IDs.
Thus Tximport summed the Salmon transcripts level datas for each corresponding gene. Tximport outputs are thus provide probabilistic values of gene length and corresponding reads' count and  abundance.  
 


2 séquences nucléotides à assembler parallèlement, correspondant aux 2 brins (associés à un read chacun)
Read 1 correspond au Read apparié à gauche, Read 2 à doite, 
R1 dans le sens 5'3', R1 sur le brin reverse de l'arnm
R2 ont une séquence équivalente à ARNm
CF: point Q1.9 (orientation of SENSE reads)
https://www.lexogen.com/sense-mrna-sequencing/

NB: de nombreuses stratégies de séquençage en paired-end possibles 
Cf image corentin 
https://ue-ngs-students.slack.com/files/U01DH0HMTDZ/F01F066R259/image.png









## Remappin des reads sur le transcriptome assemblé: Salmon (Mercredi 18)


Génération d'un index pour faciliter (plus rapide) l'alignement des reads sur le transcript via salmon index.

Quantification via salmon quant. 
Indication d'un squençage en paired end 
ésultats du running de  salmon quant jugés bons pour plus de 80% des reads alignés




## Annoter les gènes transcripts : 2 approches
Objectif:   avoir une vision fonctionnelle des transcripts dans le cadre de l'étude la réponse antivirale chez les chauve souris en cherchant des homologies de séquence.



# Diferential expression
OnCe obtained gene expression levels, we could compare the transcription profile between control and interferon-treated conditions. We thus create a data set (ddsTxi) with Tximport gene-level quantification data in the 6 samples and the corresponding experimental conditions (see dimensions ddsTxi: 311 364 genes or rownames and 6colnames or samples). To calculate gene  differential  expression between conditions, we use DESeq2 function on this data set.

![GitHub Logo](/images/dds_res.png){width=50%} 

DESeq2 output provide for each gene a control condition normalized level of expression (BaseMean). The log2 foldchange informs on the ratio between the expression mean of both conditions. The p-value indicate the probability to observe a differential expression under H0 hypothesis (by chance). Consequently to gene-level summarization of transcripts expression, an adjustment of the p-value is necessary (padj). Indeed, assembled isoforms value could lead to repetition-induced statistical difference.  
We looked at the genes for which the padj was lower than 0,1. 1745 genes on 295 779 were found with a significant differential expression (padj<0,1) under interferon treatment. 

Analysing the 5 samples (libraries) 1896 genes on 287 553 analyzed were fund with a significantly different expression comparing control and interferon treatment 


*Graphic readout

We visualized genes with a log fold change ranging from -2 (downregulated) to 2 (upregulated) in function of the normalized mean expression with MA plot.
This points that most of the genes with significant differential expression (in blue) are upregulated one.


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
