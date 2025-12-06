module "iam" {
  source       = "./modules/iam"
  project_id   = var.project_id
  service_name = var.service_name
  region       = var.region
}

module "artifact_registry" {
  source     = "./modules/artifact_registry"
  project_id = var.project_id
  region     = var.region
  repo_name  = "${var.service_name}-repo"
}

module "cloud_run" {
  source       = "./modules/cloud_run"
  project_id   = var.project_id
  region       = var.region
  service_name = var.service_name
  image        = "${module.artifact_registry.repository_url}/${var.service_name}:${var.image_tag}"
  env_vars = {
    "ENV" = "prod"
  }
  allowed_invokers = var.allowed_invokers
  run_sa_email     = module.iam.cloud_run_sa_email
}

module "dns" {
  source     = "./modules/dns"
  project_id = var.project_id
  domain     = var.domain
  lb_ip_name = "${var.service_name}-lb-ip"
}

module "lb" {
  source       = "./modules/lb"
  project_id   = var.project_id
  domain       = var.domain
  service_name = var.service_name

  run_service_name   = module.cloud_run.name
  run_service_region = var.region

  certificate_map_name = "${var.service_name}-certmap"
  lb_ip_name           = module.dns.lb_ip_name
  lb_ip_resource       = module.dns.lb_ip_name
}
module "cloud_build" {
  source            = "./modules/cloud_build"
  project_id        = var.project_id
  repo_name         = var.git_repo_name
  branch_name       = var.git_branch
  image             = "${module.artifact_registry.repository_url}/${var.service_name}"
  cloud_run_service = module.cloud_run.name
  cloud_run_region  = var.region
  build_trigger_sa  = module.iam.cloud_build_sa_email
}

