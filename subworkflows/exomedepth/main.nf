include {GET_SAMPLES_FOR_EXOMEDEPTH } from "../../modules/get_sample_exomedepth"
include { EXOMEDEPTH_KNOWN_TEST_SPLITCHR } from from "../../modules/exomedepth_known_test_splitchr"

workflow EXOMEDEPTH_CNV_CALLING {

  take:
  controls
  ch_apply_bqsr_bam
  ref_genome
  ref_genome_index
  exomedepth_target_bed
  exomedepth_gene_bed
  chr
  sample_list

  main:
  ch_versions = Channel.empty()

  GET_SAMPLES_FOR_EXOMEDEPTH(ch_apply_bqsr_bam)
  EXOMEDEPTH_KNOWN_TEST_SPLITCHR(controls, ch_apply_bqsr_bam, ref_genome, ref_genome_index, exomedepth_target_bed, exomedepth_gene_bed, chr, sample_list)

  ch_versions = ch_versions.mix(EXOMEDEPTH_KNOWN_TEST_SPLITCHR.out.versions)

  emit:
  sample_list_for_exomedepth   = GET_SAMPLES_FOR_EXOMEDEPTH.out[0]
  exomedepth_tsv               = EXOMEDEPTH_KNOWN_TEST_SPLITCHR.out[1]
  exomedepth_png               = EXOMEDEPTH_KNOWN_TEST_SPLITCHR.out[2]
  exomedepth_rds               = EXOMEDEPTH_KNOWN_TEST_SPLITCHR.out[3]

  versions                     = ch_versions
}

