output "ingestion_uploader_access_key_id" {
  value     = aws_iam_access_key.ingestion_uploader.id
  sensitive = true
}

output "ingestion_uploader_secret_access_key" {
  value     = aws_iam_access_key.ingestion_uploader.secret
  sensitive = true
}

output "glue_job_role_arn" {
  value = aws_iam_role.glue_job_role.arn
}
