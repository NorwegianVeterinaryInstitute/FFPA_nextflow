process QCAT {
  // this process is to remove reads that are too short and it does demutliplexing using identified barcodes
  // the current version of qcat only uses the epi2me demultiplexing algorithm and that uses only one thread.
  // When it get's updated we might use more threads.
  // qcat is one
            container = 'docker://mcfonsecalab/qcat'
            label 'small'

            publishDir "${params.out_dir}/01_qcat/", pattern: "*", mode: "copy"

            tag "$datasetID"

            input:
            tuple val(datasetID), file(reads)

	          output:
            file("*")
            tuple val(datasetID), path {"*trimmed.fastq.gz"}, emit: filtered_longreads

	          path "*", emit: qcatfiltered_ch
	          file("*.log")

            script:
            """

            echo processing ${datasetID}.fastq.gz

            ##running qcat with default parameters

            zcat ${datasetID}.fastq.gz | qcat -t 1  -o ${datasetID}.trimmed.fastq --tsv > qcat.${datasetID}.processing.log 2>stdout.log

            gzip ${datasetID}.trimmed.fastq

	"""
	// need to add a way to extract for each barcode the names of the reads and then put that in a list

}
