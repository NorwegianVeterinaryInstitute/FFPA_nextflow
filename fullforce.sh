#!/bin/bash

# This script is to make sure that the FFPA pipeline is run in a reproducible way
# to run the script list the following command:
#
# ./fullforce.sh main.config location_of_illumina_reads location_of_nanopore_reads your_output_directory

script_directory=$(dirname ${BASH_SOURCE[0]})

config=$1
params.illumina=$2
params.nanopore=$3
outdir=$4
workdir=${5:-$USERWORK/fullforce}

DATE=($(date "+%Y%m%d_%R"))
mkdir -p ${outdir}/config_files
cp ${script_directory}/main.nf ${outdir}/config_files
cp ${config} ${outdir}/config_files

nextflow run ${script_directory}/main.nf -c ${config} --out_dir=${outdir} -work-dir ${workdir} -profile slurm,singularity -resume -with-report $DATE.report.html
