process CHECK_FILE_VALIDITY_WES_MULTISAMPLE {

    container 'jxprismdocker/bcftoolssh'
    publishDir "$params.publishdir/workflow_status", mode: 'copy'

    input:
    file doc_samplesummary
    file filtered_tsv
    file decompose_normalized_vcf
    file verifybamid
    file bamqc_stats
    file check_file_status_script
    file tabulate_samples_quality_script
    file check_sample_stats_script

    output:
    file('*.tsv')

    """
    bash ${check_file_status_script} WES
    python ${tabulate_samples_quality_script}
    bash ${check_sample_stats_script}
    """
}
