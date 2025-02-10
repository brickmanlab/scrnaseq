process MTX_TO_H5AD {

    //
    // This module executes different conversion template scripts (per aligner) for converting output mtx files into h5ad files
    //

    tag "$meta.id"
    label 'process_medium'

    conda "conda-forge::scanpy==1.10.2 conda-forge::python-igraph conda-forge::leidenalg"
    container "community.wave.seqera.io/library/scanpy:1.10.2--e83da2205b92a538"

    input:
    // inputs from cellranger nf-core module does not come in a single sample dir
    // for each sample, the sub-folders and files come directly in array.
    tuple val(meta), path(inputs)
    path txp2gene
    path star_index
    val input_aligner

    output:
    tuple val(meta), path("${meta.id}_${meta.input_type}_matrix.h5ad"), emit: h5ad
    path  "versions.yml"                                              , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def aligner = (input_aligner in [ 'cellranger', 'cellrangerarc', 'cellrangermulti' ]) ? 'cellranger' : input_aligner

    template "mtx_to_h5ad_${aligner}.py"

    stub:
    """
    touch ${meta.id}_${meta.input_type}_matrix.h5ad
    touch versions.yml
    """
}
