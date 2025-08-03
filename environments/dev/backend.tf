terraform {
  backend "s3" {
    bucket       = var.bucket_name
    key          = "${var.environment}/terraform.tfstate"
    region       = var.region
    encrypt      = true
    use_lockfile = true
  }
}
