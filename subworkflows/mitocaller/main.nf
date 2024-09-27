include { EXTRACT_MTDNA_BAM } from "../../modules/mitocaller/extract_mtdna"
include { MITOCALLER } from "../../modules/mitocaller/run_mitocaller"
include { FILTER_HETEROPLASMY } from "../../modules/mitocaller/filter_mitocaller_output"


workflow MITOCALLER_ANALYSIS {

  take:
  ch_recalbam
  ref_genome
  header_file
  
  main:
  EXTRACT_MTDNA_BAM(ch_recalbam)
  MITOCALLER(EXTRACT_MTDNA_BAM.out, ref_genome)
  FILTER_HETEROPLASMY(MITOCALLER.out[0],header_file)

  emit:
  mitocaller_output_summary   = MITOCALLER.out[0]
  mitocaller_filtered_output  = FILTER_HETEROPLASMY[0]
}
