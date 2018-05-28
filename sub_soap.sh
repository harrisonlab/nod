#!/bin/bash

# Assemble illumina data using soapdenovo2

#$ -S /bin/bash
#$ -cwd
#$ -pe smp 24
#$ -l virtual_free=15.5G
#$ -l h=blacklace11.blacklace

Usage="sub_soap.sh <config.file> <outputdir> <kmer> <filestocopy>"
echo "$Usage"

# ---------------
# Step 1
# Collect inputs
# ---------------

config=$1
OutDir=$2
Size=$3
dirmv=$4

echo  "Running Soap2 with the following inputs:"
echo "config - $config"
echo "OutDir - $OutDir"
echo "kmer - $Size"
echo "file with files to move $dirmv"

CurPath=$PWD
WorkDir="$TMPDIR"/soap


# ---------------
# Step 2
# Run soap
# ---------------

mkdir -p $WorkDir
#copy files to temp (https://linux.101hacks.com/linux-commands/xargs-command-examples/)
cat $dirmv |xargs -n1 -i cp {} $WorkDir

cd $WorkDir

SOAPdenovo-63mer all -s $config -o $WorkDir/outputGraph -K $Size -p 24

mkdir -p $CurPath/$OutDir
cp $WorkDir/* $CurPath/$OutDir/.
