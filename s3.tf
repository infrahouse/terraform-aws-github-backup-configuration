resource "aws_s3_bucket" "infrahouse-backup" {
  bucket_prefix = var.bucket_prefix
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.infrahouse-backup.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.infrahouse-backup.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.infrahouse-backup.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_master_key_id == null ? "AES256" : "aws:kms"
      kms_master_key_id = var.kms_master_key_id
    }
    bucket_key_enabled = true
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "infrahouse-backup" {
    bucket = aws_s3_bucket_versioning.enabled.bucket
    rule {
        id     = "delete-old"
        status = "Enabled"
        filter {}
        expiration {
            days = var.backup_retention_days
        }
        noncurrent_version_expiration {
            noncurrent_days = 7
        }
    }
}
