cp ../VariantCalls_mutation_list4PCR/AB*.mutations.final_5.list ./
echo "prepare mutation list for Get_seq.py"
cat *.final_5.list | grep -v "Patient"| awk '{print $1"_C"$2"_"$3"_"int($4/1000000)"M\t"$3"\t"$4"\t"$4+1}' > ABall.mutation.list
head ABall.mutation.list > test.mutation.list

echo "isPCR"
wget http://hgdownload.soe.ucsc.edu/admin/exe/linux.x86_64.v385/isPcr


echo "get sequence for Get_seq.py"
python Get_seq.py --input ABall.mutation.list --output seq.fa
python Get_seq.py --input ABadd1.mutation.list --output seq.fa

echo "run primer3 to design primers"
#python Run_primer3.py --input seq.fa > ABall.mutation.primers.txt
python Run_primer3.py --input seq.fa > ABall.mutation.primers.table.txt
python Run_primer3.py --input seq.fa > ABadd1.mutation.primers.table.txt

echo "add handles"
awk '{print $0"\tTCGTCGGCAGCGTCAGATGTGTATAAGAGACAG"$6"\tGTCTCGTGGGCTCGGAGATGTGTATAAGAGACAG"$7}' ABall.mutation.primers.table.txt > ABall.mutation.primers.table_handles.txt

echo "validate by isPCR"
cut -f2,6-7 ABall.mutation.primers.table.txt > ABall.mutation.primers.table4isPCR.txt
cut -f2,8-9 ABall.mutation.primers.table_handles.txt > ABall.mutation.primers.table_handles4isPCR.txt
cut -f2,6-7 ABadd1.mutation.primers.table.txt > ABadd1.mutation.primers.table4isPCR.txt

#./isPcr /home/jichen/Projects/Database/Genomes/Broad.GRCh37/GRCh37/Homo_sapiens_assembly19.fasta ABall.mutation.primers.table.txt ABall.mutation.primers.table.isPCR.out
./isPcr -out=bed /home/jichen/Projects/Database/Genomes/Broad.GRCh37/GRCh37/Homo_sapiens_assembly19.fasta ABall.mutation.primers.table4isPCR.txt ABall.mutation.primers.table4isPCR.out.bed
./isPcr -out=bed /home/jichen/Projects/Database/Genomes/Broad.GRCh37/GRCh37/Homo_sapiens_assembly19.fasta ABall.mutation.primers.table_handles4isPCR.txt ABall.mutation.primers.table_handles4isPCR.out.bed
./isPcr -out=bed /home/jichen/Projects/Database/Genomes/Broad.GRCh37/GRCh37/Homo_sapiens_assembly19.fasta ABadd1.mutation.primers.table4isPCR.txt ABadd1.mutation.primers.table4isPCR.out.bed
#or
sbatch Run_isPCR.sh


echo "add new primers"
cat ABadd1.mutation.final_5.list | awk '{print $1"_C"$2"_"$3"_"int($4/1000000)"M\t"$3"\t"$4"\t"$4+1}' > ABadd1.mutation.list


echo "merge info"
cat ABall.mutation.final_5.list | awk '{print $1"_C"$2"_"$3"_"int($4/1000000)"M\t"$0}'> ABall.mutation.final_5.loucs.list
cat ABall.mutation.primers.table_handles.R | R --slave
python ~/software/bin/txt2xlsx.py --input ABall.mutation.primers.table_handles.vaf.txt


