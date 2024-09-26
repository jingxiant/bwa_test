include { EXOMEDEPTH_FILTER_MERGE_TSV } from "../../modules/exomedepth/filter_merged_tsv"
include { EXOMEDEPTH_POSTPROCESS_SINGLE } from "../../modules/exomedepth/postprocess_single"
include { EXOMEDEPTH_POSTPROCESS_COHORT } from "../../modules/exomedepth/postprocess_cohort"

workflow EXOMEDEPTH_POSTPROCESS {

  take:
  exomedepth_merged_tsv
  svafotate_vcf
  exomedepth_annotate_counts_script
  exomedepth_deletion_db
  exomedepth_duplication_db
  add_svaf_script
  ch_vcf_filtered_tsv
  process_script_single
  panel
  clingen
  mutation_spectrum
  decipher

  main:
  EXOMEDEPTH_FILTER_MERGE_TSV(exomedepth_merged_tsv, svafotate_vcf, exomedepth_annotate_counts_script, exomedepth_deletion_db, exomedepth_duplication_db, add_svaf_script)

  EXOMEDEPTH_FILTER_MERGE_TSV.out.flatten()
    .map {file -> [file.simpleName, file]}
    .set { exomedepth_ch }

  if(params.genotyping_mode == 'single'){
    EXOMEDEPTH_POSTPROCESS_SINGLE(exomedepth_ch.join(ch_vcf_filtered_tsv), process_script_single, panel, clingen, mutation_spectrum, decipher)
    postprocess_result = EXOMEDEPTH_POSTPROCESS_SINGLE.out
  }
  else if(params.genotyping_mode == 'joint'){
    EXOMEDEPTH_POSTPROCESS_COHORT(exomedepth_ch, ch_vcf_filtered_tsv, process_script_single, panel, clingen, mutation_spectrum, decipher)
    postprocess_result = EXOMEDEPTH_POSTPROCESS_COHORT.out
  }

  emit:
  exomedepth_merged_filtered_tsv    = EXOMEDEPTH_FILTER_MERGE_TSV.out
  exomedepth_postprocess_tsv        = postprocess_result
  exomedepth_postprocess_tsv        = EXOMEDEPTH_POSTPROCESS_SINGLE.out
  //exomedepth_postprocess_cohort_tsv = EXOMEDEPTH_POSTPROCESS_COHORT.out
}
