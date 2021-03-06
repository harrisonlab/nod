#!/bin/bash

# Assemble illumina data using soapdenovo2

#$ -S /bin/bash
#$ -cwd
#$ -pe smp 24
#$ -l virtual_free=94.9G
#$ -l h=blacklace01.blacklace|blacklace11.blacklace

Usage="sub_soap.sh <config.file> <outputdir> <kmer> <filestocopy>"
echo "$Usage"

# ---------------
# Step 1
# Collect inputs -l h=blacklace11.blacklace

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

echo "Current path $PWD"
echo "Current path $WorkDir"

# ---------------
# Step 2
# Run soap
# ---------------

mkdir -p $WorkDir
#copy files to temp (https://linux.101hacks.com/linux-commands/xargs-command-examples/)
cd $WorkDir

echo "Current paths $PWD"

base=`cat $dirmv`
ls -d -1 $base"F"/** |xargs -n1 -i cp {} .
ls -d -1 $base"R"/** |xargs -n1 -i cp {} .

SOAPdenovo-63mer all -s $config -o $WorkDir/outputGraph -K $Size -p 24

mkdir -p $CurPath/$OutDir
cp $WorkDir/* $CurPath/$OutDir/.
