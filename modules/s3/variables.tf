variable "project" {
  description = "Project name"
  type        = string
}

variable "env" {
  description = "Environment name (dev, stg, prod)"
  type        = string
}

variable "tags" {
  description = "Tags"
  type        = map(string)
}

variable "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  type        = string
}

variable "lifecycle_transition_ia_days" {
  description = "Days after which objects are transitioned to STANDARD_IA"
  type        = number
  default     = 30
}

variable "lifecycle_transition_deep_archive_days" {
  description = "Days after which objects are transitioned to DEEP_ARCHIVE"
  type        = number
  default     = 60
}
