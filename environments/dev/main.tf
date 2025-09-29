provider "aws" {
  region = local.region
}

provider "aws" {
  alias  = "use1"
  region = "us-east-1"
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
  basic_auth_username        = var.basic_auth_username
  basic_auth_password        = var.basic_auth_password
  origin_domain_name         = module.s3.bucket_regional_domain
  cf_logs_bucket_domain_name = module.s3.cf_logs_bucket_domain
  acm_certificate_arn        = aws_acm_certificate.cf.arn
  aliases                    = ["${var.subdomain}.${var.root_domain}"]

  depends_on = [
    module.s3.cf_logs_bucket_acl,
    aws_acm_certificate_validation.cf
  ]
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

resource "aws_acm_certificate" "cf" {
  provider          = aws.use1
  domain_name       = "${var.subdomain}.${var.root_domain}"
  validation_method = "DNS"
  lifecycle { create_before_destroy = true }
}

locals {
  acm_dns_validations = [
    for dvo in aws_acm_certificate.cf.domain_validation_options : {
      key    = dvo.domain_name
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  ]
}

module "route53_dns_only" {
  source               = "../../modules/route53"
  root_domain          = var.root_domain
  subdomain            = var.subdomain
  create_alias_records = false
  acm_dns_validations  = local.acm_dns_validations
}

resource "aws_acm_certificate_validation" "cf" {
  provider                = aws.use1
  certificate_arn         = aws_acm_certificate.cf.arn
  validation_record_fqdns = module.route53_dns_only.acm_validation_record_fqdns
}

module "route53_alias" {
  source               = "../../modules/route53"
  root_domain          = var.root_domain
  subdomain            = var.subdomain
  create_alias_records = true
  cf_domain_name       = module.cloudfront.cloudfront_domain_name
  cf_hosted_zone_id    = module.cloudfront.cloudfront_hosted_zone_id
}
