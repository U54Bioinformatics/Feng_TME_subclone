#!/opt/Python/2.7.3/bin/python
import sys
from collections import defaultdict
import numpy as np
import pandas as pd
import pandas
import re
import os
import argparse
import glob

def usage():
    test="name"
    message='''
python VCF_VAF.py --input ABall.vcf
    '''
    print message


def mergefiles(dfs=[], on=''):
    """Merge a list of files based on one column"""
    if len(dfs) == 1:
         return "List only have one element."

    elif len(dfs) == 2:
        df1 = dfs[0]
        df2 = dfs[1]
        df = df1.merge(df2, on=on)
        return df

    # Merge the first and second datafranes into new dataframe
    df1 = dfs[0]
    df2 = dfs[1]
    df = dfs[0].merge(dfs[1], on=on)

    # Create new list with merged dataframe
    dfl = []
    dfl.append(df)

    # Join lists
    dfl = dfl + dfs[2:] 
    dfm = mergefiles(dfl, on)
    return dfm

#CHROM  POS     ID      REF     ALT     QUAL    FILTER  INFO    FORMAT  AB-11A  AB-33A
def vaf_from_vcf_file(infile):
    data = defaultdict(lambda : str())
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2 and not line.startswith(r'##'):
                header = 1 if line.startswith(r'#') else 0
                unit = re.split(r'\t',line)
                chro = unit[0]
                pos  = unit[1]
                ref  = unit[3]
                alt  = unit[4]
                vafs = []
                for i in range(9,len(unit)):
                    if header == 1:
                        vaf = unit[i]
                        vafs.append(vaf)
                    elif unit[i] == "./.":
                        vaf = 0
                        vafs.append('0.0 (REF=0;ALT=0)')
                    else:
                        #0/1:6180,1575:7755:99:23267,0,217062
                        gt_list  = re.split(r':', unit[i])
                        dep_list = re.split(r',', gt_list[1])
                        vaf      = float(dep_list[1])/(float(dep_list[0])+float(dep_list[1]))
                        vafs.append('%0.2f (REF=%s;ALT=%s)' %(vaf, dep_list[0], dep_list[1]))
                print "%s\t%s\t%s\t%s\t%s" %(chro, pos, ref, alt, "\t".join(vafs))
            #elif line.startswith(r'#CHROM'):
            #    unit = re.split(r'\t',line)
            #    print "%s\t%s\t%s\t%s\t%s" %(unit[0], pos, ref, alt, "\t".join(vafs))
    return data

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input')
    parser.add_argument('-o', '--output')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()
    try:
        len(args.input) > 0
    except:
        usage()
        sys.exit(2)

    vaf_from_vcf_file(args.input)

if __name__ == '__main__':
    main()

