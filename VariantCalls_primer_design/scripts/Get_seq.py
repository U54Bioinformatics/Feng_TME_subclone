from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
from collections import defaultdict
import re
import sys
import os
import argparse

def usage():
    message='Python Get_seq.py --input mutation.list --output seq.fa'
    message+='''
get 200 flanking sequence for mutation and prepare for primer3
--input: mutation list
MADS50	Chr3	1298986	1299653
OsELF3	Chr6	2235191	2235191
OsFAD7	Chr3	10083203	10083257
37180	Chr2	22478977	22478979
50380	Chr5	28878789	28878791
3850a	Chr6	1550681	1550681
3850b	Chr6	1553603	1553603
'''
    print message

def readtable(infile):
    data = defaultdict(list)
    count = 0
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2:
                count += 1 
                unit = re.split(r'\t',line)
                if not data.has_key(unit[0]):
                    data[count] = unit
    return data


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input')
    parser.add_argument('-o', '--output')
    parser.add_argument('-f', '--flank')
    parser.add_argument('-r', '--reference')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()
    try:
        len(args.input) > 1
    except:
        usage()
        sys.exit(2)

    if args.output is None:
        args.output = 'seq.fa'
    if args.flank is None:  
        args.flank = 300
    if args.reference is None:
        args.reference = "/home/jichen/Projects/Database/Genomes/Broad.GRCh37/GRCh37/Homo_sapiens_assembly19.fasta"

    flank = int(args.flank)
    loci= readtable(args.input)
    ref = defaultdict(str)
    for record in SeqIO.parse(args.reference, "fasta"):
        ref[str(record.id)] = str(record.seq)
        #newrecord = SeqRecord(record.seq,id=chr,description="")
        #SeqIO.write(newrecord,ofile,"fasta")
    
    ofile = open(args.output,"w")
    for locus in sorted(loci, key=int):
        chrseq = ref[loci[locus][1]]
        end2 = int(loci[locus][3]) - int(loci[locus][2]) + 1 + int(flank) 
        target = chrseq[int(loci[locus][2])-int(flank):int(loci[locus][3])+int(flank)]
        newid  = loci[locus][0] + ':' + str(flank) + '-' + str(end2)
        print newid, target 
        newrecord = SeqRecord(Seq(target),id=newid,description="")
        SeqIO.write(newrecord,ofile,"fasta")
    ofile.close()

    
