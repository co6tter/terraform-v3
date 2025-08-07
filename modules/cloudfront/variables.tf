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
