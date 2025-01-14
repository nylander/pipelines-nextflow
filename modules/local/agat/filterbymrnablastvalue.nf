process AGAT_FILTERBYMRNABLASTVALUE {
    tag "${gff.baseName}"
    label 'process_single'

    // WARN: Version information not provided by tool on CLI. Please update version string below when bumping container versions.
    conda (params.enable_conda ? "bioconda::agat=0.9.2" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/agat:0.9.2--pl5321hdfd78af_1':
        'quay.io/biocontainers/agat:0.9.2--pl5321hdfd78af_1' }"

    input:
    path gff
    path blast_tbl

    output:
    path "*_blast-filtered.gff3", emit: blast_filtered
    path "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${gff.baseName}"
    def VERSION = '0.9.2'  // WARN: Version information not provided by tool on CLI. Please update this string when bumping container versions.
    """
    agat_sp_filter_by_mrnaBlastValue.pl \\
        --gff $gff \\
        --blast $blast_tbl \\
        --outfile ${prefix}_blast-filtered.gff3

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        agat: $VERSION
    END_VERSIONS
    """
}
