#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=50G
#SBATCH --time=10:00:00
#SBATCH --output=betsy_WGS_Qualimap.sh.%A_%a.stdout
#SBATCH -p fast
#SBATCH --workdir=./

#sbatch --array 1-4 betsy_WGS_Qualimap.sh

start=`date +%s`

CPU=$SLURM_NTASKS
if [ ! $CPU ]; then
   CPU=2
fi

N=$SLURM_ARRAY_TASK_ID
if [ ! $N ]; then
    N=1
fi

echo "CPU: $CPU"
echo "N: $N"

prefix=ABall
FILE=`ls $prefix\_bam/*.bam | head -n $N | tail -n 1`
NAME=${FILE%.bam}
bed=/home/jichen/Projects/Breast/scRNA/Data/Agilent_SureSelect_XT_Human_v7.nochr.bed

echo $FILE
echo $NAME

module load Qualimap/2.2.1
if [ ! -e $FILE\_stats ]; then
echo "working $FILE ..."
qualimap bamqc -bam $FILE -nt $CPU --java-mem-size=40G
fi

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"

