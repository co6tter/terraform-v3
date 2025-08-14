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

variable "origin_domain_name" {
  description = "Origin domain name"
  type        = string
}

variable "cf_logs_bucket_domain_name" {
  description = "Cloudfront logs bucket domain name"
  type        = string
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "geo_restriction_type" {
  description = "CloudFront geo restriction type"
  type        = string
  default     = "none"
}

variable "basic_auth_username" {
  description = "Basic Auth username"
  type        = string
  sensitive   = true
}

variable "basic_auth_password" {
  description = "Basic Auth password"
  type        = string
  sensitive   = true
}
