# nod
Plant genome assembly


#Download the files

nohup xargs -n1 fastq-dump -I --split-3 --gzip --skip-technical <sralist.txt &

#build the directory structure

./build_dir.pl dryas.csv
./build_dir.pl purshia.csv



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


# run fastqmcf paired end (modify)

for Strain in strain1; do
echo $Strain
Read_F=$(ls raw_dna/paired/$Strain/F/cact414_130517_S2_L001_R1_001.fastq.gz)
Read_R=$(ls raw_dna/paired/$Strain/R/cact414_130517_S2_L001_R2_001.fastq.gz)
IluminaAdapters=/home/harrir/git_repos/seq_tools/ncbi_adapters.fa
ProgDir=/home/harrir/git_repos/seq_tools/rna_qc
qsub $ProgDir/rna_qc_fastq-mcf.sh $Read_F $Read_R $IluminaAdapters DNA
done


# do kmer counting on PE data
  for Strain in dryas; do
    echo $Strain
    Trim_F=$(ls qc_dna/paired/P.*/$Strain/F/*.fq.gz)
    Trim_R=$(ls qc_dna/paired/P.*/$Strain/R/*.fq.gz)
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/dna_qc
    qsub $ProgDir/kmc_kmer_counting.sh $Trim_F $Trim_R
  done


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




#run an assembly for dryas

 for Strain in 415 416 A4 SCRP245_v2 Bc23 Nov5 Nov77 ONT3; do
    F_Read=$(ls qc_dna/paired/P.*/$Strain/F/*.fq.gz)
    R_Read=$(ls qc_dna/paired/P.*/$Strain/R/*.fq.gz)
    CovCutoff='10'
    ProgDir=/home/armita/git_repos/emr_repos/tools/seq_tools/assemblers/spades
    Species=$(echo $F_Read | rev | cut -f4 -d '/' | rev)
    OutDir=assembly/spades/$Species/$Strain
    echo $Species
    echo $Strain
    qsub $ProgDir/submit_SPAdes.sh $F_Read $R_Read $OutDir correct $CovCutoff
    # qsub $ProgDir/submit_dipSPAdes.sh $F_Read $R_Read $OutDir correct $CovCutoff
  done

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
