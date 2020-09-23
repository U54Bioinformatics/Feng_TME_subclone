#!/opt/Python/2.7.3/bin/python
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.SeqRecord import SeqRecord
import re
import sys
import os
import argparse

def usage():
    message='Python ChrName.py --input seq.fa --output primer3.infile'
    message='''
--input:
one or multi sequence fasta file, the head is format of right2:200-1153.
We extract right2 as sequence id and 200-1153 is the target fragment we want to amplify.
--ouput:
The resulting primer for reverse is ready to use. But if want to find sequence in the seq.fa, the primer need to reverse complement. You will not find the sequence if there is a \n there. 
'''
    print message

'''
SEQUENCE_ID=MADS50
PRIMER_LEFT_0_TM=59.825
PRIMER_RIGHT_0_TM=60.026
PRIMER_LEFT_0_SEQUENCE=AAAAGTGGGTAGTGTTGGCTCT
PRIMER_RIGHT_0_SEQUENCE=CTGCTCTTCTTCTTGTCCCCAT
PRIMER_PAIR_0_PRODUCT_SIZE=907
'''
def parse_primer3(infile):
    count = 0
    locus = ''
    size = ''
    leftm = ''
    rightm = ''
    primerF = ''
    primerR = '' 
    s = re.compile(r'\=(.*)')
    ifile = open (infile, 'r')
    for line in ifile:
        line = str(line.rstrip())
        #print line
        if line.startswith('SEQUENCE_ID'):
            m = s.search(line)
            if m:
                locus = m.groups(0)[0]
        elif line.startswith('PRIMER_LEFT_0_TM'):
            m = s.search(line)
            if m:
                leftm = m.groups(0)[0]
        elif line.startswith('PRIMER_RIGHT_0_TM'):
            m = s.search(line)
            if m:
                rightm = m.groups(0)[0]
        elif line.startswith('PRIMER_LEFT_0_SEQUENCE'):
            m = s.search(line)
            if m:
                primerF = m.groups(0)[0]
        elif line.startswith('PRIMER_RIGHT_0_SEQUENCE'):
            m = s.search(line)
            if m:
                primerR = m.groups(0)[0]
        elif line.startswith('PRIMER_PAIR_0_PRODUCT_SIZE'):
            m = s.search(line)
            if m:
                size = m.groups(0)[0]
        elif line.startswith('='):
            count += 1
            print '>%s %s %s %s %s' % (count, locus, size, leftm, rightm)
            print '%sF 5\'-3\': %s' % (locus, primerF)
            print '%sR 5\'-3\': %s' % (locus, primerR)
    ifile.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input')
    parser.add_argument('-o', '--output')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()
    try:
        len(args.input) > 1
    except:
        usage()
        sys.exit(2)
 
    if args.output is None:
        args.output = 'primer3.infile'

    ofile = open(args.output,"w")
    id  = ''
    seq = '' 
    start = 0
    end   = 0
    length= 0
    s = re.compile(r'(\w+)\:(\d+)\-(\d+)')
    for record in SeqIO.parse(args.input,"fasta"):
        temp  = str(record.id)
        m = s.search(temp)
        if m:
            id = m.groups(0)[0]
            start = m.groups(0)[1]
            end   = m.groups(0)[2]
            length  = str(int(end) - int(start) + 1)
            length2 = '80' if int(end) - int(start) < 80 else str(int(end) - int(start) + 1)   
        seq = str(record.seq.upper()).rstrip()
        
        cmd = 'SEQUENCE_ID='
        cmd += id
        cmd += '\nSEQUENCE_TEMPLATE='
        cmd += seq
        cmd += '''
SEQUENCE_TARGET=''' + str(start) + ''',''' + length + '''
PRIMER_TASK=generic
PRIMER_PICK_LEFT_PRIMER=1
PRIMER_PICK_INTERNAL_OLIGO=1
PRIMER_PICK_RIGHT_PRIMER=1
PRIMER_OPT_SIZE=22
PRIMER_MIN_SIZE=18
PRIMER_MAX_SIZE=24
PRIMER_MAX_NS_ACCEPTED=1
PRIMER_PRODUCT_SIZE_RANGE=''' + length2 + '''-200
P3_FILE_FLAG=1
SEQUENCE_INTERNAL_EXCLUDED_REGION=''' + str(start) + ''',''' + length + '''
PRIMER_EXPLAIN_FLAG=1
PRIMER_THERMODYNAMIC_PARAMETERS_PATH=/opt/primer3/2.3.5/src/primer3_config/
='''
        print >> ofile, cmd
    ofile.close()
   
    primer3 ='''
/opt/primer3/2.3.5/src/primer3_core < primer3.infile > primer3.outfile
''' 
    os.system(primer3)    
    parse_primer3('primer3.outfile')
