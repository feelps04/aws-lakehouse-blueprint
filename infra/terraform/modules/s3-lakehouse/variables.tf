variable "name_prefix" {
  type        = string
  description = "Prefix for bucket names"
}

variable "use_kms" {
  type        = bool
  description = "Use SSE-KMS if true, else SSE-S3"
  default     = false
}

variable "bronze_expire_days" {
  type        = number
  default     = 30
}

variable "silver_expire_days" {
  type        = number
  default     = 180
}

variable "gold_expire_days" {
  type        = number
  default     = 365
}
