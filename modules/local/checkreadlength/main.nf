process CHECK_READ_LENGTH {
    tag "$meta.id"
    label 'process_single'

    conda "conda-forge::python=3.11"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/python:3.11' :
        'community.wave.seqera.io/library/fastp_fastqc_fq_multiqc_seqkit:35a4802c35df68db' }"
    // Mostly modified from the nf-core module structure
    input:
    tuple val(meta), path(stats)

    output:
    tuple val(meta), path(stats), emit: stats
    path "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    python3 -c "
import sys
import csv

tsv_file = sys.argv[1]

with open(tsv_file, 'r') as f:
    reader = csv.DictReader(f, delimiter='\t')
    
    for row in reader:
        max_len = int(row['max_len'])
        if max_len > 1500:
            print(f'Error: Read length {max_len} exceeds threshold of 1500 bp. This is most likely long-read data')
            sys.exit(1)

sys.exit(0)
    " ${stats}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python3 --version | sed 's/Python //')
    END_VERSIONS
    """

    stub:
    """
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python3 --version | sed 's/Python //')
    END_VERSIONS
    """
}
