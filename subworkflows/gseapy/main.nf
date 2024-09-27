include {RUN_EXOMEDEPTH_GSEAPY} from "../../modules/gseapy"

workflow GSEAPY {

  take:
  ch_exomedepth_tsv_for_gseapy
  gene_sets
  gseapy_enrich_script

  main:
  ch_versions = Channel.empty()
  RUN_EXOMEDEPTH_GSEAPY(ch_exomedepth_tsv_for_gseapy, gene_sets, gseapy_enrich_script)

  emit:
  gseapy_output_tsv        = RUN_EXOMEDEPTH_GSEAPY.out[0]
  
  versions                 = ch_versions
}
