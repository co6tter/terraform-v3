provider "aws" {
  region = local.region
}

module "iam" {
  source                      = "../../modules/iam"
  bucket_arn                  = module.s3.bucket_arn
  cf_logs_bucket_arn          = module.s3.cf_logs_bucket_arn
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
  tags                        = local.tags
}

module "s3" {
  source                      = "../../modules/s3"
  project                     = local.project
  env                         = local.env
  tags                        = local.tags
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
}

module "cloudfront" {
  source                     = "../../modules/cloudfront"
  project                    = local.project
  env                        = local.env
  tags                       = local.tags
  origin_domain_name         = module.s3.bucket_regional_domain
  cf_logs_bucket_domain_name = module.s3.cf_logs_bucket_domain
}

resource "aws_s3_bucket_policy" "main_cf" {
  bucket = module.s3.bucket_name
  policy = module.iam.allow_cf_policy_json
}

resource "aws_s3_bucket_policy" "cf_logs" {
  bucket = module.s3.cf_logs_bucket_name
  policy = module.iam.cf_log_write_policy_json
}

module "github_oidc" {
  source                     = "../../modules/github-oidc"
  project                    = local.project
  env                        = local.env
  repo                       = var.repo
  bucket_arn                 = module.s3.bucket_arn
  cloudfront_distribution_id = module.cloudfront.cloudfront_distribution_id
  tags                       = local.tags
}
