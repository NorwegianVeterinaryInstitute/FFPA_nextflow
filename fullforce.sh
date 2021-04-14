#!/bin/bash

# This script is to make sure that the FFPA pipeline is run in a reproducible way
# to run the script list the following command:
#
# ./fullforce.sh main.config your_output_directory

script_directory=$(dirname ${BASH_SOURCE[0]})

config=$1
outdir=$2
workdir=${3:-$USERWORK/fullforce}

# creating folder to collect nextflow html output files
mkdir -p ${outdir}/nextflow_reports/

DATE=($(date "+%Y%m%d_%R"))
mkdir -p ${outdir}/config_files
cp ${script_directory}/main.nf ${outdir}/config_files
cp ${config} ${outdir}/config_files

nextflow run ${script_directory}/main.nf -c ${config} --out_dir=${outdir} -work-dir ${workdir} -profile singularity -resume -with-report $DATE.report.html

mv *.html ${outdir}/nextflow_reports/
