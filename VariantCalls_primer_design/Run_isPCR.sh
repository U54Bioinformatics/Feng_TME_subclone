#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=100G
#SBATCH --time=5:00:00
#SBATCH --output=Run_isPCR.sh.stdout
#SBATCH -p fast,all
#SBATCH --workdir=./

#sbatch --array 1 run_speedseq_qsub.sh


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

#./isPcr -out=bed /home/jichen/Projects/Database/Genomes/Broad.GRCh37/GRCh37/Homo_sapiens_assembly19.fasta ABall.mutation.primers.table4isPCR.txt ABall.mutation.primers.table4isPCR.out.bed
#./isPcr -out=bed /home/jichen/Projects/Database/Genomes/Broad.GRCh37/GRCh37/Homo_sapiens_assembly19.fasta ABadd1.mutation.primers.table4isPCR.txt ABadd1.mutation.primers.table4isPCR.out.bed
./isPcr -out=bed /home/jichen/Projects/Database/Genomes/Broad.GRCh37/GRCh37/Homo_sapiens_assembly19.fasta ABall.mutation.primers.table_handles4isPCR.txt ABall.mutation.primers.table_handles4isPCR.out.bed


end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"

