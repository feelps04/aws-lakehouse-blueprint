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

output "dynamodb_alerts_table_name" {
  value       = aws_dynamodb_table.alerts.name
  description = "DynamoDB table name for alerts"
}

output "dynamodb_users_table_name" {
  value       = aws_dynamodb_table.users.name
  description = "DynamoDB table name for users"
}

output "lambda_exec_role_arn" {
  value       = aws_iam_role.lambda_exec_role.arn
  description = "IAM role ARN assumed by Lambda"
}

output "lambda_function_name" {
  value       = try(aws_lambda_function.alerts_processor[0].function_name, null)
  description = "Lambda function name (null when enable_lambda=false)"
}
