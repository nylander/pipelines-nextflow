process AUGUSTUS_GBK2AUGUSTUS {
    tag "${genbank.baseName}"
    label 'process_single'

    conda (params.enable_conda ? "bioconda::augustus=3.4.0" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/augustus:3.4.0--pl5321h5f9f3d9_6':
        'quay.io/biocontainers/augustus:3.4.0--pl5321h5f9f3d9_6' }"

    input:
    path genbank

    output:
    path "${genbank}.train", emit: training_data
    path "${genbank}.test", emit: testing_data
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    // def prefix = task.ext.prefix ?: "${genbank.baseName}"
    """
    randomSplit.pl $genbank $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        augustus: \$( augustus | sed '1!d; s/.*(//; s/).*//' )
    END_VERSIONS
    """
}
