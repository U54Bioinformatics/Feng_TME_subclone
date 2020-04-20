#outfile=FELINE.pyclone_mutation_num_sequenza.15_3_0.05_1_cnv4_yes.txt
#outfile=FELINE.pyclone_mutation_num_sequenza.15_3_0.05_1_cnv4.txt
#outfile=FELINE.pyclone_mutation_num_sequenza.15_3_0.05_2_cnv4.txt
#outfile=ABall.pyclone_mutation_num_sequenza.20_5_0.05_1_cnv4_yes.txt
outfile=ABall.pyclone_mutation_num_sequenza.20_5_0.05_1_cnv2_yes.txt
#outfile=FELINE.pyclone_mutation_num_sequenza.20_5_0.05_1_cnv4.txt
#outfile=FELINE.pyclone_mutation_num_sequenza.20_5_0.05_2_cnv4.txt
cat AB*_pyclone_mutation_sequenza/num_mutations.txt | head -n 1 > $outfile
cat AB*_pyclone_mutation_sequenza/num_mutations.txt | grep -v "Orig"  >> $outfile

#outfile=FELINE.pyclone_mutation_num_FACETS.15_3_0.05_1_cnv4_yes.txt
#outfile=FELINE.pyclone_mutation_num_FACETS.15_3_0.05_1_cnv4.txt
#outfile=FELINE.pyclone_mutation_num_FACETS.15_3_0.05_2_cnv4.txt
#outfile=FELINE.pyclone_mutation_num_FACETS.20_5_0.05_1_cnv4_yes.txt
#outfile=FELINE.pyclone_mutation_num_FACETS.20_5_0.05_1_cnv4.txt
#outfile=FELINE.pyclone_mutation_num_FACETS.20_5_0.05_2_cnv4.txt
#cat FEL0*_pyclone_mutation_FACETS/num_mutations.txt | head -n 1 > $outfile
#cat FEL0*_pyclone_mutation_FACETS/num_mutations.txt | grep -v "Orig"  >> $outfile

