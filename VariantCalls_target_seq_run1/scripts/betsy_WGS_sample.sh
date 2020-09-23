#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --mem=8G
#SBATCH --time=9:00:00
#SBATCH --output=betsy_WGS_sample.sh.%A_%a.stdout
#SBATCH -p fast,all
#SBATCH --workdir=./

#sbatch --array 1 run_speedseq_qsub.sh


export PATH=/home/jichen/software/Python_lib64/lib64/python2.7/site-packages/genomicode/bin/:$PATH
#export PATH=$PATH:/home/jichen/software/BETSY/install/bin:~/software/BETSY/install/lib64/python2.7/site-packages/genomicode/bin/
export PYTHONPATH=/home/jichen/software/Python_lib64/lib64/python2.7/site-packages:/home/jichen/software/Python_lib/lib/python2.7/site-packages/:$PYTHONPATH
#export PYTHONPATH=$PYTHONPATH:/home/jichen/software/BETSY/install/lib/python2.7/site-packages:/home/jichen/software/BETSY/install/lib/python2.7
#export R_LIBS=/home/jichen/software/BETSY/install/lib/R/library


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


prefix=Feng_target_run1
betsy_run.py --environment coh_slurm --receipt betsy_WGS_sample_receipt.txt --num_cores 1 \
    --network_json betsy_WGS_sample_network_json.txt --network_png betsy_WGS_sample_network.pdf \
    --input FastqFolder --input_file $prefix\_fastq \
    --output DraftSampleGroupFile --output_file $prefix\_sample.xls \
    --run

xls2txt $prefix\_sample.xls > $prefix\_sample.txt

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"

