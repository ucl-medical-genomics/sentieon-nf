process sentieon_all {
  container 'ghcr.io/ucl-medical-genomics/sentieon-cli'
  publishDir "${params.output_dir}", mode: 'copy'

  cpus 128
  input:
  val(sample_id)
  path(ref)
  path(ref_index), name: "ref_index"
  path(dbsnp)
  path(dbsnp_index)
  path(r1_fastq)
  path(r2_fastq)
  val(readgroups)
  path(model)
  path(sentieon_license)

  output:
  path("${sample_id}.vcf.gz")

  script:
  """
  ls -lh
  for i in ref_index/*; do
    ln -s \$i .
  done
  export SENTIEON_LICENSE=${sentieon_license}
  sentieon-cli dnascope \
    -r ${ref} \
    --r1-fastq ${r1_fastq} \
    --r2-fastq ${r2_fastq} \
    --readgroups '${readgroups}' \
    -m ${model} \
    -d ${dbsnp} \
    -t 120 \
    -g \
    ${sample_id}.vcf.gz
  """
}

workflow {
  sentieon_all(
    params.sample_id,
    params.ref,
    params.ref_index,
    params.dbsnp,
    params.dbsnp_index,
    params.r1_fastq,
    params.r2_fastq,
    params.readgroups,
    params.model,
    params.sentieon_license
  )
}