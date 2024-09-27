include { EXTRACT_MTDNA_BAM } from "../../modules/mitocaller/extract_mtdna"
include { MITOCALLER } from "../../modules/mitocaller/run_mitocaller"


workflow MITOCALLER {

  take:
  ch_recalbam
  ref_genome
  
  main:
  EXTRACT_MTDNA_BAM(ch_recalbam)
  MITOCALLER(EXTRACT_MTDNA_BAM.out, ref_genome)

  emit:
  mitocaller_output_summary   = MITOCALLER,out[0]
}
