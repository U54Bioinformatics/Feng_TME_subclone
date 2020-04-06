# AB28_A
patient=AB28
timepoint=A
sample=$patient\_$timepoint
samtools view $patient\_raw_bam/$sample\.bam -H > $patient\_raw_bam/$sample\.sam
sed 's/AB-28A/AB28_A/g' $patient\_raw_bam/$sample\.sam | sed 's/AB_28A/AB28_A/g' > $patient\_raw_bam/$sample\.revised.sam
samtools reheader $patient\_raw_bam/$sample\.revised.sam $patient\_raw_bam/$sample\.bam > $patient\_bam/$sample\.bam
samtools view -H $patient\_bam/$sample\.bam | grep "^@RG"
samtools index $patient\_bam/$sample\.bam
# AB28_B
timepoint=B
sample=$patient\_$timepoint
samtools view $patient\_raw_bam/$sample\.bam -H > $patient\_raw_bam/$sample\.sam
sed 's/AB-28B/AB28_B/g' $patient\_raw_bam/$sample\.sam | sed 's/AB_28B/AB28_B/g' > $patient\_raw_bam/$sample\.revised.sam
samtools reheader $patient\_raw_bam/$sample\.revised.sam $patient\_raw_bam/$sample\.bam > $patient\_bam/$sample\.bam
samtools view -H $patient\_bam/$sample\.bam | grep "^@RG"
samtools index $patient\_bam/$sample\.bam
# AB28_G
timepoint=G
sample=$patient\_$timepoint
samtools view $patient\_raw_bam/$sample\.bam -H > $patient\_raw_bam/$sample\.sam
sed 's/17334-15B/AB28_G/g' $patient\_raw_bam/$sample\.sam | sed 's/X17334_15B/AB28_G/g' > $patient\_raw_bam/$sample\.revised.sam
samtools reheader $patient\_raw_bam/$sample\.revised.sam $patient\_raw_bam/$sample\.bam > $patient\_bam/$sample\.bam
samtools view -H $patient\_bam/$sample\.bam | grep "^@RG"
samtools index $patient\_bam/$sample\.bam
