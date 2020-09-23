
echo "prepare bam folders, sample files"
bash ABall_bam.sh

echo "FACETS CNA calling"
sbatch betsy_WGS_CNA_FACETS_FELINE_step1.sh
sbatch betsy_WGS_CNA_FACETS_FELINE_step2.sh

echo "Sequenza CNA calling"
sbatch betsy_WGS_CNA_Sequenza_FELINE_step1.sh
sbatch betsy_WGS_CNA_Sequenza_FELINE_step2.sh

