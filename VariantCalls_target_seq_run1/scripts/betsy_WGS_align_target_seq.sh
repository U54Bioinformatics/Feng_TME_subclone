#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=120G
#SBATCH --time=90:00:00
#SBATCH --output=betsy_WGS_align_target_seq.sh.%A_%a.stdout
#SBATCH -p all,abild
#SBATCH --workdir=./

#sbatch --array 1 run_speedseq_qsub.sh


#export PATH=$PATH:/home/jichen/software/Python_lib64/lib64/python2.7/site-packages/genomicode/bin/
export PATH=/home/jichen/software/Python_lib64/lib64/python2.7/site-packages/genomicode/bin/:$PATH
export PYTHONPATH=/home/jichen/software/Python_lib64/lib64/python2.7/site-packages:/home/jichen/software/Python_lib/lib/python2.7/site-packages/:$PYTHONPATH


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
#GENOME=/home/jichen/Projects/Database/Reference/hg19
GENOME=/net/isi-dcnl/ifs/user_data/abild/Genomes/Broad.GRCh37/GRCh37
adapters=/home/jichen/Projects/Breast/WGS/MDS_Kahn/Reference/illumina_adapters.fasta
bed=/home/jichen/Projects/Breast/scRNA/Data/Agilent_SureSelect_XT_Human_v7.nochr.bed

prefix=Feng_target_run1
betsy_run.py --environment coh_slurm --receipt betsy_WGS_align_receipt.txt --num_cores $CPU \
    --network_json betsy_WGS_align_network_json.txt --network_png betsy_WGS_align_network.pdf \
    --input FastqFolder --input_file $prefix\_fastq \
    --input SampleGroupFile --input_file $prefix\_sample.txt \
    --input ReferenceGenome --input_file $GENOME/Homo_sapiens_assembly19.fasta \
    --output BamFolder --output_file $prefix\_bam \
    --dattr BamFolder.sorted=coordinate \
    --dattr BamFolder.has_read_groups=yes \
    --dattr BamFolder.duplicates_marked=no \
    --dattr BamFolder.indel_realigned=yes \
    --dattr BamFolder.base_quality_recalibrated=no \
    --dattr BamFolder.indexed=yes \
    --dattr BamFolder.aligner=bwa_mem \
    --dattr BamFolder.adapters_trimmed=yes \
    --mattr check_fastq_pairs=no \
    --mattr adapters_fasta=$adapters  \
    --mattr realign_known_sites1=$GENOME/Mills_and_1000G_gold_standard.indels.b37.vcf.gz \
    --mattr realign_known_sites2=$GENOME/1000G_phase1.indels.b37.vcf.gz \
    --mattr recal_known_sites1=$GENOME/Mills_and_1000G_gold_standard.indels.b37.vcf.gz \
    --mattr recal_known_sites2=$GENOME/1000G_phase1.indels.b37.vcf.gz \
    --mattr recal_known_sites3=$GENOME/dbsnp_138.b37.vcf.gz \
    --run
 
end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"

