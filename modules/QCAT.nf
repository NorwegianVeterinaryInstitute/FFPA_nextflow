process QCAT {
  // this process is to remove reads that are too short in datasets that have already been demultiplexed.
  // Qcat still identifies barcoded reads, but will not use that information.
  // the current version of qcat only uses the epi2me demultiplexing algorithm and that uses only one thread.
  // When it get's updated we might use more threads.

            container = 'docker://mcfonsecalab/qcat'
            label 'small'

            publishDir "${params.out_dir}/${datasetID}/qcat/", pattern: "*", mode: "copy"

            tag "$datasetID"

            input:
            tuple val(datasetID), file(reads)

	          output:
            file("*")
            tuple val(datasetID), path {"*trimmed.fastq.gz"}, emit: trimmed_longreads_ch

	          path "*", emit: qcatfiltered_ch
	          file("*.log")

            script:
            """

            echo processing ${datasetID}.fastq.gz

            ##running qcat with default parameters

            gunzip -f ${datasetID}.fastq.gz
            qcat -f ${datasetID}.fastq  -o ${datasetID}.trimmed.fastq 2>${datasetID}.stdout.log

            gzip ${datasetID}.trimmed.fastq

            #clean-up Folder
            rm -r ${datasetID}.fastq

	"""
	// need to add a way to extract for each barcode the names of the reads and then put that in a list

}
