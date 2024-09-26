include { ANNOTATE_VEP } from "../../modules/vep_annotate"

workflow VEP_ANNOTATE {

  take:
  ch_decom_norm_vcf
  vep_cache
  vep_plugins

  main:
  ch_versions = Channel.empty()
  
  ANNOTATE_VEP(ch_decom_norm_vcf, vep_cache, vep_plugins)
  
  ch_versions = ch_versions.mix(ANNOTATE_VEP.out.versions)

  emit:
  annotated_vcf            = ANNOTATE_VEP.out[0]
  
  versions                 = ch_versions
}
