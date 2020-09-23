echo "Preprae scripts"
cp ~/Projects/Breast/scRNA/FELINE/FELINE_merged_011_040_premrna/VariantCalls_pyclone_clonevol/FELINE_Step1_cp_results_folder.sh ./
cp ~/Projects/Breast/scRNA/FELINE/FELINE_merged_011_040_premrna/VariantCalls_pyclone_clonevol/FELINE_Step2_prepare_clonevol_infile.sh ./
cp ~/Projects/Breast/scRNA/FELINE/FELINE_merged_011_040_premrna/VariantCalls_pyclone_clonevol/FELINE_Step3_run_clonevol.sh ./
cp ~/Projects/Breast/scRNA/FELINE/FELINE_merged_011_040_premrna/VariantCalls_pyclone_clonevol/Cancer_genes.* ./
cp ~/Projects/Breast/scRNA/FELINE/FELINE_merged_011_040_premrna/VariantCalls_pyclone_clonevol/*.py ./
cp ~/Projects/Breast/scRNA/FELINE/FELINE_merged_011_040_premrna/VariantCalls_pyclone_clonevol/FELINE_clonevol.R ./
cp ../VariantCalls/AB*_variant_calls_04_purity40_totalRD20_minread5_minVAF0.05.common_snp_info.txt ./
cp /home/jichen/Projects/Breast/scRNA/97OVCZ/Alignment_Variants_WES/97OVCZ_variant_calls_04_purity40_totalRD20_minread5_minVAF0.05.common_snp_info.txt AB11_variant_calls_04_purity40_totalRD20_minread5_minVAF0.05.common_snp_info.txt

##############################Run command below to reproduce the results#########
echo "cp pyclone best model folder (based on sequenza cnv)"
bash FELINE_Step1_cp_results_folder.sh

echo "prepare infile for clonevol"
ls -d AB*_pyclone_analysis_sequenza_* | grep -v ".txt" > FELINE_clonevol_prepare_table.list
bash FELINE_Step2_prepare_clonevol_infile.sh

echo "run clonevol for all patients"
bash FELINE_Step3_run_clonevol.sh
