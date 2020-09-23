ls *.clonevol_ccf.txt > FELINE_clonevol_ccf.list
ls *.clonevol_vaf.txt > FELINE_clonevol_vaf.list
analysis='ccf'

for ccf in `cat FELINE_clonevol_\$analysis\.list | grep -v "^#"`; do
    echo $ccf
    prefix=${ccf%.txt}
    a=($(echo $ccf | tr '_' "\n"))
    patient=$a
    #analysis='ccf'
    echo $prefix
    echo $patient
    echo $analysis
    #if [ $patient == 'FEL044' ];then
    if true ; then

        if [ $patient == 'AB33' ] || [ $patient == 'AB62' ]; then
            echo "A vs C"
            /home/jichen/software/BETSY/install/envs/DNA_analysis_cloevol/bin/Rscript FELINE_clonevol.R $prefix $patient\_A,$patient\_C $analysis 
        fi 
        if [ $patient == 'AB14' ]; then
            echo "A vs D"
            /home/jichen/software/BETSY/install/envs/DNA_analysis_cloevol/bin/Rscript FELINE_clonevol.R $prefix $patient\_A,$patient\_D $analysis
        fi
        if [ $patient == 'AB28' ]; then
            echo "A vs B"
            /home/jichen/software/BETSY/install/envs/DNA_analysis_cloevol/bin/Rscript FELINE_clonevol.R $prefix $patient\_A,$patient\_B $analysis
        fi
        if [ $patient == 'AB11' ]; then
            echo "A vs J"
            /home/jichen/software/BETSY/install/envs/DNA_analysis_cloevol/bin/Rscript FELINE_clonevol.R $prefix $patient\A,$patient\J $analysis
        fi

    fi
done

# collected figures
if [ $analysis == 'ccf' ]; then
   mkdir FELINE_clonevol_figures_ccf
   mv *.pdf FELINE_clonevol_figures_ccf/
fi

if [ $analysis == 'vaf' ]; then
   mkdir FELINE_clonevol_figures_vaf
   mv *.pdf FELINE_clonevol_figures_vaf/
fi
