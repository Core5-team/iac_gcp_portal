locals {
  cloud_run_sa_id   = "${var.service_name}-runtime-sa"
  cloud_build_sa_id = "${var.service_name}-cloudbuild-sa"
  artifact_sa_id    = "${var.service_name}-artifact-sa"
}

resource "google_service_account" "cloud_run" {
  account_id   = local.cloud_run_sa_id
  project      = var.project_id
  display_name = "Cloud Run runtime SA for ${var.service_name}"
}

resource "google_service_account" "cloud_build" {
  account_id   = local.cloud_build_sa_id
  project      = var.project_id
  display_name = "Cloud Build SA for ${var.service_name}"
}

resource "google_service_account" "artifact" {
  account_id   = local.artifact_sa_id
  project      = var.project_id
  display_name = "Artifact Registry access SA for ${var.service_name}"
}

resource "google_project_iam_member" "cloud_run_logs" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "cloud_run_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "artifact_pull_cloud_run" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.cloud_run.email}"
}

resource "google_project_iam_member" "cloud_build_run_runtime_sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloud_build.email}"
}


resource "google_project_iam_member" "artifact_write_cloud_build" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.cloud_build.email}"
}

resource "google_project_iam_member" "cloud_build_run_deployer" {
  project = var.project_id
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.cloud_build.email}"
}

resource "google_project_iam_member" "cloud_build_iam_service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.cloud_build.email}"
}


