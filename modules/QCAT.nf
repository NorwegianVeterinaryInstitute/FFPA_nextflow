process QCAT {
  // this process is to remove reads that are too short and it does demutliplexing using identified barcodes
  // the current version of qcat only uses the epi2me demultiplexing algorithm and that uses only one thread.
  // When it get's updated we might use more threads.
  // qcat is one

            publishDir "${params.out_dir}/01_qcat/", pattern: "*", mode: "copy"

            tag "$datasetID"

            input:
            tuple val(datasetID), file(longreads)

	          output:
            file("*")
            tuple val(datasetID), path {"*trimmed.fastq.gz"}, emit: filtered_longreads

	          path "*", emit: qcatfiltered_ch
	          file("*.log")
	          file("*.txt")

            script:
            """
            zcat *.fastq.gz > ${datasetID}.fastq

            echo processing ${datasetID}.fastq

            ##running qcat with default parameters

            qcat -t 1 -f ${datasetID}.fastq -o ${datasetID}.trimmed.fastq --tsv > qcat.${datasetID}.processing.log 2>stdout.log

            gzip ${datasetID}.trimmed.fastq > ${datasetID}.trimmed.fastq.gz

	"""
	// need to add a way to extract for each barcode the names of the reads and then put that in a list

}
