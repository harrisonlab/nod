# nod
Plant genome assembly


#Download the files
```
nohup xargs -n1 fastq-dump -I --split-3 --gzip --skip-technical <sralist.txt &
```
#build the directory structure
```
./build_dir.pl dryas.csv
./build_dir.pl purshia.csv
```


# PURSHIA ANALYSIS
```
mv SRR531400* ./purshia/raw_dna/paired/purshia/strain1/.
cd ./purshia/raw_dna/paired/purshia/strain1/
mv SRR531400*_1.* ./F
mv SRR531400*_2.* ./R
cd ~/scratch/dryas/purshia
```
#Paired end QC
#ensure you are in the correct directory location

```
for RawData in $(ls raw_dna/paired/purshia/strain1/*/*.fastq.gz); do
echo $RawData;
ProgDir=/home/harrir/git_repos/seq_tools/dna_qc;
qsub $ProgDir/run_fastqc.sh $RawData;
done
```

#trimming PE libs
#ensure you are in the correct directory location

```
Read_F=$(ls raw_dna/paired/purshia/strain1/F/SRR5314001_1.fastq.gz )
Read_R=$(ls raw_dna/paired/purshia/strain1/R/SRR5314001_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA

Read_F=$(ls raw_dna/paired/purshia/strain1/F/SRR5314004_1.fastq.gz )
Read_R=$(ls raw_dna/paired/purshia/strain1/R/SRR5314004_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA

Read_F=$(ls raw_dna/paired/purshia/strain1/F/SRR5314002_1.fastq.gz )
Read_R=$(ls raw_dna/paired/purshia/strain1/R/SRR5314002_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA

Read_F=$(ls raw_dna/paired/purshia/strain1/F/SRR5314005_1.fastq.gz )
Read_R=$(ls raw_dna/paired/purshia/strain1/R/SRR5314005_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA

Read_F=$(ls raw_dna/paired/purshia/strain1/F/SRR5314003_1.fastq.gz )
Read_R=$(ls raw_dna/paired/purshia/strain1/R/SRR5314003_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA
```

#kmer for size estimate


#ASSEMBLY
#ensure you are in the correct directory location

```
cd /data/scratch/harrir/dryas/purshia
qsub /home/harrir/git_repos/nod/sub_soap.sh /home/harrir/git_repos/nod/purshia.config ./assembly/ 63 /home/harrir/git_repos/nod/paths.purshia
```

#quast
```
ProgDir=/home/harrir/git_repos/seq_tools/assemblers/assembly_qc/quast
Assembly=$(ls -d assembly/OUTPUTFILE.FASTA)
OutDir=$(ls -d assembly/filtered_contigs)
qsub $ProgDir/sub_quast.sh $Assembly $OutDir
```



#DRYAS ANALYSIS
#add additional directories
mkdir /data/scratch/harrir/dryas/dryas/raw_dna/mates/
mkdir /data/scratch/harrir/dryas/dryas/raw_dna/mates/dryas
mkdir /data/scratch/harrir/dryas/dryas/raw_dna/mates/dryas/strain1
mkdir /data/scratch/harrir/dryas/dryas/raw_dna/mates/dryas/strain1/F
mkdir /data/scratch/harrir/dryas/dryas/raw_dna/mates/dryas/strain1/R


#Define paired end and mate data for the various genomes- move stuff around
mv SRR5313975_1.fastq.gz ./dryas/raw_dna/paired/dryas/strain1/F/
mv SRR5313976_1.fastq.gz ./dryas/raw_dna/paired/dryas/strain1/F/
mv SRR5313977_1.fastq.gz ./dryas/raw_dna/paired/dryas/strain1/F/
mv SRR5313978_1.fastq.gz ./dryas/raw_dna/paired/dryas/strain1/F/
mv SRR5313979_1.fastq.gz ./dryas/raw_dna/paired/dryas/strain1/F/

mv SRR5313975_2.fastq.gz ./dryas/raw_dna/paired/dryas/strain1/R/
mv SRR5313976_2.fastq.gz ./dryas/raw_dna/paired/dryas/strain1/R/
mv SRR5313977_2.fastq.gz ./dryas/raw_dna/paired/dryas/strain1/R/
mv SRR5313978_2.fastq.gz ./dryas/raw_dna/paired/dryas/strain1/R/
mv SRR5313979_2.fastq.gz ./dryas/raw_dna/paired/dryas/strain1/R/

mv SRR5313980_1.fastq.gz ./dryas/raw_dna/mates/dryas/strain1/F/
mv SRR5313981_1.fastq.gz ./dryas/raw_dna/mates/dryas/strain1/F/
mv SRR5313982_1.fastq.gz ./dryas/raw_dna/mates/dryas/strain1/F/

