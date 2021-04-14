// this module runs unicycler.
// the first process will only use Nanopore data to generate a Nanopore ASSEMBLY
// the second process will use nanopore and illumina data to generate a hybrid ASSEMBLY
// the original container had a samtools version which was too old, stopping unicycler.
// replaced container with a sigularity image that has the same unicycler version but with a newer samtools version

process UNICYCLER_NP {
           //container = 'nanozoo/unicycler' // original container

           container = 'file:////cluster/projects/nn9305k/nextflow/singularity_img/unicycler_NVI_0.4.8.sif'

           label 'assembly'

           publishDir "${params.out_dir}/${datasetID}/nanopore_unicycler/", pattern: "*", mode: "copy"

           tag "$datasetID"

           input:
           tuple val(datasetID), file(reads)


           output:
           file("*")
           tuple val(datasetID), path {"*.fasta"}, emit: np_assemblies_ch

           script:
           """
           unicycler -l ${datasetID}.filter.fastq.gz -o .
           """
}



// the hybrid assembly process

process UNICYCLER_HYBRID {
          //container = 'nanozoo/unicycler' // original container

          container = 'file:////cluster/projects/nn9305k/nextflow/singularity_img/unicycler_NVI_0.4.8.sif'

          label 'assembly'

          publishDir "${params.out_dir}/${datasetID}/hybrid_unicycler/", pattern: "*", mode: "copy"

          tag "$datasetID"

          input:
          tuple val(datasetID), file(R1), file(R2), file(longreads)


          output:
          file("*")
          tuple val(datasetID), path {"*.fasta"}, emit: hyb_assemblies_ch

          script:
          """
          unicycler -1 $R1 -2 $R2 -l $longreads -o .
          """

}
