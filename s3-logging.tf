## Logging
locals {
    logging_prefix = "access-log/"
}

resource "aws_s3_bucket" "infrahouse-backup-logs" {
    bucket_prefix = "${var.bucket_prefix}logs-"
}

resource "aws_s3_bucket_versioning" "infrahouse-backup-logs" {
    bucket = aws_s3_bucket.infrahouse-backup-logs.id
    versioning_configuration {
        status = "Disabled"
    }
}

resource "aws_s3_bucket_logging" "infrahouse-backup" {
    bucket        = aws_s3_bucket.infrahouse-backup.bucket
    target_bucket = aws_s3_bucket.infrahouse-backup-logs.bucket
    target_prefix = local.logging_prefix
}

resource "aws_s3_bucket_lifecycle_configuration" "infrahouse-backup-logs" {
    bucket = aws_s3_bucket.infrahouse-backup-logs.bucket
    rule {
        id     = "delete-old"
        status = "Enabled"
        filter {
            prefix = local.logging_prefix
        }
        expiration {
            days = var.logs_retention_days
        }
    }
}