mv SRR5313980_2.fastq.gz ./dryas/raw_dna/mates/dryas/strain1/R/
mv SRR5313981_2.fastq.gz ./dryas/raw_dna/mates/dryas/strain1/R/
mv SRR5313982_2.fastq.gz ./dryas/raw_dna/mates/dryas/strain1/R/

#enter into project directory
cd /data/scratch/harrir/dryas/dryas/

# Paired end
for RawData in $(ls raw_dna/paired/dryas/strain1/*/*.fastq.gz); do
echo $RawData;
ProgDir=/home/harrir/git_repos/seq_tools/dna_qc;
qsub $ProgDir/run_fastqc.sh $RawData;
done


# Mate pair
for RawData in $(ls raw_dna/mates/dryas/strain1/*/*.fastq.gz); do
echo $RawData;
ProgDir=/home/harrir/git_repos/seq_tools/dna_qc;
qsub $ProgDir/run_fastqc.sh $RawData;
done


#trimming PE libs
#ensure you are in the correct directory location
#SRR5313975	170bp
#SRR5313976	250bp
#SRR5313977	350bp
#SRR5313978	500bp
#SRR5313979	800bp

```
Read_F=$(ls raw_dna/paired/dryas/strain1/F/SRR5313975_1.fastq.gz )
Read_R=$(ls raw_dna/paired/dryas/strain1/R/SRR5313975_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA

Read_F=$(ls raw_dna/paired/dryas/strain1/F/SRR5313976_1.fastq.gz )
Read_R=$(ls raw_dna/paired/dryas/strain1/R/SRR5313976_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA

Read_F=$(ls raw_dna/paired/dryas/strain1/F/SRR5313977_1.fastq.gz )
Read_R=$(ls raw_dna/paired/dryas/strain1/R/SRR5313977_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA

Read_F=$(ls raw_dna/paired/dryas/strain1/F/SRR5313978_1.fastq.gz )
Read_R=$(ls raw_dna/paired/dryas/strain1/R/SRR5313978_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA

Read_F=$(ls raw_dna/paired/dryas/strain1/F/SRR5313979_1.fastq.gz )
Read_R=$(ls raw_dna/paired/dryas/strain1/R/SRR5313979_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA
```

#trimming MP libs
#ensure you are in the correct directory location
#Dryas libraries

#SRR5313980	2kp
#SRR5313981	6kp
#SRR5313982	10kp


Read_F=$(ls raw_dna/mates/dryas/strain1/F/SRR5313980_1.fastq.gz )
Read_R=$(ls raw_dna/mates/dryas/strain1/R/SRR5313980_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA

Read_F=$(ls raw_dna/mates/dryas/strain1/F/SRR5313981_1.fastq.gz )
Read_R=$(ls raw_dna/mates/dryas/strain1/R/SRR5313981_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA

Read_F=$(ls raw_dna/mates/dryas/strain1/F/SRR5313982_1.fastq.gz )
Read_R=$(ls raw_dna/mates/dryas/strain1/R/SRR5313982_2.fastq.gz )
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA

```

# do kmer counting on PE data
#  for Strain in dryas; do
#    echo $Strain
#    Trim_F=$(ls qc_dna/paired/P.*/$Strain/F/*.fq.gz)
#    Trim_R=$(ls qc_dna/paired/P.*/$Strain/R/*.fq.gz)
#    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc
#    qsub $ProgDir/kmc_kmer_counting.sh $Trim_F $Trim_R
#  done

#ASSEMBLY
#ensure you are in the correct directory location

```
cd /data/scratch/harrir/dryas/purshia
qsub /home/harrir/git_repos/nod/sub_soap.sh /home/harrir/git_repos/nod/dryas.config ./assembly/ 63 /home/harrir/git_repos/nod/paths.dryas
```




#Dryas libraries
SRR5313975	170bp
SRR5313976	250bp
SRR5313977	350bp
SRR5313978	500bp
SRR5313979	800bp
SRR5313980	2kp
SRR5313981	6kp
SRR5313982	10kp

#Purshia libraries
SRR5314001	170bp
SRR5314002	250bp
SRR5314003	350bp
SRR5314004	500bp
SRR5314005	800bp





#run quast

 for Strain in $(ls -d assembly/spades/*/* | rev | cut -f1 -d'/' | rev); do
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/assemblers/assembly_qc/quast
    Assembly=$(ls -d assembly/spades/*/$Strain/filtered_contigs/contigs_min_500bp.fasta)
    Species=$(echo $Assembly | rev | cut -f4 -d'/' | rev)
    OutDir=$(ls -d assembly/spades/*/$Strain/filtered_contigs)
    qsub $ProgDir/sub_quast.sh $Assembly $OutDir
  done


#transcriptomes

#Purshia (SRA/read/tissue/lib)
SRR5349296	101	Nodule	170
SRR5349297	151	Root	300

#Dryas (SRA/read/tissue/lib)
SRR5349264	101	Seeding	170
SRR5349265	101	Leaf	170
