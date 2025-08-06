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
