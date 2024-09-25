include { MARK_DUPLICATES } from "../../modules/mark_duplicates"
include { BASE_RECALIBRATOR } from "../../modules/bqsr_wes"

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
  ch_versions = ch_versions.mix(MARK_DUPLICATES.out.versions.first())
  
  BASE_RECALIBRATOR(MERGE_FASTQ.out, ref_genome, ref_genome_index, known_snps_dbsnp_index, known_indels_index, known_snps_dbsnp, known_indels, target_bed)
  ch_versions = ch_versions.mix(BASE_RECALIBRATOR.out.versions)

  emit:
  marked_dup_bam           = MARK_DUPLICATES.out.first()
  bqsr_recal_table         = BASE_RECALIBRATOR.out.first()

  versions                 = ch_versions
}

