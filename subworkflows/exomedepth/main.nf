include { GET_SAMPLES_FOR_EXOMEDEPTH } from "../../modules/get_sample_exomedepth"
include { EXOMEDEPTH_KNOWN_TEST_SPLITCHR } from "../../modules/exomedepth/known_test_splitchr"
include { EXOMEDEPTH_MERGE_TSV } from "../../modules/exomedepth/merge_tsv"
include { SVAFOTATE_FOR_EXOMEDEPTH } from "../../modules/exomedepth/svafotate"

workflow EXOMEDEPTH_CNV_CALLING {

  take:
  ch_apply_bqsr_bam
  controls
  ref_genome
  ref_genome_index
  exomedepth_target_bed
  exomedepth_gene_bed
  chr
  convert_tsv_to_vcf_script_for_exomedepth
  svafotate_bed

  main:
  ch_versions = Channel.empty()

  GET_SAMPLES_FOR_EXOMEDEPTH(ch_apply_bqsr_bam)

  EXOMEDEPTH_KNOWN_TEST_SPLITCHR(controls, ch_apply_bqsr_bam, ref_genome, ref_genome_index, exomedepth_target_bed, exomedepth_gene_bed, chr, GET_SAMPLES_FOR_EXOMEDEPTH.out)
  ch_versions = ch_versions.mix(EXOMEDEPTH_KNOWN_TEST_SPLITCHR.out.versions)
  
  EXOMEDEPTH_MERGE_TSV(EXOMEDEPTH_KNOWN_TEST_SPLITCHR.out[1].collect())

  EXOMEDEPTH_MERGE_TSV.out.flatten().view()
  SVAFOTATE_FOR_EXOMEDEPTH(EXOMEDEPTH_MERGE_TSV.out.flatten(), convert_tsv_to_vcf_script_for_exomedepth, svafotate_bed)
  
  emit:
  sample_list_for_exomedepth   = GET_SAMPLES_FOR_EXOMEDEPTH.out[0]
  exomedepth_tsv               = EXOMEDEPTH_KNOWN_TEST_SPLITCHR.out[1]
  exomedepth_png               = EXOMEDEPTH_KNOWN_TEST_SPLITCHR.out[2]
  exomedepth_rds               = EXOMEDEPTH_KNOWN_TEST_SPLITCHR.out[3]
  exomedepth_merged_tsv        = EXOMEDEPTH_MERGE_TSV.out
  svafotate_vcf                = SVAFOTATE_FOR_EXOMEDEPTH.out

  versions                     = ch_versions
}

