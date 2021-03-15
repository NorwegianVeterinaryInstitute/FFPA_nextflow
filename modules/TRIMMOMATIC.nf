process TRIM {

	      tag "$datasetID"

        input:
        tuple val(datasetID), file(R1), file(R2)

        output:
        file("*")
        tuple val(datasetID), path {"*val_1.fq.gz"}, path {"*val_2.fq.gz"}, emit: trim_reads

        script:
        """
        trimmomatic PE $R1 $R2 /tmp/output_forward_paired.fq.gz /tmp/output_forward_unpaired.fq.gz /tmp/output_reverse_paired.fq.gz /tmp/output_reverse_unpaired.fq.gz \
         ILLUMINACLIP:{}:2:30:10 LEADING:20 TRAILING:20 MINLEN:140".format(target_dir, jobid, illumina_name1, illumina_name2, trimmomatic_db)


         trimmomatic PE -threads $task.cpus -trimlog ${pair_id}_trimmed.log ${pair_id}*.gz \
    -baseout ${pair_id}_trimmed.fq.gz ILLUMINACLIP:${params.adapter_dir}/${params.adapters}:${params.illuminaClipOptions} \
    SLIDINGWINDOW:${params.slidingwindow} \
    LEADING:${params.leading} TRAILING:${params.trailing} \
    MINLEN:${params.minlen} &> ${pair_id}_run.log


    mv ${pair_id}_trimmed_1P.fq.gz ${pair_id}_R1.trimmed.fq.gz
    mv ${pair_id}_trimmed_2P.fq.gz ${pair_id}_R2.trimmed.fq.gz
    cat ${pair_id}_trimmed_1U.fq.gz ${pair_id}_trimmed_2U.fq.gz > ${pair_id}_S_concat_stripped_trimmed.fq.gz




        """
}
