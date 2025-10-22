#!/usr/bin/env nextflow

/*
 * AGGREGATE RESULTS WORKFLOW
 */

// Import modules
include { MULTIQC } from '../modules/nf-core/multiqc/main'

workflow AGGREGATE_RESULTS {
    
    take:
    ch_fastqc_zip     
    ch_fastp_json
    
    main:
    
    // Initialize versions channel - DON'T forget to implement 
    ch_versions = Channel.empty()
    
    // Collect all outputs for multiqc
    ch_multiqc_files = Channel.empty()
        .mix(ch_fastqc_zip.map { _meta, zip -> zip })
        .mix(ch_fastp_json.map { _meta, json -> json })
        .collect()
    
    // Run multiqc - positional agrs for multiqc - see https://nf-co.re/modules/multiqc/
    MULTIQC(
        ch_multiqc_files,
        [],  // multiqc_config
        [],  // extra config to override module defaults
        [],  // logo path
        [],  // name lookup replacement
        []   // sample_names lookup
    )
    
    // Collect versions
    ch_versions = ch_versions.mix(MULTIQC.out.versions)
    
    emit:
    multiqc_report = MULTIQC.out.report
    multiqc_data   = MULTIQC.out.data       
    multiqc_plots  = MULTIQC.out.plots       
    versions       = ch_versions             
}
