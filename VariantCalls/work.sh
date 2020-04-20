#> > FT-SA56673,AB-14A,TGCCAGAA,ACGTTCCA,9YOIYX,FT-SA56681,17-334-02B
> > FT-SA56675,AB-28A,TCGAGGGA,ACGTTCCA,RX5022,FT-SA43219,17334-15A
> > FT-SA56676,AB-28B,ACTAGGAA,ACGTTCCA,RX5022,FT-SA43219,17334-15A
> > FT-SA56677,AB-33A,CATAGGGA,ACGTTCCA,BY1146,FT-SA56683,17334-16A
> > FT-SA56678,AB-33C,TACAGGAA,ACGTTCCA,BY1146,FT-SA56683,17334-16A
> > FT-SA56674,AB-14D,CATCAGAA,ACGTTCCA,9YOIYX,FT-SA56681,17-334-02B
> > FT-SA56679,AB-62A,TCGCTCGA,ACGTTCCA,IU3716,FT-SA56684,AB-62germ
> > FT-SA56682,17334-15B,CCTCTTGA,ACGTTCCA,RX5022,,
> > FT-SA56683,17334-16A,CACCTCGA,ACGTTCCA,BY1146,,
> > FT-SA56684,AB-62germ,CGCCTTAA,ACGTTCCA,IU3716,,
> > FT-SA56681,17-334-02B,AGGCTCAA,ACGTTCCA,9YOIYX,,
> > FT-SA56680,AB-62C,AAGCTTGA,ACGTTCCA,IU3716,FT-SA56684,AB-62germ

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

echo "somatic variant filter and subclone"
ln -s ABall_cnv_sequenza AB14_cnv_sequenza
ln -s ABall_cnv_sequenza AB28_cnv_sequenza
ln -s ABall_cnv_sequenza AB33_cnv_sequenza
ln -s ABall_cnv_sequenza AB62_cnv_sequenza
sbatch --array 1-4 betsy_WGS_pyclone.sh
bash run_pyclone_mutation_num.sh


echo "somatic tumor burden"
sbatch --array 1-4 betsy_WGS_tumor_burden_FELINE.sh
cat AB*_tumor_burden.txt/tumor_mutation_burden.txt > Feng_patient_tumor_burden.txt
python ~/software/bin/txt2xlsx.py --input Feng_patient_tumor_burden.txt

echo "somatic variant count"
python Prepare_somatic_variant_count_variant.py --input Feng_patients.list --RD 25 --minread 5 --minVAF 0.05 --mincaller 2 > Feng_patient_variant_count_25_5_0.05_2.txt

echo "germline variant calling"
sbatch --array 1-4 betsy_WGS_germline_variants_FELINE.sh
# run all sample in one folder. so we can check tumor-normal pairs with batsy
sbatch --array 1 betsy_WGS_germline_variants_FELINE.sh

echo "confirm tumor-normal pairs"
# use all sample run
sbatch --array 1 betsy_WGS_tumor_normal_pair_FELINE.sh

echo 
head -n 3 AB28_germline_calls/mutations.txt | cut -f1-4,16-23,25-27 > AB28_germline_driver.txt 
grep "TP53" AB28_germline_calls/mutations.txt | grep "exonic" | cut -f1-4,16-23,25-27 >> AB28_germline_driver.txt
grep "BRCA" AB28_germline_calls/mutations.txt | grep "exonic"| grep "nonsyn" | cut -f1-4,16-23,25-27 >> AB28_germline_driver.txt
python ~/software/bin/txt2xlsx.py --input AB28_germline_driver.txt
echo "annotate clinical outcomes"
zcat ~/Projects/Database/Clinvar/clinvar.vcf.gz| grep "#CHROM" > AB28_germline_driver.clinvar.txt
zcat ~/Projects/Database/Clinvar/clinvar.vcf.gz| grep "41226387" >> AB28_germline_driver.clinvar.txt
python ~/software/bin/txt2xlsx.py --input AB28_germline_driver.clinvar.txt


echo "FACETS CNA calling"
sbatch betsy_WGS_CNA_FACETS_FELINE_step1.sh
sbatch betsy_WGS_CNA_FACETS_FELINE_step2.sh

echo "Sequenza CNA calling"
sbatch betsy_WGS_CNA_Sequenza_FELINE_step1.sh
sbatch betsy_WGS_CNA_Sequenza_FELINE_step2.sh

