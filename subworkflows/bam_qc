include {RUN_QUALIMAP_WES} from "../../modules/qualimap_wes"

workflow BAM_QC {

  take:
  ch_apply_bqsr
  targeted_bed_covered

  main:
  ch_versions = Channel.empty()
  RUN_QUALIMAP_WES(ch_apply_bqsr, targeted_bed_covered)

  emit:
  qualimap_stats           = RUN_QUALIMAP_WES.out[0]
  versions                 = ch_versions
}
