variable "bucket_prefix" {
  description = "A prefix for S3 bucket name"
  default     = "infrahouse-backup-"
}

variable "backup_retention_days" {
  description = "How many days to keep backup copies."
  default     = 30
}

variable "logs_retention_days" {
  description = "How many days to keep access logs to the bucket with backup copies"
  default     = 360
}

variable "kms_master_key_id" {
  description = "Customer managed KMS key id for the bucket encryption."
  default     = null
}
