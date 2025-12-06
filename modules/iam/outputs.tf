output "cloud_run_sa_email" {
  value = google_service_account.cloud_run.email
}

output "cloud_build_sa_email" {
  value = google_service_account.cloud_build.email
}

output "artifact_sa_email" {
  value = google_service_account.artifact.email
}

