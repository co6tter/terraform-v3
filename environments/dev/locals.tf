locals {
  project = var.project
  env     = "dev"
  region  = var.region
  tags    = { Project = local.project, Env = local.env }
}

locals {
  bucket_name = "${local.project}-${local.env}-assets"
}
