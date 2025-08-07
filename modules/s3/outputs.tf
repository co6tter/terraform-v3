output "bucket_name" {
  description = "Bucket name"
  value       = aws_s3_bucket.this.id
}

output "bucket_regional_domain" {
  description = "Bucket regional domain name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "cf_logs_bucket_domain" {
  description = "Cloudfront logs bucket domain name"
  value       = aws_s3_bucket.cf_logs.bucket_domain_name
}

output "bucket_arn" {
  description = "Bucket ARN"
  value       = aws_s3_bucket.this.arn
}

output "cf_logs_bucket_arn" {
  description = "Cloudfront logs bucket ARN"
  value       = aws_s3_bucket.cf_logs.arn
}

output "cf_logs_bucket_name" {
  description = "Cloudfront logs bucket name"
  value       = aws_s3_bucket.cf_logs.id
}
