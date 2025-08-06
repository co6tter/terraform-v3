output "bucket_name" {
  description = "Bucket name"
  value       = aws_s3_bucket.this.bucket
}

output "bucket_regional_domain" {
  description = "Bucket regional domain name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
