resource "aws_s3_bucket" "infrahouse-backup" {
  bucket_prefix = "infrahouse-backup-"
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.infrahouse-backup.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "check_file" {
  bucket       = aws_s3_bucket.infrahouse-backup.bucket
  key          = ".github"
  content      = ""
  content_type = "text/plain"
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
      sse_algorithm = "AES256"
    }
  }
}
