variable "root_domain" {
  description = "Root domain"
  type        = string
}

variable "subdomain" {
  description = "Subdomain"
  type        = string
  default     = "docs"
}

variable "fqdn" {
  description = "FQDN"
  type        = string
  default     = null
}

variable "create_alias_records" {
  description = "A/AAAA (ALIAS)"
  type        = bool
  default     = true
}

variable "cf_domain_name" {
  description = "CloudFront Distribution domain_name"
  type        = string
  default     = null
}

variable "cf_hosted_zone_id" {
  description = "CloudFront Distribution hosted_zone_id"
  type        = string
  default     = null
}

variable "acm_dns_validations" {
  description = "ACM DNS validation records"
  type = list(object({
    key    = string
    name   = string
    type   = string
    record = string
  }))
  default = []
}

variable "acm_validation_ttl" {
  description = "ACM validation record TTL"
  type        = number
  default     = 60
}
