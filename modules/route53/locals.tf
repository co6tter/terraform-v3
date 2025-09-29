locals {
  fqdn = coalesce(var.fqdn, "${var.subdomain}.${var.root_domain}")
}
