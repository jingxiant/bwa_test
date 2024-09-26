include { HARDFILTER_VARIANTS } from "../../modules/hardfilter_variants"

workflow VCF_FILTER_AND_DECOMPOSE {

  take:
  ch_raw_vcf
  ref_genome
  ref_genome_index

  main:
  ch_versions = Channel.empty()

  HARDFILTER_VARIANTS(ch_raw_vcf,ref_genome, ref_genome_index)
  ch_versions = ch_versions.mix(HARDFILTER_VARIANTS.out.versions)
  
  emit:
  filtered_vcfs            = HARDFILTER_VARIANTS.out[0]

  versions                 = ch_versions
  
}
