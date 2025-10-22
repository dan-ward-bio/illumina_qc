# Illumina QC Nextflow Pipeline

## Introduction

This is a Nextflow pipeline for performing quality control (QC) on Illumina sequencing data. The pipeline ingests raw Illumina SE/PE FASTQ files from a specified directory, performs integrity checks, trimming, fastQC analysis (pre and post trimming) and aggragates the results into a multiQC report.

![pipeline_diagram](img/illumina_qc_workflow_diagram.svg)

## Requirements (tested on)

- Ubuntu 22.04.2 LTS x86_64
- Mac OS Sequoia ARM64 (Use docker profile)
- Nextflow 25.04.8.5956
- nf-core/tools version 3.4.1
- nf-test 0.9.0
- mamba 1.1.0
- conda 23.3.1
- wget

## Quick Start

Download the workflow:

Currently there is not support for ```nextflow pull``` functionality. The repo must be cloned and the workflow launched from the local directory.

```
git clone https://github.com/dan-ward-bio/illumina_qc.git
cd illumina_qc
```

**Download the test datasets (from the workflow top directory):**

```
chmod +x download_test_data.sh
bash download_test_data.sh
```

**To run the workflow on the downloaded test paired-end dataset:**

With docker (Apple Silicon compatible):
```
nextflow run main.nf --dir test_datasets/PE --pe --batch 1 -profile docker
```
With conda:
```
nextflow run main.nf --dir test_datasets/PE --pe --batch test_batch -profile conda
```

**To run the full batch of end-to-end tests using nf-test, use the following command:**

```
nf-test test tests/main.nf.test
```

## Usage parameters

```
nextflow run main.nf --dir test_datasets/PE --pe --batch test_batch --fastq_pattern '{R1,R2}' 

--dir {directory with FASTQ files} 
--pe {set for paired-end data, omit for single-end}
--se  {set for single-end data, omit for paired-end}
--batch {batch name} (Output results directory will be named according to batch)
--fastq_pattern {suffix for FASTQ PE files in braces and single quotes} Default: '{R1,R2}'
```

## Pipeline summary

1. Ingest raw FASTQ sequencing files from target directory.
2. Run [seqkit](https://bioinf.shenwei.me/seqkit/) stats.
3. Check seqkit stats to ensure input is not long read.
4. Run [fq](https://github.com/stjude-rust-labs/fq) lint to check FASTQ integrity.
5. Run [fastp](https://github.com/OpenGene/fastp) for adapter trimming.
6. Run [fastQC](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) post trimming
7. Aggregate results with [multiQC](https://seqera.io/multiqc/).

## Outputs
1. Seqkit stats TSV summary.
2. Fastp trimmed FASTQ files.
3. FastQC HTML reports.
4. MultiQC HTML report.

## Limitations and upcoming features
* Full unit testing not yet implemented.
* Implement a fastQC trimming step before trimming.
* Gracious handling of long read data not yet implemented.
* Nextflow resource handling
* Implementation in nf-core template/style guide.
* Option for sample sheet imput.
* GitHub CI.
* Full docker/Singularity containerisation.

