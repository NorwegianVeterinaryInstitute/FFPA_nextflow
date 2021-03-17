//Nanoplot settings for the raw data when using the amplicon pipeline
// This will show reads with a max length of 3000 bp, longer sequences are likely not correct for amplicon sequencing.

process NANOPLOT {
            container = 'docker://nanozoo/nanoplot:1.32.0--1ae6f5d'

            publishDir "${params.out_dir}/nanoplot_longreads/", pattern: "*", mode: "copy"

            tag "$datasetID"

            input:
            tuple val(datasetID), file(reads)

            output:
            file("*")

            script:
            """

            NanoPlot -t 4 --fastq ${datasetID}.trimmed.fastq.gz  --plots hex dot --title ${datasetID}.summary -o ${datasetID}.summary-plots-log-transformed --N50

            """

}
