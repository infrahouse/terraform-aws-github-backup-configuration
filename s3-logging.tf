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

resource "aws_s3_bucket_public_access_block" "infrahouse-backup-logs" {
  bucket                  = aws_s3_bucket.infrahouse-backup-logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "infrahouse-backup-logs" {
  bucket = aws_s3_bucket.infrahouse-backup-logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = var.kms_master_key_id == null ? "AES256" : "aws:kms"
      kms_master_key_id = var.kms_master_key_id
    }
    bucket_key_enabled = true
  }
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

data "aws_iam_policy_document" "enforce_tls_logs" {
  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.infrahouse-backup-logs.arn,
      "${aws_s3_bucket.infrahouse-backup-logs.arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

resource "aws_s3_bucket_policy" "enforce_tls_logs" {
  bucket = aws_s3_bucket.infrahouse-backup-logs.id
  policy = data.aws_iam_policy_document.enforce_tls_logs.json
}
