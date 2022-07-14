#!/bin/bash

#SBATCH --export=ALL # export all environment variables to the batch job

#SBATCH -D . # set working directory to .

#SBATCH -p pq # submit to the parallel queue

#SBATCH --time=99:00:00 # maximum walltime for the job

#SBATCH -A Research_Project-T116798 # research project to submit under

#SBATCH --nodes=1 # specify number of nodes

#SBATCH --ntasks-per-node=12 # specify number of processors per node

#SBATCH --mem=100G # specify bytes memory to reserve

#SBATCH --mail-type=END # send email at job completion


module purge
module load Trim_Galore


reads_dir=$1
export out_dir=$2
file_type=$3
export r1_syntax=$4
export seq_tech=$5
export r2_syntax=${r1_syntax/1/2}

mkdir -p $out_dir

ls ./$reads_dir/*${r1_syntax}*$file_type | xargs -P12 -I@ bash -c 'trim_galore -q 20 --"$seq_tech" --paired --fastqc -o "$out_dir" "$1" ${1/"$r1_syntax"/"$r2_syntax"}' _ @

cd $out_dir

module purge
module load MultiQC
multiqc .

mkdir trimmed_reads
mkdir quality
mv *.fq* trimmed_reads
mv *html *zip *txt quality
