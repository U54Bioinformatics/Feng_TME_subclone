#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=80G
#SBATCH --time=40:00:00
#SBATCH --output=betsy_WGS_tumor_normal_pair_FELINE.sh.sh.%A_%a.stdout
#SBATCH -p all,abild
#SBATCH --workdir=./

#sbatch --array 1 run_speedseq_qsub.sh


export PATH=/home/jichen/software/Python_lib64/lib64/python2.7/site-packages/genomicode/bin/:$PATH
export PYTHONPATH=/home/jichen/software/Python_lib64/lib64/python2.7/site-packages:/home/jichen/software/Python_lib/lib/python2.7/site-packages/:/home/jichen/software/BETSY/install/lib/python2.7/site-packages
module load singularity/3.5.3

#export R_LIBS=/home/hmirsafian/miniconda3/envs/mypython/lib/R/library
#export PATH=/home/hmirsafian/Software/Python_lib64/lib64/python2.7/site-packages/genomicode/bin:$PATH
#export PYTHONPATH=/home/hmirsafian/Software/Python_lib64/lib64/python2.7/site-packages/genomicode:/home/hmirsafian/Software/Python_lib/lib/python2.7/site-packages:/home/hmirsafian/miniconda3/envs/mypython/lib/python2.7/site-packages
#export LD_LIBRARY_PATH=/home/hmirsafian/miniconda3/envs/mypython/lib/:/home/hmirsafian/miniconda3/envs/mypython/lib/R/lib


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

#cut into one sequence one file
#perl ~/software/bin/fastaDeal.pl --cuts 1 ~/Projects/Database/Reference/hg19/ucsc.hg19.fasta > hg19.chr1.fasta
#cp ucsc.hg19.fasta.cut/ucsc.hg19.fasta.01 hg19.chrM.fasta
#GENOME=/home/jichen/Projects/Breast/WGS/MDS_Kahn/Reference/hg19
GENOME=/home/jichen/Projects/Database/Genomes
CANCER_GENES=cancer_genes.txt
COSMIC=cosmic.v79.grch37.mutation_data.txt.gz
bed=/home/jichen/Projects/Breast/scRNA/Data/Agilent_SureSelect_XT_Human_v7.nochr.bed

FILE=`cat ABall_patient.list | head -n $N | tail -n 1`

prefix=$FILE
echo $prefix
if [ ! -e $prefix\_tumor_normal_pair.txt ]; then
#total 1 day, 5.7 hours on apollo
betsy_run.py --environment coh_slurm --receipt betsy_WGS_tumor_normal_pair_receipt.txt --num_cores $CPU \
    --network_json betsy_WGS_tumor_normal_pair_network_json.txt --network_png betsy_WGS_tumor_normal_pair_network.pdf \
    --input SimpleVariantMatrix --input_file $prefix\_germline_calls/mutations.txt \
    --dattr SimpleVariantMatrix.caller_suite=general \
    --input NormalCancerFile --input_file $prefix\_normal_cancer.txt \
    --output TumorNormalPairingAnalysis --output_file $prefix\_tumor_normal_pair.txt \
    --run
#xls2txt $prefix\_tumor_burden.txt/tumor_mutation_burden.xls > $prefix\_tumor_burden.txt/tumor_mutation_burden.txt
fi

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"

