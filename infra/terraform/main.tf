resource "random_id" "suffix" {
  byte_length = 3
}

locals {
  suffix = lower(random_id.suffix.hex)
  name   = "${var.project_name}-${local.suffix}"
}

module "lakehouse_buckets" {
  source = "./modules/s3-lakehouse"

  name_prefix = local.name
  use_kms     = var.use_kms

  bronze_expire_days = var.lifecycle_bronze_expire_days
  silver_expire_days = var.lifecycle_silver_expire_days
  gold_expire_days   = var.lifecycle_gold_expire_days
}

module "iam" {
  source = "./modules/iam"

  name_prefix   = local.name
  bronze_bucket = module.lakehouse_buckets.bronze_bucket_name
  silver_bucket = module.lakehouse_buckets.silver_bucket_name
  gold_bucket   = module.lakehouse_buckets.gold_bucket_name
}
