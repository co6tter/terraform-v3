variable "bucket_arn" {
  description = "Bucket ARN"
  type        = string
}

variable "cf_logs_bucket_arn" {
  description = "Cloudfront logs bucket ARN"
  type        = string
}

variable "cloudfront_distribution_arn" {
  description = "Cloudfront distribution ARN"
  type        = string

}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
