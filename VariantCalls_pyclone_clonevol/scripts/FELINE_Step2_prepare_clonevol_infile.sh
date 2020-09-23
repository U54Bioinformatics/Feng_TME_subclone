for indir in `cat FELINE_clonevol_prepare_table.list`; do
    a=($(echo $indir | tr '_' "\n"))
    patient=$a
    echo $patient
    #if [ $patient == 'FEL025' ];then
    if true ; then
        echo $indir
        python FELINE_clonevol_prepare_table.py --pyclone_dir $indir --driver Cancer_genes.ID.list --effect $patient\_variant_calls_04_purity40_totalRD20_minread5_minVAF0.05.common_snp_info.txt
    fi
done
