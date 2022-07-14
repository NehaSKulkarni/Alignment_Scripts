#!/bin/bash

#SBATCH --export=ALL # export all environment variables to the batch job

#SBATCH -D . # set working directory to .

#SBATCH -p pq # submit to the parallel queue

#SBATCH --time=10:00:00 # maximum walltime for the job

#SBATCH -A Research_Project-T116798 # research project to submit under

#SBATCH --nodes=1 # specify number of nodes

#SBATCH --ntasks-per-node=12 # specify number of processors per node

#SBATCH --mem=100G # specify bytes memory to reserve

#SBATCH --mail-type=END # send email at job completion


module purge
module load STAR

fasta_file=$1
gtf_file=$2
index_out=$3
overhang=$4

mkdir -p $index_out
STAR --runThreadN 12 --runMode genomeGenerate --sjdbOverhang $overhang --genomeFastaFiles $fasta_file  --sjdbGTFfile $gtf_file --genomeDir $index_out
