output "bucket_name" {
  description = "Bucket name"
  value       = module.s3.bucket_name
}

output "cdn_domain" {
  description = "Cloudfront domain name"
  value       = module.cloudfront.cloudfront_domain
}
