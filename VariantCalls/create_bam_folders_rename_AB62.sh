# AB62_A
patient=AB62
timepoint=A
sample=$patient\_$timepoint
samtools view $patient\_raw_bam/$sample\.bam -H > $patient\_raw_bam/$sample\.sam
sed 's/AB-62A/AB62_A/g' $patient\_raw_bam/$sample\.sam | sed 's/AB_62A/AB62_A/g' > $patient\_raw_bam/$sample\.revised.sam
samtools reheader $patient\_raw_bam/$sample\.revised.sam $patient\_raw_bam/$sample\.bam > $patient\_bam/$sample\.bam
samtools view -H $patient\_bam/$sample\.bam | grep "^@RG"
samtools index $patient\_bam/$sample\.bam
# AB62_C
timepoint=C
sample=$patient\_$timepoint
samtools view $patient\_raw_bam/$sample\.bam -H > $patient\_raw_bam/$sample\.sam
sed 's/AB-62C/AB62_C/g' $patient\_raw_bam/$sample\.sam | sed 's/AB_62C/AB62_C/g' > $patient\_raw_bam/$sample\.revised.sam
samtools reheader $patient\_raw_bam/$sample\.revised.sam $patient\_raw_bam/$sample\.bam > $patient\_bam/$sample\.bam
samtools view -H $patient\_bam/$sample\.bam | grep "^@RG"
samtools index $patient\_bam/$sample\.bam
# AB62_G
timepoint=G
sample=$patient\_$timepoint
samtools view $patient\_raw_bam/$sample\.bam -H > $patient\_raw_bam/$sample\.sam
sed 's/AB-62germ/AB62_G/g' $patient\_raw_bam/$sample\.sam | sed 's/AB_62germ/AB33_G/g' > $patient\_raw_bam/$sample\.revised.sam
samtools reheader $patient\_raw_bam/$sample\.revised.sam $patient\_raw_bam/$sample\.bam > $patient\_bam/$sample\.bam
samtools view -H $patient\_bam/$sample\.bam | grep "^@RG"
samtools index $patient\_bam/$sample\.bam
