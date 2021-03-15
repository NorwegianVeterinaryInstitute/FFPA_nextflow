// FullForcePlasmidAssembler

log.info """\
         FullForcePlasmidAssembler - NEXTFLOW  PIPELINE
         ===================================
         ILLUMINA - reads               : ${params.reads}
         NANOPORE - reads               : ${params.longreads}
         Output - directory             : ${params.out_dir}
         Temporary - directory          : ${workDir}
        --------------------------------- ---------------------------------
         kraken database                : NEEDS TO BE ADDED
         ANYTHING ELSE?
        --------------------------------- ---------------------------------

		 """

// Activate dsl2
nextflow.enable.dsl=2


// Workflows
workflow HYBRID_ASSEMBLY {

// Set channels
  Channel
          .fromFilePairs(params.reads, flat: true,  checkIfExists: true)
          .set { readfiles_ch }

  Channel
          .fromPath(params.longreads, checkIfExists: true)
          .map { file -> tuple(file.simpleName, file) }
          .set { longreads_ch }

  /*Channel
  *.value(params.kraken_db)
  *	.set { krakendb }
  *
  *Channel
  *.value(params.sequencer)
  *.set { seq_type }
  *
  *Channel
  *	.value(params.illumina_filtering)
  *	.set { filt_illu }
  */

// nanopore data qc
    QCAT(longreads_ch)
    NANOPLOT(QCAT.out.filtered_longreads)


		// illumina data qc
		//TRIM(readfiles_ch)
		//FASTQC(TRIM.out.trim_reads)


}

// selecting the correct workflow based on user choice defined in main.config.

workflow {
if (params.track == "hybrid") {

  // loading the required modules.
  include { QCAT } from "${params.module_dir}/QCAT.nf"
  include { NANOPLOT } from "${params.module_dir}/NANOPLOT.nf"
  //include { TRIM } from "${params.module_dir}/TRIMMOMATIC.nf"
  //include { FASTQC } from "${params.module_dir}/FASTQC.nf"

  HYBRID_ASSEMBLY()
	}

if (params.track == "nanopore") {
	NANOPORE_ASSEMBLY()
	}

if (params.track == "illumina") {
	ILLUMINA_ASSEMBLY()
	}
}




/*process NANOFILT_BASIC {
	/* this process is to split the output of qcat in as many processes as we have barcodes.
	* it then uses Nanofilt to process each barcoded sample seperatly
	* in the workflow this is indicated with the flatten operator.
	*

	conda "/cluster/projects/nn9305k/src/miniconda/envs/nanofilt"

	publishDir "${params.out_dir}/04_nanofilt_basic/", pattern: "*", mode: "copy"

	label 'tiny'

	input:
	file(x)

	output:
	tuple val(samplename), path('*.trimmed.fastq.gz'), emit: trimmed_ch

	script:
	samplename = x.toString() - ~/.fastq.gz$/
	"""
	ls -la
	gunzip -c $x | NanoFilt -q 7 -l 100 --headcrop 50 | gzip > ${samplename}.trimmed.fastq.gz

	"""
}
*/
