// this module runs trimmomatic on ILLUMINA datasets

process TRIM {
          //container = 'docker://thhaverk/trimmomatic'
          container = 'file:////cluster/projects/nn9305k/nextflow/singularity_img/trimmomatic_NVI_0.38.sif'

          label 'tiny'

          publishDir "${params.out_dir}/${datasetID}/trimmomatic/", pattern: "*", mode: "copy"

          tag "$datasetID"

          input:

          tuple val(datasetID), file(R1), file(R2)

          output:
          file("*")
          tuple val(datasetID), path {"${datasetID}.trimmed.R1.fq.gz"}, path {"${datasetID}.trimmed.R2.fq.gz"}, emit: trim_reads_ch

          script:
          """

          trimmomatic PE -threads $task.cpus -trimlog ${datasetID}.trim.log \
            $R1 $R2 -baseout ${datasetID}.trimmed.fq.gz \
            ILLUMINACLIP:${params.adapter_dir}/${params.adapters}:2:30:10 \
            LEADING:3 TRAILING:3 \
            SLIDINGWINDOW:4:15 MINLEN:36 &> ${datasetID}.run.log

          mv ${datasetID}.trimmed_1P.fq.gz ${datasetID}.trimmed.R1.fq.gz
          mv ${datasetID}.trimmed_2P.fq.gz ${datasetID}.trimmed.R2.fq.gz
          cat ${datasetID}.trimmed_1U.fq.gz ${datasetID}.trimmed_2U.fq.gz > ${datasetID}_S_concat_stripped_trimmed.fq.gz

          rm -r ${datasetID}.trimmed_*U.fq.gz

          """
}
