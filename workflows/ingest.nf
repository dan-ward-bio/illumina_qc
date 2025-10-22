#!/usr/bin/env nextflow

// This one's a bit messy. I should have split out the import process from the integrity check

// Import nf-core seqkit_stats module - nf-core modules install seqkit/stats
// nf-core modules install seqkit/stats
// nf-core modules install fq/lint
include { SEQKIT_STATS } from '../modules/nf-core/seqkit/stats/main'
include { FQ_LINT } from '../modules/nf-core/fq/lint/main'
include { CHECK_READ_LENGTH } from '../modules/local/checkreadlength/main'

workflow INGEST {
    
    take:
    ch_input_dir      
    val_is_paired_end 
    val_fastq_pattern 
    
    main:
    
    // Initialize empty versions channel
    ch_versions = Channel.empty()
    
    // Create input channel using fromFilePairs
    // citation: https://bioinformatics.stackexchange.com/questions/20227/how-does-one-account-for-both-single-end-and-paired-end-reads-as-input-in-a-next - not using schema for simplicity
    def fastq_id = val_fastq_pattern ?: (val_is_paired_end ? "{R1,R2}" : "")
    
    // Create input channel using fromFilePairs
    def pattern = val_is_paired_end ? "${ch_input_dir}/*_${fastq_id}.fastq.gz" : "${ch_input_dir}/*${fastq_id}.fastq.gz"
    
    ch_reads = Channel
        .fromFilePairs(pattern, size: val_is_paired_end ? 2 : 1)
        .ifEmpty { error "Could not find any reads matching pattern: ${pattern}" }
        .map { pair_id, files -> 
            [ [id: pair_id, single_end: !val_is_paired_end], files ]
        }
    
    // Split paired files using flatmap in to individual suitable for seqkit and fq lint
    ch_individual_reads = ch_reads
        .flatMap { meta, files ->
            val_is_paired_end 
                ? [ [meta + [read: 'R1'], files[0]], [meta + [read: 'R2'], files[1]] ]
                : [ [meta, files[0]] ]
        }
    
    // Run seqkit stats on individual files - stats for long read detection
    SEQKIT_STATS(ch_individual_reads)
    ch_versions = ch_versions.mix(SEQKIT_STATS.out.versions.first())

    // Check read length - will crash out if detecting long read
    CHECK_READ_LENGTH(SEQKIT_STATS.out.stats)
    ch_versions = ch_versions.mix(CHECK_READ_LENGTH.out.versions.first())
    
    // Run fq lint on individual files - will also crash out if integrity check fails
    FQ_LINT(ch_individual_reads)
    ch_versions = ch_versions.mix(FQ_LINT.out.versions.first())
    
    // emitting outputs
    emit:
    reads        = ch_reads             
    individual   = ch_individual_reads   
    stats        = SEQKIT_STATS.out.stats 
    lint         = FQ_LINT.out.lint      
    versions     = ch_versions           
}
