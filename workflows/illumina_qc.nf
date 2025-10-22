#!/usr/bin/env nextflow

/*
 * ILLUMINA QC WORKFLOW
 * Performs adapter trimming with fastp lint integrity check
 */

// Import modules
include { FASTP } from '../modules/nf-core/fastp/main'
include { FASTQC } from '../modules/nf-core/fastqc/main'

workflow ILLUMINA_QC {
    
    take:
    ch_reads         
    
    main:
    
    // Initialize versions channel
    ch_versions = Channel.empty()
    
    // Prepare input for fastp - add null adapter_fasta path
    ch_reads_with_adapters = ch_reads.map { meta, reads ->
        [meta, reads, []] 
    }
    
    // Run fastp for adapter trimming and quality filtering
    FASTP(
        ch_reads_with_adapters,
        false,  // discard_trimmed_pass 
        false,  // save_trimmed_fail
        false   // save_merged
    )
    
    // Collect versions
    ch_versions = ch_versions.mix(FASTP.out.versions.first())
    
    // Run fastqc on trimmed reads
    FASTQC(FASTP.out.reads)
    
    // Collect versions
    ch_versions = ch_versions.mix(FASTQC.out.versions.first())
    
    emit:
    // fastp outputs
    trimmed_reads  = FASTP.out.reads     
    fastp_json     = FASTP.out.json      
    fastp_html     = FASTP.out.html     
    fastp_log      = FASTP.out.log      
    
    // fastqc outputs - trimmed reads
    fastqc_html    = FASTQC.out.html     
    fastqc_zip     = FASTQC.out.zip      
    
    versions       = ch_versions        
}
