cp ../../FELINE/FELINE_merged_011_040_premrna/VariantCalls_SNPs_test/betsy_WGS_variants_FELINE.sh ./
cp ../FELINE/FELINE_merged_011_040_premrna/VariantCalls_SNPs_test/FEL022_sample.txt ./
cp ../FELINE/FELINE_merged_011_040_premrna/VariantCalls_SNPs_test/FEL022_normal_cancer.txt ./
cp ../../FELINE/FELINE_merged_011_040_premrna/VariantCalls_SNPs_test/FELINE_patients.list ./

echo "create bam folder and sample/normal-cancer table"
bash create_bam_folders.sh

echo "fix sample id in bam because Betsy is strict about this"
bash create_bam_folders_rename_AB14.sh
bash create_bam_folders_rename_AB28.sh
bash create_bam_folders_rename_AB33.sh
bash create_bam_folders_rename_AB62.sh
ls AB*_bam/AB*.ba* | grep -v "raw"

echo "somatic variant calling"
sbatch --array 2 betsy_WGS_variants_FELINE.sh
sbatch --array 1,3-4 betsy_WGS_variants_FELINE.sh

echo "germline variant calling"
sbatch --array 2 betsy_WGS_germline_variants_FELINE.sh

