variable "project" {
  description = "Project"
  type        = string
  default     = "terraform-v3"
}

variable "region" {
  description = "Region"
  type        = string
  default     = "ap-northeast-1"
}

variable "repo" {
  description = "GitHub Repository"
  type        = string
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
