provider "aws" {
  region = local.region
}

module "iam" {
  source                      = "../../modules/iam"
  bucket_arn                  = module.s3.bucket_arn
  cf_logs_bucket_arn          = module.s3.cf_logs_bucket_arn
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
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

data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

data "aws_iam_policy_document" "github_deploy" {
  statement {
    sid    = "S3Sync"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      module.s3.bucket_arn,
      "${module.s3.bucket_arn}/*"
    ]
  }
  statement {
    sid     = "CFInvalidate"
    effect  = "Allow"
    actions = ["cloudfront:CreateInvalidation"]
    resources = [
      "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${module.cloudfront.cloudfront_distribution_id}"
    ]
  }
}

resource "aws_iam_role" "github_deploy" {
  name = "github-deploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = aws_iam_openid_connect_provider.github.arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        "StringEquals" = {
          "token.actions.githubusercontent.com:sub" = "repo:${var.repo}:ref:refs/heads/main"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "github_deploy" {
  role   = aws_iam_role.github_deploy.id
  policy = data.aws_iam_policy_document.github_deploy.json
}
