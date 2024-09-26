/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT LOCAL MODULES/SUBWORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// MODULE: Loaded from modules/
//

include {BWA_ALIGN_READS} from "../../subworkflows/align_bwa"
include {GATK_BEST_PRACTICES} from "../../subworkflows/gatk_best_practices"
include {VCF_FILTER_AND_DECOMPOSE} from "../../subworkflows/vcf_filter_and_decompose"

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    NAMED WORKFLOWS FOR PIPELINE
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

//
// WORKFLOW: Run main analysis pipeline
//
workflow TARGETED_ANALYSIS {
    
    take:
    reads
    ref_genome
    ref_genome_index
    known_snps_dbsnp
    known_indels
    known_snps_dbsnp_index
    known_indels_index
    target_bed
    ch_versions

    main:

    ch_versions = Channel.empty()
    
    BWA_ALIGN_READS(
        reads,
        ref_genome,
        ref_genome_index
    )
    ch_versions = ch_versions.mix(BWA_ALIGN_READS.out.versions)

    ch_aligned_bam = BWA_ALIGN_READS.out.aligned_bam

    GATK_BEST_PRACTICES(
        ch_aligned_bam,
        ref_genome,
        ref_genome_index,
        known_snps_dbsnp,
        known_indels,
        known_snps_dbsnp_index,
        known_indels_index,
        target_bed
    )
    ch_versions = ch_versions.mix(GATK_BEST_PRACTICES.out.versions)

    ch_raw_vcf = GATK_BEST_PRACTICES.out.raw_vcf

    VCF_FILTER_AND_DECOMPOSE(
        ch_raw_vcf,
        ref_genome,
        ref_genome_index,
    )

    ch_versions = ch_versions.mix(VCF_FILTER_AND_DECOMPOSE.out.versions)

    emit:
        //BWA_ALIGN_READS.out.aligned_bam
        //GATK_BEST_PRACTICES.out.marked_dup_bam
        GATK_BEST_PRACTICES.out.bqsr_recal_table
        GATK_BEST_PRACTICES.out.bqsr_bam
        GATK_BEST_PRACTICES.out.gvcf_file
        GATK_BEST_PRACTICES.out.gvcf_index
        GATK_BEST_PRACTICES.out.raw_vcf
        VCF_FILTER_AND_DECOMPOSE.out.filtered_vcfs
        versions = ch_versions
}
