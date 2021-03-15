//Nanoplot settings for the raw data when using the amplicon pipeline
// This will show reads with a max length of 3000 bp, longer sequences are likely not correct for amplicon sequencing.

process NANOPLOT {
            publishDir "${params.out_dir}/02_nanoplot_amplicon/", pattern: "*", mode: "copy"

            tag "$datasetID"

            input:
            tuple val(datasetID), file(*)

            output:
            path "*.summary-plots-log-transformed"

            script:
            """

            NanoPlot -t 4 --fastq_minimal barcode*.gz  --maxlength 3000 --plots hex dot --title Clean_data_Summary -o Clean_data.summary-plots-log-transformed

            """
            
}
