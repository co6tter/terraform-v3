output "cloudfront_domain_name" {
  description = "CloudFront domain name"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID"
  value       = aws_cloudfront_distribution.this.id
}

output "cloudfront_distribution_arn" {
  description = "CloudFront Distribution ARN"
  value       = aws_cloudfront_distribution.this.arn
}

output "cloudfront_hosted_zone_id" {
  description = "CloudFront Hosted Zone ID"
  value       = aws_cloudfront_distribution.this.hosted_zone_id
}
