include { EXOMEDEPTH_FILTER_MERGE_TSV } from "../../modules/exomedepth/filter_merged_tsv"

workflow EXOMEDEPTH_POSTPROCESS {

  take:
  exomedepth_merged_tsv
  svafotate_vcf
  exomedepth_annotate_counts_script
  exomedepth_deletion_db
  exomedepth_duplication_db
  add_svaf_script

  main:
  EXOMEDEPTH_FILTER_MERGE_TSV(exomedepth_merged_tsv, svafotate_vcf, exomedepth_annotate_counts_script, exomedepth_deletion_db, exomedepth_duplication_db, add_svaf_script)

  emit:
  exomedepth_merged_filtered_tsv  = EXOMEDEPTH_FILTER_MERGE_TSV.out
  
}
