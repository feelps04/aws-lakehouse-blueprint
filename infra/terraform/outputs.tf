output "bronze_bucket_name" {
  value       = module.lakehouse_buckets.bronze_bucket_name
  description = "S3 bucket for Bronze layer"
}

output "silver_bucket_name" {
  value       = module.lakehouse_buckets.silver_bucket_name
  description = "S3 bucket for Silver layer"
}

output "gold_bucket_name" {
  value       = module.lakehouse_buckets.gold_bucket_name
  description = "S3 bucket for Gold layer"
}

output "ingestion_uploader_access_key_id" {
  value       = module.iam.ingestion_uploader_access_key_id
  description = "Access key for ingestion uploader (store securely)"
  sensitive   = true
}

output "ingestion_uploader_secret_access_key" {
  value       = module.iam.ingestion_uploader_secret_access_key
  description = "Secret key for ingestion uploader (store securely)"
  sensitive   = true
}
