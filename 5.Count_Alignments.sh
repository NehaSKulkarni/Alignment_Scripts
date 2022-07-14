#!/bin/bash

#SBATCH --export=ALL # export all environment variables to the batch job

#SBATCH -D . # set working directory to .

#SBATCH -p pq # submit to the parallel queue

#SBATCH --time=10:00:00 # maximum walltime for the job

#SBATCH -A Research_Project-T116798 # research project to submit under

#SBATCH --nodes=1 # specify number of nodes

#SBATCH --ntasks-per-node=8 # specify number of processors per node

#SBATCH --mem=30G # specify bytes memory to reserve

#SBATCH --mail-type=END # send email at job completion#!/bin/bash

module purge
module load Subread

bams_dir=$1
out_dir=$(realpath $2)
gtf=$(realpath $3)

mkdir -p $out_dir

cd $bams_dir
bams=$(ls | grep .bam | tr "\n" " ")

~/bin/subread-2.0.2-Linux-x86_64/bin/featureCounts --extraAttributes gene_name,Length -p -a $gtf -o $out_dir/counts.tsv -T 8 $bams
