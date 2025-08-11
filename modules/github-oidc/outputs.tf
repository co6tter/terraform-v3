output "github_oidc_provider_arn" {
  description = "ARN of the GitHub OIDC provider"
  value       = aws_iam_openid_connect_provider.github.arn
}

output "github_deploy_role_arn" {
  description = "ARN of the GitHub deploy role"
  value       = aws_iam_role.github_deploy.arn
}