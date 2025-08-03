variable "bucket_name" {
  description = "Bucket name"
  type        = string
  default     = "terraform-v3-state-bucket"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "ap-northeast-1"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}
