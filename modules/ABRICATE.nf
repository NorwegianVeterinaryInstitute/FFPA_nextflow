// this module runs abricate plasmidfinder or abricate with resfinder


  process ABRICATE_PLASMID_NP {
          container = 'replikation/abricate' // container from original pipeline.

          label 'tiny'

          publishDir "${params.out_dir}/${datasetID}/nanopore_abricate_plasmid/", pattern: "*", mode: "copy"

          tag "$datasetID"

          input:
          tuple val(datasetID), file(assembly)


          output:
          file("*")

          script:
          """
          abricate --db plasmidfinder ${assembly} > ${datasetID}.nanopore.plasmidfinder
          """
}

process ABRICATE_RESFINDER_NP {
        container = 'replikation/abricate' // container from original pipeline.

        label 'tiny'

        publishDir "${params.out_dir}/${datasetID}/nanopore_abricate_resfinder/", pattern: "*", mode: "copy"

        tag "$datasetID"

        input:
        tuple val(datasetID), file(assembly)


        output:
        file("*")

        script:
        """
        abricate --db resfinder ${assembly} > ${datasetID}.nanopore.resfinder
        """
}

// processes for hybrid np_assemblies_ch

process ABRICATE_PLASMID_HYB {
        container = 'replikation/abricate' // container from original pipeline.

        label 'tiny'

        publishDir "${params.out_dir}/${datasetID}/hybrid_abricate_plasmid/", pattern: "*", mode: "copy"

        tag "$datasetID"

        input:
        tuple val(datasetID), file(assembly)


        output:
        file("*")

        script:
        """
        abricate --db plasmidfinder ${assembly} > ${datasetID}.hybrid.plasmidfinder
        """
}

process ABRICATE_RESFINDER_HYB {
        container = 'replikation/abricate' // container from original pipeline.

        label 'tiny'

        publishDir "${params.out_dir}/${datasetID}/Hybrid_abricate_resfinder/", pattern: "*", mode: "copy"

        tag "$datasetID"

        input:
        tuple val(datasetID), file(assembly)


        output:
        file("*")

        script:
        """
        abricate --db resfinder ${assembly} > ${datasetID}.hybrid.resfinder
        """
}
