//NanoFilt settings for the data processed by qcat when using the amplicon pipeline
// This will show reads with a max length of 3000 bp, longer sequences are likely not correct for amplicon sequencing.

process NANOFILT {
            container = 'docker://mcfonsecalab/nanofilt'
            label 'small'

            publishDir "${params.out_dir}/nanofilt/${datasetID}/", pattern: "*", mode: "copy"

            tag "$datasetID"

            input:
            tuple val(datasetID), file(reads)

            output:
            file("*")
            tuple val(datasetID), path {"*.filter.fastq.gz"}, emit: filtered_longreads_ch

            script:

          	"""
          	ls -la
          	gunzip -c ${datasetID}.trimmed.fastq.gz | NanoFilt -q 7 -l 100  | gzip > ${datasetID}.filter.fastq.gz

          	"""

}
