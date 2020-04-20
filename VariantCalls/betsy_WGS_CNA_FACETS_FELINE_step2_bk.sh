#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=16
#SBATCH --mem=80G
#SBATCH --time=9:00:00
#SBATCH --output=betsy_WGS_CNA_FACETS_FELINE_step2.sh.%A_%a.stdout
#SBATCH -p all,abild
#SBATCH --workdir=./

#sbatch --array 1 run_speedseq_qsub.sh


export PATH=$PATH:/home/jichen/software/Python_lib64/lib64/python2.7/site-packages/genomicode/bin/
export PATH=$PATH:/home/jichen/software/BETSY/install/bin:~/software/BETSY/install/lib64/python2.7/site-packages/genomicode/bin/
export PYTHONPATH=$PYTHONPATH:/home/jichen/software/Python_lib64/lib64/python2.7/site-packages:/home/jichen/software/Python_lib/lib/python2.7/site-packages/:/home/jichen/software/BETSY/install/lib/python2.7/site-packages
export R_LIBS=/home/jichen/software/BETSY/install/envs/CNA/lib/R/library

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
GTF=/home/jichen/Projects/Database/Genomes/annotations/Homo_sapiens.GRCh37.87.gtf

prefix=FELINE

###############################################
#FELINE_FACETSResults_parameter0/1/2/3/4 are results with different parameters
#double check CNV results and put the most reliable predict in this folder and run this script on this folder to generate
#segment results and gene copy numbers
#$prefix\_FACETSResults
###############################################

#Initial
if true; then
#total < 2mins on apollo
betsy_run.py --environment coh_slurm --receipt betsy_WGS_CNA_FACETS_step2a_receipt.txt --num_cores 16 \
    --network_json betsy_WGS_CNA_FACETS_step2a_network_json.txt --network_png betsy_WGS_CNA_FACETS_step2a_network.pdf \
    --input FACETSResults --input_file $prefix\_FACETSResults \
    --input ReferenceGenome --input_file $GENOME/GRCh37/genome.fa \
    --output ChromosomalSegmentSignalFile --output_file $prefix\_FACETS_ChromSegmentSig.txt \
    --dattr ChromosomalSegmentSignalFile.has_multiple_models=yes \
    --dattr ChromosomalSegmentSignalFile.split_chromosomes=yes \
    --dattr ChromosomalSegmentSignalFile.evenly_spaced=yes \
    --mattr facets_gbuild=hg19 \
    --mattr cn_header=tcn.em \
    --mattr discard_chrom_with_prefix=MT \
    --run
fi

#Segment all
if true; then
#total < 2mins on apollo
betsy_run.py --environment coh_slurm --receipt betsy_WGS_CNA_FACETS_step2b_receipt.txt --num_cores 16 \
    --network_json betsy_WGS_CNA_FACETS_step2b_network_json.txt --network_png betsy_WGS_CNA_FACETS_step2b_network.pdf \
    --input FACETSResults --input_file $prefix\_FACETSResults \
    --input ReferenceGenome --input_file $GENOME/GRCh37/genome.fa \
    --output ChromosomalSegmentSignalFile --output_file $prefix\_FACETS_ChromSegmentSig.cor.txt \
    --also_save_lowest FACETSModelSelectionFile,$prefix\_FACETS_model_selection.txt \
    --dattr ChromosomalSegmentSignalFile.has_multiple_models=no \
    --dattr ChromosomalSegmentSignalFile.split_chromosomes=yes \
    --dattr ChromosomalSegmentSignalFile.evenly_spaced=yes \
    --dattr FACETSModelSelectionFile.model_selection=best_correlation \
    --mattr facets_gbuild=hg19 \
    --mattr cn_header=tcn.em \
    --mattr discard_chrom_with_prefix=MT \
    --run
fi

# Find best model
if true; then
#total < 2mins on apollo
betsy_run.py --environment coh_slurm --receipt betsy_WGS_CNA_FACETS_step2c_receipt.txt --num_cores 16 \
    --network_json betsy_WGS_CNA_FACETS_step2c_network_json.txt --network_png betsy_WGS_CNA_FACETS_step2c_network.pdf \
    --input FACETSResults --input_file $prefix\_FACETSResults \
    --input ReferenceGenome --input_file $GENOME/GRCh37/genome.fa \
    --input FACETSModelSelectionFile --input_file $prefix\_FACETS_model_selection.txt \
    --output ChromosomalSegmentSignalFile --output_file $prefix\_FACETS_ChromSegmentSig.best.txt \
    --dattr ChromosomalSegmentSignalFile.has_multiple_models=no \
    --dattr ChromosomalSegmentSignalFile.split_chromosomes=yes \
    --dattr ChromosomalSegmentSignalFile.evenly_spaced=yes \
    --mattr facets_gbuild=hg19 \
    --mattr cn_header=tcn.em \
    --mattr discard_chrom_with_prefix=MT \
    --run
fi

#Gene level copy number
if true; then
#total < 2mins on apollo
betsy_run.py --environment coh_slurm --receipt betsy_WGS_CNA_FACETS_step2d_receipt.txt --num_cores 16 \
    --network_json betsy_WGS_CNA_FACETS_step2d_network_json.txt --network_png betsy_WGS_CNA_FACETS_step2d_network.pdf \
    --input FACETSResults --input_file $prefix\_FACETSResults \
    --input FACETSModelSelectionFile --input_file $prefix\_FACETS_model_selection.txt \
    --input GTFGeneModel --input_file $GTF \
    --output SignalFile --output_file $prefix\_FACETS_copy_number_gene.txt \
    --dattr SignalFile.has_entrez_gene_info=yes \
    --dattr SignalFile.preprocess=copy_number \
    --mattr facets_gbuild=hg19 \
    --mattr cn_header=tcn.em \
    --mattr discard_chrom_with_prefix=MT \
    --run
fi

end=`date +%s`
runtime=$((end-start))

echo "Start: $start"
echo "End: $end"
echo "Run time: $runtime"

echo "Done"

