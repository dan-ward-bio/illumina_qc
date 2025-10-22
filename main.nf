#!/usr/bin/env nextflow

/*
 * MAIN WORKFLOW - Illumina QC 
 */

// Parameters
params.dir = null
params.pe = false
params.se = false
params.outdir = "./results"
params.fastq_pattern = null
params.batch = null 

// Import subworkflows
include { INGEST } from './workflows/ingest.nf'
include { ILLUMINA_QC } from './workflows/illumina_qc.nf'
include { AGGREGATE_RESULTS } from './workflows/aggregate_results.nf'

// Main workflow
workflow {
    
    // Validate input parameters
    if (!params.dir) {
        error "Please provide --dir parameter pointing to the directory containing reads"
    }
    
    if (!params.pe && !params.se) {
        error "Please specify either --pe (paired-end) or --se (single-end)"
    }
    
    if (params.pe && params.se) {
        error "Please specify either --pe OR --se, not both"
    }
    
    if (!params.batch) {
        error "Please provide --batch parameter to name this batch of samples"
    }
    
    // Call the INGEST subworkflow
    INGEST(
        params.dir,           
        params.pe,            
        params.fastq_pattern  
    )
    
    // Run the Illumina QC workflow
    ILLUMINA_QC(
        INGEST.out.reads   
    )

    // Aggregate results and run multiqc
    AGGREGATE_RESULTS(
        ILLUMINA_QC.out.fastqc_zip,  
        ILLUMINA_QC.out.fastp_json  
    )


}