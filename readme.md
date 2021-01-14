
---
output:
  html_document: default
  pdf_document: default
---

# Characterization of the interferon response in a microbat species


## Introduction

Bats are frequently exposed to a large spectrum of viruses but seem asymptomatic. Specific immune responses would have developed in bats through a long-term cohabitation with viruses to reach an equilibrium between viral resistance and tolerance. This high tolerance to viruses is thought to be due to a particularly performing antiviral interferon (IFN) response. Indeed, among innate immune responses to viral agents, interferon synthesis activates the expression of hundred of genes: Interferon Stimulated Genes (ISG). Some ISGs protect from viral infection impairing viral replication steps. The IFN system has been largely studied in megabats but fewer studies have been done in microbats.  
Here we aimed at identifying genes stimulated by the interferon response in *Myotis velifer* species of microbat. We performed analyses of transcriptomic data collected by L. Etienne's research team. This first implied trimming and quality assessment steps. Then came transcriptome assembly and annotation steps as *Myotis Velifer* genome is unknown. In parallel, trancripts level under interferon stimulation or not were estimated through reads quantification. Finally associated  genes were identified comparing with homologous known human ISGs.  

<img src="images/workflow_tp.png" alt="legend (paired end sequencing)" width="80%"/>


## Obtention of biological data

Analyzed RNA-seq data derive from 6 samples of Myotis velifer's fibroblasts cultures.  Cultured fibroblasts have been incubated with interferon for 6 hours (IFN samples) or with medium only for control (CTL) samples. mRNA seq libraries were obtained through reverse transcription of transcripts into double-stranded complementary DNA. To amplify libraries, PCR was performed on those cDNA fragments fused with adapters pairs. A quality control was done to assess DNA concentration before sequencing DNA reads with Illumina Seq technique. Sequencing was performed in paired-end: each DNA fragments was sequenced from both ends. This generated two reads per fragment, R1 and R2 reads of approximately 150pb, delimiting an unknown sequence ("inner distance" on the scheme). Reads R1 have a forward orientation (5'-3') and  R2 a reverse-complement orientation with a  sequence corresponding to the mRNA one. R1 and R2 sequences are classified into two fastq files per libraries.
Paired-end sequencing is longer and more expensive  but it better detects DNA rearrangements and repetitions providing high quality sequencing. Subsequently read pairs improve alignment accuracy through longer contigs for the *de novo* assembly step. Biological and associated sequencing-quality data were combined in fastq files : the raw data of downstream analyses.


<img src="images/paired-end-read-1.png" alt="legend (paired end sequencing)" width="60%"/>

*Scheme of paired-end sequencing, picture from thesequencingcenter.com*


## Assessment of RNA-seq data quality: Fastqc 

We first assessed the quality of reads' sequencing to determine if sequencing data were reliable enough for transcriptome assembly. To determine reads' quality we ran the fastqc program on each type of reads (forward and reverse) in all samples (see **Testdequalite.sh**). 
Fastqc report presents quality analysis at different sequencing levels (see mydatalocal/output_fastqc). The "Per base sequence quality" analysis shows a drop in sequencing quality for final bases. Decreased sequencing quality with increased read length is due to technical defects. Indeed, in the Illumina technique, among clusters of identical DNA molecule, sequencing of some DNA reads will desynchronize over runs. Consequently, probe signal for nucleotide identification will be less pure, increasing sequencing errors in last runs.


<img src="images/perbasequality_lib1.png" alt="legend (perbasequality)" width="70%"/>

*Bases' quality score in function of base position in the read, quality report for the Lib1 reads library*

The "Per sequence quality scores" indicates a good overall quality score in the great majority of reads in the different libraries. However the per sequence GC content score suggests unreliable read quality. In some libraries, the G proportion is significantly higher whereas we would expect similar proportions of A and T, and G and C, and consequently linear curves. This could be due to a biased sequencing. 

<img src="images/perbaseseqcontent.png" alt="legend (perbaseseqcontent)" width="70%"/>

*Graphic representation of the per base sequence content from the fastqc report of R1 reads, from library 1*


Considering the relative quality of RNA-seq data, especially the dropping at the sequences'end, we cleaned the data. Indeed, a low raw data quality could bias downstream analyses.


## Cleaning of RNA-seq data : Trimmomatic 

