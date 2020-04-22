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
python CircosConf.py --input circos.config --output pipe.conf
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

def readtable(infile):
    data = defaultdict(str)
    with open (infile, 'r') as filehd:
        for line in filehd:
            line = line.rstrip()
            if len(line) > 2:
                unit = re.split(r'\t',line)
                if not data.has_key(unit[0]):
                    data[unit[0]] = unit[1]
    return data

#mutation        cluster gene    effect  is.driver       AB62_A.ccf      AB62_C.ccf      AB62_A  AB62_C
#10_111625181    2       XPNPEP1 0       FALSE   7.57    34.56   1.56    8.00
#10_124895782    2       HMX3    0       FALSE   7.57    34.56   0.00    6.06
def read_mutation_vaf(infile):
    data = defaultdict(lambda : defaultdict(lambda : list()))
    file_df = pd.read_table(infile, header=0)
    for i in range(file_df.shape[0]):
        #print file_df[0][i]
        data[str(file_df['cluster'][i])][file_df['mutation'][i]] = [x for x in file_df.iloc[i,:]]
    return data, file_df.columns


#Chrom   Pos     Ref     Alt     AB62_A  AB62_C  Func.refGene    Gene.refGene    GeneDetail.refGene
#1       1182161 C       CTCT    84/0/0.000      105/0/0.000                                             
#1       2537110 G       T       81/0/0.000      85/5/0.054      intronic        MMEL1                           
def read_mutation_anno(infile):
    data = defaultdict(lambda : list())
    file_df = pd.read_table(infile, header=0)
    for i in range(file_df.shape[0]):
        #print file_df[0][i]
        mutation = '%s_%s' %(file_df['Chrom'][i], file_df['Pos'][i])
        data[mutation] = [x for x in file_df.iloc[i, :]]
    return data, file_df.columns



#Patient Cluster
def read_patient_cluster(infile):
    data = defaultdict(lambda : list())
    file_df = pd.read_table(infile, header=0)
    for i in range(file_df.shape[0]):
        #print file_df[0][i]
        data[file_df['Patient'][i]] = re.split(r',', file_df['Cluster'][i])
    return data

def read_large_matrix(infile):
    # determine and optimize dtype
    # Sample 100 rows of data to determine dtypes.
    file_test = pd.read_csv(infile, sep="\t", header=0, nrows=100)
    float_cols = [c for c in file_test if file_test[c].dtype == "float64"]
    int_cols = [c for c in file_test if file_test[c].dtype == "int64"]
    if float_cols > 0:
        dtype_cols = {c: np.float32 for c in float_cols}
    elif int_cols > 0:
        dtype_cols = {c: np.int32 for c in int_cols}
    file_df = pd.read_csv(infile, sep="\t", header=0, dtype=dtype_cols)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('-i', '--input')
    parser.add_argument('-o', '--output')
    parser.add_argument('-v', dest='verbose', action='store_true')
    args = parser.parse_args()

    subclone_file = 'ABall_patient_subclone.txt'
    patient_clusters = read_patient_cluster(subclone_file) 
   
    for patient in sorted(patient_clusters.keys()):
        outfile = '%s.mutations.txt' %(patient)
        ofile   = open(outfile, 'w')
        #print patient, patient_clusters[patient]
        mutation_anno_file = glob.glob('%s_*.common_snp_info.txt' %(patient))[0] 
        mutation_vaf_file  = glob.glob('%s_*.clonevol_vaf.txt' %(patient))[0]
        #print mutation_vaf_file, mutation_anno_file
        mutation_anno, anno_header = read_mutation_anno(mutation_anno_file)
        mutation_vaf,vaf_header    = read_mutation_vaf(mutation_vaf_file)
        print >> ofile, 'Patient\tcluster\tmutation\t%s\t%s' %('\t'.join(anno_header), '\t'.join(vaf_header)) 
        for cluster in patient_clusters[patient]:
            if mutation_vaf.has_key(str(cluster)):
                for mutation in sorted(mutation_vaf[str(cluster)].keys()):
                    if mutation_anno.has_key(mutation):
                        print >> ofile, '%s\t%s\t%s\t%s\t%s' %(patient, cluster, mutation, '\t'.join(map(str, mutation_anno[mutation])), '\t'.join(map(str, mutation_vaf[str(cluster)][mutation])))
        ofile.close()            

if __name__ == '__main__':
    main()

