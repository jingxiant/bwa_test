include {GET_TOOLS_VERSION} from "../../modules/file_check"

workflow CHECK_FILE_VALIDITY {

  take:
  ch_versions_log
  modify_versions_log_script

  main:
  GET_TOOLS_VERSION(ch_versions_log, modify_versions_log_script)

  emit:
  version_txt       = GET_TOOLS_VERSION.out[0]

}
