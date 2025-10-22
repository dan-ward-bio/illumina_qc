# Illumina QC Nextflow Pipeline

## Introduction

This is a Nextflow pipeline for performing quality control (QC) on Illumina sequencing data. The pipeline ingests raw Illumina SE/PE FASTQ files from a specified directory, performs integrity checks, trimming, fastQC analysis (pre and post trimming) and aggragates the results into a multiQC report.

![pipeline_diagram](img/illumina_qc_workflow_diagram.drawio.svg)

## Requirements (tested on)

- Ubuntu 22.04.2 LTS x86_64
- Nextflow 25.04.8.5956
- nf-core/tools version 3.4.1
- nf-test 0.9.0
- mamba 1.1.0
- conda 23.3.1


## Quick Start

```nextflow run main.nf --dir test_datasets/PE --pe --batch test_batch```

## Installation guide

## Usage parameters

## Pipeline summary

1. Ingest raw FASTQ sequencing files

## Usage

## Outputs

## Limitations