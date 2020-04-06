cp ../../FELINE/FELINE_merged_011_040_premrna/VariantCalls_SNPs_test/betsy_WGS_variants_FELINE.sh ./
cp ../FELINE/FELINE_merged_011_040_premrna/VariantCalls_SNPs_test/FEL022_sample.txt ./
cp ../FELINE/FELINE_merged_011_040_premrna/VariantCalls_SNPs_test/FEL022_normal_cancer.txt ./
cp ../../FELINE/FELINE_merged_011_040_premrna/VariantCalls_SNPs_test/FELINE_patients.list ./

echo "create bam folder and sample/normal-cancer table"
bash create_bam_folders.sh

echo "fix sample id in bam because Betsy is strict about this"
samtools view AB14_bam/AB-14D.bam -H > AB-14D.sam
sed 's/AB-14D/AB14_D/g' AB-14D.sam | sed 's/AB_14D/AB14_D/' > AB-14D.revised.sam
samtools reheader AB-14D.revised.sam AB14_bam/AB-14D.bam > AB-14D.revised.bam
#AB-14A, AB_14A         -> AB14_A
#AB-14D, AB_14D         -> AB14_D
#17-334-02B,X17_334_02B -> AB14_G
# rename sample in bam files
# AB14_A
samtools view AB14_raw_bam/AB14_A.bam -H > AB14_raw_bam/AB14_A.sam
sed 's/AB-14A/AB14_A/g' AB14_raw_bam/AB14_A.sam | sed 's/AB_14A/AB14_A/' > AB14_raw_bam/AB14_A.revised.sam
samtools reheader AB14_raw_bam/AB14_A.revised.sam AB14_raw_bam/AB14_A.bam > AB14_bam/AB14_A.bam
# AB14_D
samtools view AB14_raw_bam/AB14_D.bam -H > AB14_raw_bam/AB14_D.sam
sed 's/AB-14D/AB14_D/g' AB14_raw_bam/AB14_D.sam | sed 's/AB_14D/AB14_D/' > AB14_raw_bam/AB14_D.revised.sam
samtools reheader AB14_raw_bam/AB14_D.revised.sam AB14_raw_bam/AB14_D.bam > AB14_bam/AB14_D.bam
# AB14_G
samtools view AB14_raw_bam/AB14_G.bam -H > AB14_raw_bam/AB14_G.sam
sed 's/17-334-02B/AB14_G/g' AB14_raw_bam/AB14_G.sam | sed 's/X17_334_02B/AB14_G/' > AB14_raw_bam/AB14_G.revised.sam
samtools reheader AB14_raw_bam/AB14_G.revised.sam AB14_raw_bam/AB14_G.bam > AB14_bam/AB14_G.bam
#AB-28A, AB-28A       -> AB28_A
#AB-28B, AB-28B       -> AB28_B
#17334-15B,X17334_15B  -> AB28_G
# AB28_A
patient=AB28
timepoint=A
sample=$patient\_$timepoint
samtools view $patient\_raw_bam/$sample\.bam -H > $patient\_raw_bam/$sample\.sam
sed 's/AB-28A/AB28_A/g' $patient\_raw_bam/$sample\.sam | sed 's/AB_28A/AB28_A/g' > $patient\_raw_bam/$sample\.revised.sam
samtools reheader $patient\_raw_bam/$sample\.revised.sam $patient\_raw_bam/$sample\.bam > $patient\_bam/$sample\.bam
# AB28_B
timepoint=B
sample=$patient\_$timepoint
samtools view $patient\_raw_bam/$sample\.bam -H > $patient\_raw_bam/$sample\.sam
sed 's/AB-28B/AB28_B/g' $patient\_raw_bam/$sample\.sam | sed 's/AB_28B/AB28_B/g' > $patient\_raw_bam/$sample\.revised.sam
samtools reheader $patient\_raw_bam/$sample\.revised.sam $patient\_raw_bam/$sample\.bam > $patient\_bam/$sample\.bam
# AB28_G
timepoint=G
sample=$patient\_$timepoint
samtools view $patient\_raw_bam/$sample\.bam -H > $patient\_raw_bam/$sample\.sam
sed 's/17334-15B/AB28_G/g' $patient\_raw_bam/$sample\.sam | sed 's/X17334_15B/AB28_G/g' > $patient\_raw_bam/$sample\.revised.sam
samtools reheader $patient\_raw_bam/$sample\.revised.sam $patient\_raw_bam/$sample\.bam > $patient\_bam/$sample\.bam

bash create_bam_folders_rename_AB14.sh
bash create_bam_folders_rename_AB28.sh
bash create_bam_folders_rename_AB33.sh
bash create_bam_folders_rename_AB62.sh
