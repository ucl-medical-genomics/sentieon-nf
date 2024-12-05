
process sentieon_all {
  container 'ghcr.io/ucl-medical-genomics/sentieon-cli'
  publishDir "${params.output_dir}", mode: 'copy'

  cpus 128
  input:
  tuple val(sample_id), path(r1_fastq), path(r2_fastq)
  path(ref)
  path(fasta_index)
  path(bwa_index)
  path(dbsnp)
  path(dbsnp_index)
  val(readgroups)
  path(model)
  path(sentieon_license)

  output:
  path("${sample_id}.vcf.gz")

  script:
  """
  export SENTIEON_LICENSE=${sentieon_license}
  sentieon-cli dnascope \
    -r ${ref} --r1-fastq ${r1_fastq} --r2-fastq ${r2_fastq} \
    --readgroups '${readgroups}' -m ${model} -d ${dbsnp} \
    -t 120 ${sample_id}.vcf.gz
  """
}

workflow {
  Channel
      .fromPath(params.sample_sheet)
      .splitCsv(header: true, sep: ',', strip: true)
      .map { row -> tuple(row.sample_id, row.r1_fastq, row.r2_fastq) }
      .groupTuple()
      .collect()
      .set { samples }

  sentieon_all(
    samples,
    params.ref,
    params.fasta_index,
    params.bwa_index,
    params.dbsnp,
    params.dbsnp_index,
    params.readgroups,
    params.model,
    params.sentieon_license
  )
}
