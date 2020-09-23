prefix=ABadd1
echo "get sequence for Get_seq.py"
python Get_seq.py --input $prefix\.mutation.list --output $prefix\.seq.fa

echo "run primer3 to design primers"
python Run_primer3.py --input $prefix\.seq.fa > $prefix\.mutation.primers.table.txt
cp primer3.infile $prefix\.primer3.infile
cp primer3.outfile $prefix\.primer3.outfile

echo "validate by isPCR"
cut -f2,6-7 $prefix\.mutation.primers.table.txt | grep -v "locus" > $prefix\.mutation.primers.table4isPCR.txt
./isPcr -out=bed /home/jichen/Projects/Database/Genomes/Broad.GRCh37/GRCh37/Homo_sapiens_assembly19.fasta $prefix\.mutation.primers.table4isPCR.txt $prefix\.mutation.primers.table4isPCR.out.bed

