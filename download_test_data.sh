#!/bin/bash

# Script to download test datasets for Illumina QC pipeline

# Download paired-end test data (R1 and R2 for sample1 and sample2)
wget -P ./test_datasets/PE https://raw.githubusercontent.com/nf-core/test-datasets/viralrecon/illumina/amplicon/sample1_R1.fastq.gz

wget -P ./test_datasets/PE https://raw.githubusercontent.com/nf-core/test-datasets/viralrecon/illumina/amplicon/sample1_R2.fastq.gz

wget -P ./test_datasets/PE https://raw.githubusercontent.com/nf-core/test-datasets/viralrecon/illumina/amplicon/sample2_R1.fastq.gz

wget -P ./test_datasets/PE https://raw.githubusercontent.com/nf-core/test-datasets/viralrecon/illumina/amplicon/sample2_R2.fastq.gz

# Download single-end test data (R1 only for sample1 and sample2)
wget -P ./test_datasets/SE https://raw.githubusercontent.com/nf-core/test-datasets/viralrecon/illumina/amplicon/sample1_R1.fastq.gz

wget -P ./test_datasets/SE https://raw.githubusercontent.com/nf-core/test-datasets/viralrecon/illumina/amplicon/sample2_R1.fastq.gz