Before genome assembly we cleaned data with Trimmomatic (see **NettoyageTrimomatic.sh**).
Note that the cleaning step can also be treated with genome assembly combining program runs. To treat paired reads, we ran Trimmomatic in a paired-end (PE) mode distinguishing forward and reverse read files in input. Nucleotides with a quality score (or phred score) threshold of 33 were filtered. In others words, bases with a correct call probability below  1.10 <sup>-3</sup> were removed. Short reads with a length below 100 bases were also removed with MINLEN software, and the first 9 bases of each reads were suppressed (HEADCROP). Adapters and Illumina-related sequences were also suppressed of the reads (ILLUMINACLIP). Indeed adapters can be sequenced when if they dimerize or if they are read as the extension of short DNA fragments by the sequencer. We could have removed starting or ending bases of reads, below a defined quality threshold with leading and trailing functions.  
Paired and unpaired reads resulting from Trimmomatic cleaning were  distinguished in dedicated output files, for each forward and reverse reads. 
Reads quality was assessed again with fastqc to check trimming efficiency. 


## De novo transcriptome assembly : Trinity
Since no genome is available for *Myotis Velifer*, we performed de *novo* genome assembly with Trinity using transcriptomic data from both interferon and control conditions. In line with the paired-end analysis, for all six libraries only paired reads outputs of Trimmomatic were used. Trinity assembles the transcriptome using a Debreuil Graph strategy. Transcripts with similar sequences are grouped in clusters that roughly correspond to a gene. Each cluster is treated separately to finally reconstruct the genome.  

To run Trinity, we indicated the fastqc format of the input files (--seqType) and precised left reads (R1_paired) and rights reads (R2_paired) files so that Trinity could process both reads' types information separately.
We also mentioned reads position and orientation on fragments' strains (SS--lib--type) for correct lecture of the reads. In this study, sequencing was performed in "firstrand " (fr) or rf in Trinity.  
For more information on Trinity commands (memory and CPU), see **Trinity.sh** script.

Trinity distinguishes transcripts isoforms (Trinity.fasta) and associates them to the corresponding gene (Trinity.fasta.gene_tras_map). In the assembled transcriptome,reads are associated to a cluster (DN []_C[]), a gene (g[]) and an isoform (i []). 400 000 distinct transcripts were identified by Trinity and correspond to 311 364 genes (excluding isoform distinctions). These results are abnormally high if we compare them with the 20 000 genes of the human genome. This could be due to the inclusion of excessively short reads for genome assembly.

<img src="images/trinity_outputs_bis.png" alt="legend (trinity_outputs)" width="80%"/>

*Extract of trinity outputs from Trinity.fasta file. Each transcript is signaled by a chevron.*


Once the transcriptome assembled, next step was to annotate it to identify transcripts' functions. Indeed, our final goal was to characterize genes differential expression in antiviral responses of *Myotis Velifer*.

