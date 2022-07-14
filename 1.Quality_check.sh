#!/bin/bash

#SBATCH --export=ALL # export all environment variables to the batch job

#SBATCH -D . # set working directory to .

#SBATCH -p pq # submit to the parallel queue

#SBATCH --time=20:00:00 # maximum walltime for the job

#SBATCH -A Research_Project-T116798 # research project to submit under

#SBATCH --nodes=1 # specify number of nodes

#SBATCH --ntasks-per-node=8 # specify number of processors per node

#SBATCH --mem=40G # specify bytes memory to reserve

#SBATCH --mail-type=END # send email at job completion

module purge
module load FastQC
module load MultiQC

reads_dir=$1
out_dir=$2
filetype=$3

mkdir -p $out_dir

for file in $reads_dir/*$filetype;do
        fastqc $file -o $out_dir -t 8
 done

cd $out_dir
multiqc .
