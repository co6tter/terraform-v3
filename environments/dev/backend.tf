terraform {
  backend "s3" {
    bucket       = "terraform-v3-state-bucket"
    key          = "dev/terraform.tfstate"
    region       = "ap-northeast-1"
    encrypt      = true
    use_lockfile = true
  }

  required_version = ">= 1.12.0"
}
