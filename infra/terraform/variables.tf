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
