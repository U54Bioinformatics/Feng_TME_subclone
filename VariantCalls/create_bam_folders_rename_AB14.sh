# AB14_A
patient=AB14
timepoint=A
sample=$patient\_$timepoint
#samtools view AB14_raw_bam/AB14_A.bam -H > AB14_raw_bam/AB14_A.sam
#sed 's/AB-14A/AB14_A/g' AB14_raw_bam/AB14_A.sam | sed 's/AB_14A/AB14_A/' > AB14_raw_bam/AB14_A.revised.sam
#samtools reheader AB14_raw_bam/AB14_A.revised.sam AB14_raw_bam/AB14_A.bam > AB14_bam/AB14_A.bam
samtools view -H $patient\_bam/$sample\.bam | grep "^@RG"
samtools index $patient\_bam/$sample\.bam
# AB14_D
timepoint=D
sample=$patient\_$timepoint
#samtools view AB14_raw_bam/AB14_D.bam -H > AB14_raw_bam/AB14_D.sam
#sed 's/AB-14D/AB14_D/g' AB14_raw_bam/AB14_D.sam | sed 's/AB_14D/AB14_D/' > AB14_raw_bam/AB14_D.revised.sam
#samtools reheader AB14_raw_bam/AB14_D.revised.sam AB14_raw_bam/AB14_D.bam > AB14_bam/AB14_D.bam
samtools view -H $patient\_bam/$sample\.bam | grep "^@RG"
samtools index $patient\_bam/$sample\.bam
# AB14_G
timepoint=G
sample=$patient\_$timepoint
#samtools view AB14_raw_bam/AB14_G.bam -H > AB14_raw_bam/AB14_G.sam
#sed 's/17-334-02B/AB14_G/g' AB14_raw_bam/AB14_G.sam | sed 's/X17_334_02B/AB14_G/' > AB14_raw_bam/AB14_G.revised.sam
#samtools reheader AB14_raw_bam/AB14_G.revised.sam AB14_raw_bam/AB14_G.bam > AB14_bam/AB14_G.bam
samtools view -H $patient\_bam/$sample\.bam | grep "^@RG"
samtools index $patient\_bam/$sample\.bam

