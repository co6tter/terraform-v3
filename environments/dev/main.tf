provider "aws" {
  region = local.region
}

module "s3" {
  source  = "../../modules/s3"
  project = local.project
  env     = local.env
  tags    = local.tags
}
