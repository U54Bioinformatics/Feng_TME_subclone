echo "Get the tool isPCR, which can test if the primer is valid"
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v385/isPcr

########################Run commends below to reproduce results###################################
echo "prepare mutation list for PCR primer design"
cp ../VariantCalls_mutation_list4PCR/output/AB*.mutations.final_5.list ./
#Additional SNPs that Feng choose
ABadd1.mutation.final_5.list
cat *.final_5.list | grep -v "Patient"| awk '{print $1"_C"$2"_"$3"_"int($4/1000000)"M\t"$3"\t"$4"\t"$4+1}' > ABall.mutation.list

echo "get flanking sequence of SNPs for primer3"
python Get_seq.py --input ABall.mutation.list --output ABall.mutation.seq.fa

echo "run primer3 to design primers"
python Run_primer3.py --input ABall.mutation.seq.fa > ABall.mutation.primers.table.txt

echo "add handles"
awk '{print $0"\tTCGTCGGCAGCGTCAGATGTGTATAAGAGACAG"$6"\tGTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG"$7}' ABall.mutation.primers.table.txt > ABall.mutation.primers.table_handles.txt

echo "validate by isPCR: test on primers before adding handles"
cut -f2,6-7 ABall.mutation.primers.table.txt | grep -v "primer" > ABall.mutation.primers.table4isPCR.txt
./isPcr -out=bed /home/jichen/Projects/Database/Genomes/Broad.GRCh37/GRCh37/Homo_sapiens_assembly19.fasta ABall.mutation.primers.table4isPCR.txt ABall.mutation.primers.table4isPCR.out.bed

echo "merge SNP annotation and primer sequence for Feng"
cat ABall.mutation.final_5.list | awk '{print $1"_C"$2"_"$3"_"int($4/1000000)"M\t"$0}'> ABall.mutation.final_5.loucs.list
cat ABall.mutation.primers.table_handles.R | R --slave
python ~/software/bin/txt2xlsx.py --input ABall.mutation.primers.table_handles.vaf.txt


