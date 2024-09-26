include {GET_SAMPLES_FOR_EXOMEDEPTH} from "../../modules/get_sample_exomedepth"

workflow EXOMEDEPTH_CNV_CALLING {

  take:
  ch_apply_bqsr

  main:
  ch_versions = Channel.empty()
  GET_SAMPLES_FOR_EXOMEDEPTH(ch_apply_bqsr)

  emit:
  sample_list_for_exomedepth   = GET_SAMPLES_FOR_EXOMEDEPTH.out[0]
  versions                     = ch_versions
}
