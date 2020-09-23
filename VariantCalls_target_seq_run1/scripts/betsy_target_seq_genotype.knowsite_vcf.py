#!/opt/Python/2.7.3/bin/python
import sys
from collections import defaultdict
import numpy as np
import re
import os
import argparse
import pandas as pd

def usage():
    test="name"
    message='''
Extract somatic mutations from BETSY variant calls and save filtered variants in VCF

python Variant_calls_filtered_vcf.py --input 97OVCZ_variant_calls

    '''
    print message

#Chrom   Pos     Ref     Alt
#12      115109868       C       T
#19      9065468 G       C
#18      55021680        C       T
def variant_vcf(infile, outfile_vcf):
    data = defaultdict(str)
    linen = 0
    header= ''
    chro = map(str, range(1,23))
    chro.append("X")
    chro.append("Y")
    ofile = open(outfile_vcf, 'a')
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            linen += 1
            if linen >= 2:
                #print line
                unit = re.split(r'\t', line)
                chrom = '%s' %(unit[2])
                pos   = unit[3]
                ref   = unit[4]
                alt   = unit[5]
                sample_gt = "0/1:170,73:250:99:1845,0,5404"
                if len(ref) == 1 and len(alt) == 1:
                    print >> ofile, '%s\t%s\t.\t%s\t%s\t200\tPASS\tAB=0\tGT:DP:AD:AF\t%s' %(chrom, pos, ref, alt, sample_gt)
            elif linen == 1:
                unit = re.split(r'\t', line)
                print >> ofile, '#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t%s' %("AB")
    ofile.close()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input')
    parser.add_argument('--vcf_header')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()
    try:
        len(args.input) > 0
    except:
        usage()
        sys.exit(2)

    if not args.vcf_header:
        args.vcf_header = 'vcf_header.vcf'


    # output filename: orig header, raw/unfilter, filter, vcf
    outfile_vcf     = '%s.vcf' %(args.input)
    s = re.compile(r'.txt$')
    if s.search(args.input):
        outfile_vcf = re.sub(r'.txt', r'.vcf', args.input)

    # test if VCF header exists and make a copy as header of output VCF file
    if not os.path.exists(args.vcf_header):
        print 'VCF header file does not exist: %s' %(args.vcf_header)
    else:
        os.system('cp %s %s' %(args.vcf_header, outfile_vcf))
    
    # output a VCF file
    variant_vcf(args.input, outfile_vcf)

if __name__ == '__main__':
    main()

