variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "project_name" {
  type        = string
  description = "Project name prefix"
  default     = "lakehouse-blueprint"
}

variable "use_kms" {
  type        = bool
  description = "If true, use SSE-KMS for buckets. If false, use SSE-S3 (AES256)."
  default     = false
}

variable "lifecycle_bronze_expire_days" {
  type        = number
  description = "Bronze retention in days"
  default     = 30
}

variable "lifecycle_silver_expire_days" {
  type        = number
  description = "Silver retention in days"
  default     = 180
}

variable "lifecycle_gold_expire_days" {
  type        = number
  description = "Gold retention in days"
  default     = 365
}

variable "bronze_ingestion_prefix" {
  type        = string
  description = "S3 prefix under Bronze bucket for ingestion objects"
  default     = "events/"
}

variable "dynamodb_alerts_table_name" {
  type        = string
  description = "DynamoDB table name for alerts"
  default     = "Alerts"
}

variable "dynamodb_users_table_name" {
  type        = string
  description = "DynamoDB table name for users"
  default     = "Users"
}

variable "lambda_exec_role_name" {
  type        = string
  description = "IAM role name assumed by Lambda"
  default     = "sem_viagem_lambda_role"
}

variable "enable_lambda" {
  type        = bool
  description = "If true, create Lambda resources. If false, skip Lambda (useful for validating infra without code artifacts)."
  default     = false
}

variable "lambda_function_name" {
  type        = string
  description = "Lambda function name"
  default     = "sem-viagem-alerts-processor"
}

variable "lambda_handler" {
  type        = string
  description = "Lambda handler"
  default     = "index.handler"
}

variable "lambda_runtime" {
  type        = string
  description = "Lambda runtime"
  default     = "nodejs20.x"
}

variable "lambda_timeout_seconds" {
  type        = number
  description = "Lambda timeout in seconds"
  default     = 30
}

variable "lambda_memory_mb" {
  type        = number
  description = "Lambda memory in MB"
  default     = 256
}

variable "lambda_code_s3_bucket" {
  type        = string
  description = "S3 bucket containing the Lambda deployment package (.zip)"
  default     = ""
}

variable "lambda_code_s3_key" {
  type        = string
  description = "S3 key for the Lambda deployment package (.zip)"
  default     = ""
}

variable "enable_bronze_s3_trigger" {
  type        = bool
  description = "If true, configure S3 ObjectCreated trigger from Bronze bucket to Lambda"
  default     = false
}

variable "analytics_account_id" {
  type        = string
  description = "Optional AWS account ID allowed to assume a cross-account role to read Gold layer. Leave empty to disable."
  default     = ""
}
