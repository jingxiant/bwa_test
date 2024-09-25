include { MERGE_FASTQ } from "../../modules/merge_fastq"
include { ALIGN_READS } from "../../modules/merge_fastq"

workflow ALIGN_READS {
  take:
  reads
  ref_genome
  ref_genome_index

  main:

  def getLibraryId( file ) {
        file.split(/\//)[-1].split(/_/)[0]
  }

  Channel
        .fromFilePairs( params.reads, flat: true )
        .map { prefix, file1, file2 -> tuple(getLibraryId(prefix), file1, file2) }
        .groupTuple()
        .set {reads}

  ch_versions = Channel.empty()

  MERGE_FASTQ(reads)
  ALIGN_READS(MERGE_FASTQ.out, ref_genome, ref_genome_index)
  ch_versions = ch_versions.mix(ALIGN_READS.out.versions)

  emit:
  merge_fastq              = MERGE_FASTQ.out 
  aligned_bam              = ALIGN_READS.out

  versions                 = ch_versions

}
