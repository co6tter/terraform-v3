output "allow_cf_policy_json" {
  description = "CloudFront access policy JSON"
  value       = data.aws_iam_policy_document.allow_cf.json
}

output "cf_log_write_policy_json" {
  description = "CloudFront log write policy JSON"
  value       = data.aws_iam_policy_document.cf_log_write.json
}