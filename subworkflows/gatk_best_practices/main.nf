include { MARK_DUPLICATES } from "../../modules/mark_duplicates"
include { BASE_RECALIBRATOR } from "../../modules/bqsr_wes"
include { APPLY_BQSR } from "../../modules/apply_bqsr_wes"
include { HAPLOTYPECALLER } from "../../modules/haplotypecaller_wes"

workflow GATK_BEST_PRACTICES {

  take:
  ch_aligned_bam
  ref_genome
  ref_genome_index
  known_snps_dbsnp
  known_indels
  known_snps_dbsnp_index
  known_indels_index
  target_bed

  main:
  ch_versions = Channel.empty()

  MARK_DUPLICATES(ch_aligned_bam)
  ch_versions = ch_versions.mix(MARK_DUPLICATES.out.versions)
  
  BASE_RECALIBRATOR(MARK_DUPLICATES.out[0], ref_genome, ref_genome_index, known_snps_dbsnp_index, known_indels_index, known_snps_dbsnp, known_indels, target_bed)
  ch_versions = ch_versions.mix(BASE_RECALIBRATOR.out.versions)

  APPLY_BQSR(MARK_DUPLICATES.out[0].join(BASE_RECALIBRATOR.out[0]), ref_genome, ref_genome_index)
  ch_versions = ch_versions.mix(APPLY_BQSR.out.versions)

  emit:
  marked_dup_bam           = MARK_DUPLICATES.out[0]
  bqsr_recal_table         = BASE_RECALIBRATOR.out[0]
  bqsr_bam                 = APPLY_BQSR.out[0]

  versions                 = ch_versions
}

