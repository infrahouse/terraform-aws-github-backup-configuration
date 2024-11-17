module "main" {
  source                = "../../"
  # kms_master_key_id = aws_kms_key.mykey.id
  logs_retention_days   = 360
  backup_retention_days = 90
    bucket_prefix =
}
