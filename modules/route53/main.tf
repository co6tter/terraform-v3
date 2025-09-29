data "aws_route53_zone" "root" {
  name         = var.root_domain
  private_zone = false
}

resource "aws_route53_record" "acm_validation" {
  for_each = {
    for v in var.acm_dns_validations : v.key => v
  }
  zone_id = data.aws_route53_zone.root.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = var.acm_validation_ttl
  records = [each.value.record]
}

resource "aws_route53_record" "alias_a" {
  count   = var.create_alias_records ? 1 : 0
  zone_id = data.aws_route53_zone.root.zone_id
  name    = local.fqdn
  type    = "A"

  alias {
    name                   = var.cf_domain_name
    zone_id                = var.cf_hosted_zone_id
    evaluate_target_health = false
  }

  # create_alias_records=true のときだけ必須にする
  lifecycle {
    precondition {
      condition     = var.cf_domain_name != null && var.cf_hosted_zone_id != null
      error_message = "create_alias_records=true の場合は cf_domain_name と cf_hosted_zone_id が必須です。"
    }
  }
}

resource "aws_route53_record" "alias_aaaa" {
  count   = var.create_alias_records ? 1 : 0
  zone_id = data.aws_route53_zone.root.zone_id
  name    = local.fqdn
  type    = "AAAA"

  alias {
    name                   = var.cf_domain_name
    zone_id                = var.cf_hosted_zone_id
    evaluate_target_health = false
  }

  lifecycle {
    precondition {
      condition     = var.cf_domain_name != null && var.cf_hosted_zone_id != null
      error_message = "create_alias_records=true の場合は cf_domain_name と cf_hosted_zone_id が必須です。"
    }
  }
}
