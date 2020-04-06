# AB33_A
patient=AB33
timepoint=A
sample=$patient\_$timepoint
samtools view $patient\_raw_bam/$sample\.bam -H > $patient\_raw_bam/$sample\.sam
sed 's/AB-33A/AB33_A/g' $patient\_raw_bam/$sample\.sam | sed 's/AB_33A/AB33_A/g' > $patient\_raw_bam/$sample\.revised.sam
samtools reheader $patient\_raw_bam/$sample\.revised.sam $patient\_raw_bam/$sample\.bam > $patient\_bam/$sample\.bam
samtools view -H $patient\_bam/$sample\.bam | grep "^@RG"
samtools index $patient\_bam/$sample\.bam
# AB33_C
timepoint=C
sample=$patient\_$timepoint
samtools view $patient\_raw_bam/$sample\.bam -H > $patient\_raw_bam/$sample\.sam
sed 's/AB-33C/AB33_C/g' $patient\_raw_bam/$sample\.sam | sed 's/AB_33C/AB33_C/g' > $patient\_raw_bam/$sample\.revised.sam
samtools reheader $patient\_raw_bam/$sample\.revised.sam $patient\_raw_bam/$sample\.bam > $patient\_bam/$sample\.bam
samtools view -H $patient\_bam/$sample\.bam | grep "^@RG"
samtools index $patient\_bam/$sample\.bam
# AB33_G
timepoint=G
sample=$patient\_$timepoint
samtools view $patient\_raw_bam/$sample\.bam -H > $patient\_raw_bam/$sample\.sam
sed 's/17334-16A/AB33_G/g' $patient\_raw_bam/$sample\.sam | sed 's/X17334_16A/AB33_G/g' > $patient\_raw_bam/$sample\.revised.sam
samtools reheader $patient\_raw_bam/$sample\.revised.sam $patient\_raw_bam/$sample\.bam > $patient\_bam/$sample\.bam
samtools view -H $patient\_bam/$sample\.bam | grep "^@RG"
samtools index $patient\_bam/$sample\.bam
