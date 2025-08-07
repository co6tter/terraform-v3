locals {
  # root_domain           = trim(var.zone_name, ".")
  cf_origin_id = "s3-origin-${var.project}-${var.env}"
  # basic_auth_token      = base64encode("${var.basic_auth_username}:${var.basic_auth_password}")
}
