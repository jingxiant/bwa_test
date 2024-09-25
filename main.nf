#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

params.reads: "*_R{1,2}.{fq,fastq}.gz"
params.ref: "/prism_data5/share/GATK_Bundle/hg38/newref/Homo_sapiens_assembly38.fasta"
params.ref_fai: "/prism_data5/share/GATK_Bundle/hg38/newref/Homo_sapiens_assembly38.fasta.fai"

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    GENOME PARAMETER VALUES
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

ref_fa = file(params.ref)
ref_fai = file(params.ref_fai)

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    IMPORT FUNCTIONS / MODULES / SUBWORKFLOWS / WORKFLOWS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include {TARGETED_ANALYSIS} from "./workflows/targeted_analysis"

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    FUNCTIONS
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/


workflow PRISM_TARGETED_ANALYSIS {
    
    main:

    ch_versions = Channel.empty()

    Channel
        .fromFilePairs( params.reads, flat: true )
        .map { prefix, file1, file2 -> tuple(getLibraryId(prefix), file1, file2) }
        .groupTuple()
        .set {reads}

    TARGETED_ANALYSIS(
        reads, 
        ref_fa, 
        ref_fai
    )
    ch_versions = ch_versions.mix(TARGETED_ANALYSIS.out.versions)
}

workflow {
    main: 
    PRISM_TARGETED_ANALYSIS()
}



    