## Transcriptome annotation : Transdecoder and Blastn
To identify coding regions within trinity transcripts sequences we used TransDecoder. ORFs were first identified running Transdecoder.Longorfs on assembled transcriptome (Trinity.fasta file) and providing the gene correspondence (Trinity.fasta.gene_trans_map file). We retained only transcripts sequences coding for proteins of at least 100 amino acids long, with the m-parameter (see **transdecoder.sh**).
Then, coding regions (CDS) candidates were detected by Transdecoder.Predict and the regions with best coding likelihood were selected. The nucleotidic sequences of the selected CDS are reported in outputs/trandec_data/**trinity.fasta.transdecoder.cds** file.


<img src="images/transdecoder.png" alt="legend (transdecoder)" width="90%"/>

*Scheme of transdecoder inputs and outputs forms.*


To infer the biological functions of these CDS we searched for sequence homologies with human CDS. Indeed, human CDS are better annotate than the genome of bats species who would be phylogenetically closer to *Myotis velifer*. 
Homologies between *Myotis Velifer*'s identified CDS and human CDS were searched with Blast (see **humCDS_Blast.sh**). 
Before running blast, we had to build a reference database listing human CDS for subsequent alignment. Human CDS were imported from Ensembl online database with the wget command. Then makeblastdb application enabled to organize those CDS in a database assigning an unique identifier to every sequence. The nucleotidic nature of the downloaded sequences and their fasta format were indicated respectively with dbtype 'nucl'and -parse_seqids parameters.

To  find sequence homologies, we aligned *Myotis velifer* selected CDS on human CDS database with blastn program. Indeed both sequences in blast database (subjects sequences) and Transdecoder CDS outputs (query sequences) are nucleotidic. We chose to only select one hit result for every assembled contig (-max_target_seqs parameter) and limited blast e-value to 10<sup>-4</sup>, meaning that there would be less than one chance on 10 000 that a found alignment would occur only by chance. The first 6 aligned CDS were visualized with -outfmt parameter. 

<img src="images/blastdb.png" alt="legend (blastdb)" width="100%"/>

*Table of the first six Myotis velifer coding sequences aligned with human ones.*

In parallel with the annotation of the assembled transcriptome another step was to quantify transcripts expression.

## Transcripts quantification : Salmon
To determine transcripts levels in control and interferon conditions, we used Salmon software. It aligns reads on corresponding transcripts for quantification.  


* **Building of an index for Salmon quasi-mapping**

Salmon quantification requires an index listing fragments of a fixed length k (k-mères) that could sequence each given transcript. Indeed, Salmon does not perform a per base alignment but rather detect matches with transcripts sequences for quantification. We thus established a salmon index with trinity outputs keeping the default value k=31 for listed k-mères (see **salmon.sh** script). 


* **Salmon quantification**

For analysis reliability, we quantified only the paired reads, previously trimmed with Trimmomatic. We also implemented Salmon quantification accuracy through the GC bias inclusion (--gcBias command) and a more selective mapping algorithm for alignment (--validateMappings command).

Salmon provides probabilistic values of the effective length of transcripts, abundance and raw counts. The effective length is a length estimation taking into account biases like gc-bias and the fragment length distribution. Num reads are an estimation of the number of reads derived from each transcript since some reads are multi-mapping. The transcripts per million (TPM) results are the ones used for quantification. They are an estimation of the relative abundance of  transcripts and include a normalization by gene length and sequencing depth. 

<img src="images/output_quant.png" alt="legend (salmon quant)" width="80%"/>

*Extract of salmon quantification outputs for paired reads of the first library (CTL).*

Surprisingly, on average only  40% of reads were aligned by Salmon (mapping rate result), which suggests an important loss of data and a possible underestimated quantification. Indeed, Salmon excludes reads with insufficient alignment and imperfect final sequence matches. 

As shown in above table, Salmon results are isoform-specific. To determine gene-level expression we used the tximport package that sums same-gene-derived transcripts information (see **count_table_deseq.rmd** file). To this purpose we created a data frame (see tx2gene=trini1) based on Trinity gene transmap associating transcripts IDs to gene IDs.
Thus Tximport summed Salmon isoform-level data for each corresponding gene.  
 

## Diferential expression : DESeq2
Once obtained gene expression levels, we could compare transcription profiles between control and interferon-treated conditions (see **count_table_deseq.rmd** file for downstream analyses). We thus created a dataset (ddsTxi) with Tximport gene-level quantification data in the 6 samples and the corresponding experimental conditions (see ddsTxi dimensions : 311 364 genes or rownames and 6 colnames or samples). To calculate gene differential  expression between conditions, we use DESeq2 function on this deseq dataset.

* **Gene expression level analysis with DESeq2**   

DESeq2 outputs provide for each gene a control-condition-normalized level of expression (BaseMean). The log2 foldchange informs on the ratio between the expression mean of both conditions. The p-value indicates the probability to observe a differential expression under H0 hypothesis (by chance). Consequently to gene-level summarization of transcripts expression, an adjustment of the p-value is necessary (padj). Indeed, assembled isoforms' values could lead to a repetition-induced statistical difference.  

<img src="images/dds_res_bis.png" alt="legend (gene_DE_DESeq)" width="80%"/> 

We looked at the genes for which the padj was lower than 0,1. 1745 genes on 295 779 were found with a significant differential expression (padj<0,1) under interferon treatment. 


* **Graphic readout of DESeq2 results**

We visualized genes with a log fold change ranging from -2 (downregulated) to 2 (upregulated) in function of the normalized mean expression with MA plot. It points that most of the genes with significant differential expression (in blue) are upregulated ones.

<img src="images/plotMA_ech6.png" alt="legend (plotMA)" width="60%"/>

*MA plot obtained with DESeq2 results on the 6 samples.*

To identify visually upregulated genes, we also displayed DESeq2 results with a heatmap.   

<img src="images/heatmapUpReg.png" alt="legend (HeatMap)" width="70%"/>

*Heatmap of the first ten upregulated genes (padj<0.05).*

* **Analysis of DESeq2 dataset homogeneity**

We also built a two-different principal component analysis (PCA) plot to compare differential gene expression between the 6 samples.
As expected, the transcriptomic profiles of Lib 4, 5 and 6, corresponding to control samples, well cluster. However, the Lib 3 sample significantly stands out the cluster of other IFN-treated samples. This indicates radically different RNA seq data from this library that could be due to different RNA-seq quality (batch effect) or cell populations/culture conditions. In fact, RNA bank for the 3<sup> rd</sup> sample was obtained in another session. Distinct environment parameters in this session could then have impact transcription profiles. 

<img src="images/PCA_ech6.png" alt="legend (PCA)" 
width="70%"/>

*PCA plot obtained with DESeq2 results on the 6 samples.*

Repeating DE analysis, excluding divergent Lib 3 of the dataset, we obtained distinct results (see **ddsTxi_wo3**). The number of differentially expressed genes (padj<0,1) was higher, with 1896 genes on 289 449. The RNA seq data of control and interferon respectively well clustered in the PCA plot, indicating homogeneous profiles. 

Nevertheless, considering the few number of replicates per conditon (3), we chose to conserve the 3<sup> rd</sup> sample in downstream analyses, for a better statistical power.

* **Human annotation of interferon-responsive genes**

To annotate the identified differentially expressed genes, we used BiomaRt software. We associated identifiers from Ensembl to external human gene names (see **tx2geneHomo** table). We then merged them with blast alignments to get a table of differentially expressed transcripts, at a gene level with human gene annotations (see **blastHomoNameUniq**).  

<img src="images/resus_upreg_bis.png" alt="legend (countblast_upreg)"
width="90%"/>

*Extract of upregulated genes' name (padj<0.05) in interferon-treated condition, and related data obtained with DESeq2.*

* **Identification of interferon-modulated pathways**

To better characterize the transcriptomic response to interferon in *Myotis Velifer*, we performed a gene ontology analysis with Gorilla. 

We entered DESeq2 results (see outputs/output_DE_align/ **count_blast_deseq_up** for instance) to visualize the biological pathways corresponding to the regulated genes. 

<img src="images/GO_ech6_upreg_process_def.png" alt="legend (Gene ontology_upreg)" width="50%"/> 

*Extract of biological processes in which IFN-upregulated genes (padj<0.05) are implied. Antigen presentation and defense response to virus processes appear especially upregulated.* 

* **Results' validity and current literature**

To get an idea of our results' validity we compare them with a recent similarly- designed transcriptomic study by Holzer (see https://www.sciencedirect.com/science/article/pii/S2589004219302949).
This study characterizes the interferon response of a kidney-cell line of M. daubentonii species. 


We selected common genes to Holzer's study and ours (see outputs/output_DE_align**Holzer_resUs**) and searched for a convergence of their transcriptomic profile in control and treated conditions. Among common identified genes, 232 showed a differential expression with interferon in both studies. Chi2 analysis showed a statitical significance of convergent transcriptomic profiles between Holzer and us common genes. 
Among common upregulated genes, we found typical ISGs such as SAMD9 (see the **heatmap**), IFI44, IFIH1 and others. Interestingly some well-known ISGs like OAS1, ISG15 were not observed in our study. Nevertheless, reciprocally, some  upregulated genes found, like SP100 do not appear among the established ISGs. 

## Conclusion and perspectives

Successive cleaning and quality controls, accurate quantification, coding selection and gene-level summation seem to have provided reliable data to characterize IFN response in *Myotis Velifer*. However, we also have to look critically at those results, regarding unpaired reads exclusion, the low rate of mapped reads and Lib 3 divergent data. Increasing the number of samples could homogenize data (see Lib 3 problematic) and improve statistical power. The lack of established genome, leading to de novo transcriptome assembly, might also decrease precision and reproducibility of the analysis. Moreover the alignment on human sequences to annotate identified upregulated genes conveys a loss of data. Some genes proper to *Myotis Velifer* or others microbats could have been missed and contribute to *Myotis Velifer's* tolerance to viruses. Therefore it would be interesting to sequence *Myotis Velifer's* genome to better characterize transcripts. Many genes, including non-coding ones remain to be annotated. Another partial solution would be to align *Myotis Velifer* transcripts on others better known microbat genomes.

About the study's design, it could be also interesting to look at the transcriptomic response to viruses. Indeed, the innate immune response against viral infection also passes through IFN-independent pathways.

## Aknowledgments

I would like to thank the sequencing platform team who made the RNA libraries and Lucie Etienne who presented us their project.
I am also grateful for the help of my TP group, and of supervisors: Corentin Dechaud, Romain Bulteau, and especially Marie Cariou and Marie Semon. 


