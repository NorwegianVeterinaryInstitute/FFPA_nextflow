// this module runs kraken on either nanopore or illumina datasets.

process KRAKENNP {
          //container = 'docker://flowcraft/kraken'  # this was the original docker. Not used because the size was too large.
          
          container = 'file:////cluster/projects/nn9305k/nextflow/singularity_img/kraken_NVI_1.1.1.sif'

          //containerOptions '--volume ${params.kraken1.dir}' MAYBE REMOVE

          label 'tiny'

          publishDir "${params.out_dir}/kraken/${datasetID}/", pattern: "*", mode: "copy"

          tag "$datasetID"

          input:
          tuple val(datasetID), file(reads)


          output:
          file("*")

          script:
          """

          kraken -db ${params.kraken1.dir}/${params.kraken1.db} \
          --threads $task.cpus \
          --fastq-input \
          --gzip-compressed \
          --output ${datasetID}.kr1.nanopore.out \
          ${datasetID}.filter.fastq.gz

          kraken-report --db ${params.kraken1.dir}/${params.kraken1.db} ${datasetID}.kr1.nanopore.out  > ${datasetID}.kraken_report_nanopore.txt

          #compressing the *.out file
          gzip -9 *.out

          #checking the files left
          ls -la

          """

}

process KRAKENIL {
          //container = 'docker://thhaverk/trimmomatic'
          //container = 'file:////cluster/projects/nn9305k/nextflow/singularity_img/trimmomatic_NVI_0.38.sif'
          container = 'file:////cluster/projects/nn9305k/nextflow/singularity_img/kraken_NVI_1.1.1.sif'

          //containerOptions '--volume ${params.kraken1.dir}' MAYBE REMOVE

          label 'tiny'

          publishDir "${params.out_dir}/kraken/${datasetID}/", pattern: "*", mode: "copy"

          tag "$datasetID"

          input:
          tuple val(datasetID), file(R1), file(R2)


          output:
          file("*")

          script:
          """

          kraken -db ${params.kraken1.dir}/${params.kraken1.db} \
          --threads $task.cpus \
          --fastq-input \
          --gzip-compressed \
          --output ${datasetID}.kr1.illumina.out \
          $R1 $R2

          kraken-report --db ${params.kraken1.dir}/${params.kraken1.db} ${datasetID}.kr1.illumina.out  > ${datasetID}.kraken_report_illumina.txt

          #compressing the *.out file
          gzip -9 *.out

          #checking the files left
          ls -la

          """

}
