mkdir ABall_bam
bam=/home/jichen/Projects/Breast/scRNA/Feng/VariantCalls_bam/output
ln -s $bam/AB14_bam/AB*_* ./ABall_bam
ln -s $bam/AB28_bam/AB*_* ./ABall_bam
ln -s $bam/AB33_bam/AB*_* ./ABall_bam
ln -s $bam/AB62_bam/AB*_* ./ABall_bam
cat AB*_normal_cancer.txt > ABall_normal_cancer.txt
cat AB*_sample.txt > ABall_sample.txt

