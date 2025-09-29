output "zone_id" {
  description = "Route53 Zone ID"
  value       = data.aws_route53_zone.root.zone_id
}

output "fqdn" {
  description = "FQDN"
  value       = coalesce(var.fqdn, "${var.subdomain}.${var.root_domain}")
}

output "acm_validation_record_fqdns" {
  description = "ACM validation record FQDNs"
  value       = [for r in aws_route53_record.acm_validation : r.fqdn]
}

output "alias_a_fqdn" {
  description = "A record FQDN"
  value       = try(aws_route53_record.alias_a[0].fqdn, null)
}

output "alias_aaaa_fqdn" {
  description = "AAAA record FQDN"
  value       = try(aws_route53_record.alias_aaaa[0].fqdn, null)
}
