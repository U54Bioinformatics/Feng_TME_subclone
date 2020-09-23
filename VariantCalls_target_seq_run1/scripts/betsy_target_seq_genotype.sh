#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=80G
#SBATCH --time=4:00:00
#SBATCH --output=betsy_target_seq_genotype.sh.%A_%a.stdout
#SBATCH -p all,abild
#SBATCH --workdir=./

#sbatch --array 1 run_speedseq_qsub.sh


export PATH=$PATH:/home/jichen/software/Python_lib64/lib64/python2.7/site-packages/genomicode/bin/
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

FILE=`cat betsy_target_seq_genotype.patient.list | head -n $N | tail -n 1`

prefix=$FILE
knownSites=Feng_target_run1.knowsites.sorted.vcf
GATK=/opt/GATK/3.8.1.0/GenomeAnalysisTK.jar

echo $prefix


# Call the SNPs from this BAM file generating a VCF file
# using 4 threads (-nt 4) and only calling SNPs, INDELs could be call too
# with the -glm BOTH or -glm INDEL
## add call specific bases
if [ ! -f  $prefix\.genotype.vcf ]; then
 echo "Generating VCF from $prefix\.bam"
 java -Xmx50g -jar $GATK -T UnifiedGenotyper \
  -glm SNP \
  -I $prefix\.bam \
  -R $GENOME/Broad.GRCh37/GRCh37/Homo_sapiens_assembly19.fasta \
  -o $prefix\.genotype.vcf \
  -nt 8 \
  -nct 1 \
  -dcov 1000000 \
  --dbsnp $knownSites \
  --genotyping_mode GENOTYPE_GIVEN_ALLELES \
  --alleles $knownSites \
  --output_mode EMIT_ALL_SITES
fi

#if [ ! -f  $prefix\.genotype.vaf.txt ]; then
   python betsy_target_seq_genotype.VAF_from_VCF.py --input $prefix\.genotype.vcf > $prefix\.genotype.vaf.txt
#fi

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"

