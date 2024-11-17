output "bucket_name" {
  description = "AWS S3 bucket for GitHub backups."
  value       = aws_s3_bucket.infrahouse-backup.bucket
}

output "backup_role_name" {
  description = "IAM role name for GitHub backups."
  value       = aws_iam_role.infrahouse-backup.name
}

output "backup_role_arn" {
  description = "IAM role ARN for GitHub backups."
  value       = aws_iam_role.infrahouse-backup.arn
}
