module "lakehouse_buckets" {
  source = "./modules/s3-lakehouse"

  name_prefix = local.name
  use_kms     = var.use_kms

  bronze_expire_days = var.lifecycle_bronze_expire_days
  silver_expire_days = var.lifecycle_silver_expire_days
  gold_expire_days   = var.lifecycle_gold_expire_days
}
