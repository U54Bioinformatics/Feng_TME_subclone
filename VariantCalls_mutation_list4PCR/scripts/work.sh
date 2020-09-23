##############Run comment below to reproduce results ######################################
echo "Prepare input files"
cp  ../VariantCalls_pyclone_clonevol/*.clonevol_vaf.txt ./
cp ../VariantCalls/*.common_snp_info.txt ./
cp ~/Projects/Breast/scRNA/97OVCZ/Alignment_Variants_WES/*.common_snp_info.txt ./

echo "merge mutation info"
## merge pyclone results with SNPs annotation and prepare a table for Feng to select PCR target
#input files are: ABall_patient_subclone.txt, *.clonevol_vaf.txt, *.common_snp_info.txt
#ABall_patient_subclone.txt contain subclonal clusters that Feng wants to track in experiments
#*.clonevol_vaf.txt contain variant allele freqency for each sample (Last two columns are VAF)
#*.common_snp_info.txt contain variant annotation
#Patient	Cluster
#AB11	2,4
#AB28	2,3,4
#AB33	2,3,4
#AB62	2,4
#output files are tables has all information for SNPs: *.mutations.txt
#Feng uses the *.mutations.txt to select 5 SNPs from each cluster for PCR primer design: *.mutations.final_5.list
python ABall_mutaiton_list4PCR.py

echo "verify the final mutation list to make sure SNPs in *.mutations.final_5.list are matched with that in *.mutations.txt"
python ABall_mutation_verify_final.py --mutation AB28.mutations.txt --input AB28.mutations.final_5.list | less -S
python ABall_mutation_verify_final.py --mutation AB33.mutations.txt --input AB33.mutations.final_5.list | less -S
python ABall_mutation_verify_final.py --mutation AB62.mutations.txt --input AB62.mutations.final_5.list | less -S
python ABall_mutation_verify_final.py --mutation AB11.mutations.txt --input AB11.mutations.final_5.list | less -S
