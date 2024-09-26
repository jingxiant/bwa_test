include { RUN_QUALIMAP_WES } from "../../modules/qualimap_wes"
include { DEPTH_OF_COVERAGE_WES } from "../../modules/bam_qc"

workflow BAM_QC {

  take:
  ch_apply_bqsr
  targeted_bed_covered
  ref_genome
  ref_genome_index
  refgene_track

  main:
  ch_versions = Channel.empty()
  RUN_QUALIMAP_WES(ch_apply_bqsr, targeted_bed_covered)
  DEPTH_OF_COVERAGE_WES(ch_apply_bqsr, ref_genome, ref_genome_index, refgene_track, targeted_bed_covered)

  emit:
  qualimap_stats           = RUN_QUALIMAP_WES.out[0]
  depth_of_coverage_stats  = DEPTH_OF_COVERAGE_WES.out[0]
  versions                 = ch_versions
}
