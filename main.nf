process sentieon_all {
  container '028616136117.dkr.ecr.us-east-1.amazonaws.com/sentieon-cli'
  publishDir "${params.output_dir}", mode: 'copy'

  cpus 128
  input:
  val(sample_id)
  path(ref)
  path(ref_index)
  path(bwa_index), name: "bwa_index/*"
  path(dbsnp)
  path(dbsnp_index)
  path(r1_fastq)
  path(r2_fastq)
  val(readgroups)
  path(model)

  script:
  """
  sentieon-cli dnascope \
    -r ${ref} \
    --r1-fastq ${r1_fastq} \
    --r2-fastq ${r2_fastq} \
    --readgroups "@RG\tID:HG002-1\tSM:HG002\tLB:HG002-LB-1\tPL:ILLUMINA" \
    -m ${model} \
    -d ${dbsnp} \
    -t 120 \
    -g \
    --dry-run \
    ${sample_id}.vcf.gz
  """
}

workflow {
  main(
    params.sample_id,
    params.ref,
    params.ref_index,
    params.bwa_index,
    params.dbsnp,
    params.dbsnp_index,
    params.r1_fastq,
    params.r2_fastq,
    params.readgroups,
    params.model,
  )
}