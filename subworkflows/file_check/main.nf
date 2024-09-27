include { GET_TOOLS_VERSION } from "../../modules/file_check/get_tools_version"
include { LOG_PARAMS } from "../../modules/log_params"
include { CHECK_FILE_VALIDITY_WES_MULTISAMPLE } from "../../modules/file_check/check_file_validity_multisample"
include { CHECK_FILE_VALIDITY_WES_SINGLESAMPLE } from "../../modules/file_check/check_file_validity_singlesample"


workflow CHECK_FILE_VALIDITY {

  take:
  ch_versions_log
  modify_versions_log_script
  parameters_file
  ch_for_filecheck
  check_file_status_script
  tabulate_samples_quality_script
  check_sample_stats_script
  
  main:
  GET_TOOLS_VERSION(ch_versions_log, modify_versions_log_script)

  LOG_PARAMS(parameters_file)

  if(params.genotyping_mode == 'single'){
    CHECK_FILE_VALIDITY_WES_SINGLESAMPLE(ch_for_filecheck, check_file_status_script,tabulate_samples_quality_script, check_sample_stats_script)
  }

  emit:
  version_txt                                 = GET_TOOLS_VERSION.out[0]
  params_log                                  = LOG_PARAMS.out
  check_file_validity_wes_multisample_output  = CHECK_FILE_VALIDITY_WES_MULTISAMPLE.out[0]
}
