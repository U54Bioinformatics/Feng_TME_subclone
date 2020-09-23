echo "data and script"
cp ~/Projects/Breast/scRNA/FELINE/FELINE_merged_011_040_premrna/VariantCalls_align/betsy_WGS_align_WES.sh ./
cp ../VariantCalls/betsy_WGS_germline_variants_FELINE.sh ./
cp ../VariantCalls/Prepare_somatic_variant_VCF_FELINE.py ./
cp ../../FELINE/FELINE_merged_011_040_premrna/VariantCalls_SNPs/vcf_header.vcf ./

###############################Run these commends to reproduce the results#####################
echo "Create fastq data folder for BETSY"
ln -s /home/jichen/Projects/Breast/scRNA/Data/Megatron_data/COH082/FT-SE6344/ Feng_target_run1_fastq

echo "generate a sample file for BETSY"
#output file is "Feng_target_run1_sample.txt"
# AB-11A Group1 -> Illumina index N701
# AB-11A Group2 -> Illumina index N702
# AB-33A Group1 -> Illumina index N703
# AB-33A Group2 -> Illumina index N704
#Filename	Sample	Group	Pair
#SE6344_SA69715_S1_L001_R1_001.fastq	AB-11A	1	1
#SE6344_SA69715_S1_L001_R2_001.fastq	AB-11A	1	2
#SE6344_SA69716_S2_L001_R1_001.fastq	AB-11A	2	1
#SE6344_SA69716_S2_L001_R2_001.fastq	AB-11A	2	2
#SE6344_SA69717_S3_L001_R1_001.fastq	AB-33A	1	1
#SE6344_SA69717_S3_L001_R2_001.fastq	AB-33A	1	2
#SE6344_SA69718_S4_L001_R1_001.fastq	AB-33A	2	1
#SE6344_SA69718_S4_L001_R2_001.fastq	AB-33A	2	2
sbatch betsy_WGS_sample.sh

echo "align reads to h19"
sbatch betsy_WGS_align_target_seq.sh
#BETSY failed, cp and process bam files
cp /net/isi-dcnl/ifs/user_data/abild/jichen/betsy.out/align_with_bwa_mem__B007__0cf7388fe4221c8ded35f5c30ea06307/bwa_mem.bam/AB-11A___G*.bam ./
cp /net/isi-dcnl/ifs/user_data/abild/jichen/betsy.out/align_with_bwa_mem__B007__0cf7388fe4221c8ded35f5c30ea06307/bwa_mem.bam/AB-33A___G*.bam ./
module load samtools
samtools addreplacerg -r "@RG\tID:1\tLB:library\tPL:ILLUMINA\tPU:platform\tSM:AB-11A" -o AB-11A-G1.bam AB-11A___G1.bam
samtools addreplacerg -r "@RG\tID:2\tLB:library\tPL:ILLUMINA\tPU:platform\tSM:AB-11A" -o AB-11A-G2.bam AB-11A___G2.bam
samtools addreplacerg -r "@RG\tID:1\tLB:library\tPL:ILLUMINA\tPU:platform\tSM:AB-33A" -o AB-33A-G1.bam AB-33A___G1.bam
samtools addreplacerg -r "@RG\tID:2\tLB:library\tPL:ILLUMINA\tPU:platform\tSM:AB-33A" -o AB-33A-G2.bam AB-33A___G2.bam
samtools index AB-11A-G1.bam
samtools index AB-11A-G2.bam
samtools index AB-33A-G1.bam
samtools index AB-33A-G2.bam

echo "summary alignment"
sbatch --array 1-4 betsy_WGS_Qualimap.sh

echo "Genotype subclone SNPs that Feng used to do PCR"
## generate vcf file for these SNPs from a table containing SNP coordinate and other valuable information
#input file is the table "Feng_target_run1.knowsites.txt" and "vcf_header.vcf"
#AAPatient       cluster Chrom   Pos     Ref     Alt     Time1.vaf       Time2.vaf
#AB33    4       1       27426952        C       T       7.63    42.02
#AB11    4       1       44443080        C       T       0.22    22.4
#output file is the vcf file "Feng_target_run1.knowsites.sorted.vcf"
sort -k3,3n -k4,4n Feng_target_run1.knowsites.txt > Feng_target_run1.knowsites.sorted.txt
python betsy_target_seq_genotype.knowsite_vcf.py --input Feng_target_run1.knowsites.sorted.txt

## genotype SNPs genotype in target sequences
#input file is "betsy_target_seq_genotype.patient.list"
#AB-11A-G1
#AB-11A-G2
#AB-33A-G1
#AB-33A-G2
#output files are: *.genotype.vcf and *.genotype.vaf.txt
#*.genotype.vcf contains SNP genotype from GATK
#*.genotype.vaf.txt contains allele frequency and read depth extracted from the above vcf file
sbatch --array 1-4 betsy_target_seq_genotype.sh

## merge genotype for each patient sample into a big file
#output file is "Feng_target_run1.knowsites.sorted.genotype.xlsx" which has allele frequency and read depth of REF and ALT allele at each SNP site in each samples
paste Feng_target_run1.knowsites.sorted.txt AB-11A-G1.genotype.vaf.txt AB-11A-G2.genotype.vaf.txt AB-33A-G1.genotype.vaf.txt AB-33A-G2.genotype.vaf.txt| sort -k1,1 -k2,2n -k3,3n -k4,4n > Feng_target_run1.knowsites.sorted.genotype.txt
python ~/software/bin/txt2xlsx.py --input Feng_target_run1.knowsites.sorted.genotype.txt


