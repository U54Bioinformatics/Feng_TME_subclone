

echo "somatic variant filter and subclone"
ln -s ../VariantCalls_CNV/output/ABall_cnv_sequenza ./
cp ../VariantCalls_SNPs_calling/output/AB*_variant_calls ./
ln -s ABall_cnv_sequenza AB14_cnv_sequenza
ln -s ABall_cnv_sequenza AB28_cnv_sequenza
ln -s ABall_cnv_sequenza AB33_cnv_sequenza
ln -s ABall_cnv_sequenza AB62_cnv_sequenza
sbatch --array 1-4 betsy_WGS_pyclone.sh

