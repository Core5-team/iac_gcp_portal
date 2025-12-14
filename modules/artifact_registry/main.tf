resource "google_artifact_registry_repository" "repo" {
  provider = google
  project  = var.project_id
  location = var.region
  repository_id = var.repo_name
  description = "Docker repository for ${var.repo_name}"
  format = "DOCKER"
}

resource "google_project_service" "artifact_registry_api" {
  service = "artifactregistry.googleapis.com"
  project = var.project_id
}

