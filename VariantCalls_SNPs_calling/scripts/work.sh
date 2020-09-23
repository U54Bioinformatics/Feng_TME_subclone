
echo "somatic variant calling"
ln -s ../VariantCalls_bam/output/AB*_bam ./
sbatch --array 1-4 betsy_WGS_variants_FELINE.sh


