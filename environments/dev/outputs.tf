output "bucket_name" {
  description = "Bucket name"
  value       = module.s3.bucket_name
}

output "cf_domain" {
  description = "CloudFront domain name"
  value       = module.cloudfront.cloudfront_domain
}

output "cf_distribution_id" {
  description = "CloudFront Distribution ID"
  value       = module.cloudfront.cloudfront_distribution_id
}

output "github_deploy_role_arn" {
  description = "IAM role ARN assumed by GitHub Actions"
  value       = aws_iam_role.github_deploy.arn
}
