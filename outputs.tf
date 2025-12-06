output "cloud_run_url" {
  value = module.cloud_run.url
}

output "artifact_repository" {
  value = module.artifact_registry.repository_url
}

output "load_balancer_ip" {
  value = module.dns.lb_ip_address
}

output "certificate_name" {
  value = module.lb.certificate_name
}

