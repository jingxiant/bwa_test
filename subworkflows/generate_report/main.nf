include { GENERATE_REPORT_RMARKDOWN_SINGLESAMPLE } from "../../modules/rmarkdown_generate_report/single_sample"

workflow GENERATE_REPORT {

  take:
  ch_for_rmarkdown
  rmd_template
  resources_log
  panel
  
  main:
  if(params.genotyping_mode == 'single'){
    GENERATE_REPORT_RMARKDOWN_SINGLESAMPLE(ch_for_rmarkdown, rmd_template, resources_log, panel)
  }

  emit:
  sample_report      = GENERATE_REPORT_RMARKDOWN_SINGLESAMPLE.out[0]
}
