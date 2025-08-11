variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "repo" {
  description = "GitHub repository name (format: owner/repo)"
  type        = string
}

variable "bucket_arn" {
  description = "S3 bucket ARN for deployment"
  type        = string
}

variable "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}