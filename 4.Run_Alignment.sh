#!/bin/bash

#SBATCH --export=ALL # export all environment variables to the batch job

#SBATCH -D . # set working directory to .

#SBATCH -p pq # submit to the parallel queue

#SBATCH --time=9:00:00 # maximum walltime for the job

#SBATCH -A Research_Project-T116798  # research project to submit under

#SBATCH --nodes=1 # specify number of nodes

#SBATCH --ntasks-per-node=12 # specify number of processors per node

#SBATCH --mem=80G # specify bytes memory to reserve

#SBATCH --mail-type=END # send email at job completion

module purge
module load STAR

reads_dir=$1
out_dir=$2
r1_syntax=$3
file_type=$4
gtf=$5
genomeDir=$6
overhang=$7

mkdir -p $out_dir
r2_syntax=${r1_syntax//1/2}
echo $r1_syntax
echo $r2_syntax

for R1 in $reads_dir/*${r1_syntax}*$file_type;do
	#cd $out_dir
        R2=${R1/$r1_syntax/$r2_syntax}
        lib=$(basename $R1 ${file_type})
	lib=${lib/${r1_syntax}*/}

	echo
	echo "#################### RUNNING ALIGNMENT FOR: "$lib "######################################"
	echo $R1
	echo $R2
	echo

	STAR --runThreadN 16 \
        --readFilesCommand zcat \
        --readFilesIn $R1 $R2 \
        --outFileNamePrefix $out_dir/$lib"_" \
        --genomeDir $genomeDir \
	--sjdbOverhang $overhang \
        --sjdbGTFfile $gtf \
        --outFilterType BySJout \
        --outSAMtype BAM SortedByCoordinate \
        --outSAMattributes NH HI NM MD AS nM XS
done

cd $out_dir
mkdir bams
mv *.sortedByCoord.out.bam bams
