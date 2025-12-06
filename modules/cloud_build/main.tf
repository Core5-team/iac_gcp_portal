resource "google_project_service" "cloudbuild_api" {
  service = "cloudbuild.googleapis.com"
  project = var.project_id
}

resource "google_cloudbuild_trigger" "github_trigger" {
  project = var.project_id
  name    = "${var.cloud_run_service}-trigger"

  github {
    owner = split("/", var.repo_name)[0]
    name  = split("/", var.repo_name)[1]
    push {
      branch = var.branch_name
    }
  }

  filename = "cloudbuild.yaml"

  substitutions = {
    "_IMAGE"             = "${var.image}"
    "_CLOUD_RUN_SERVICE" = var.cloud_run_service
    "_CLOUD_RUN_REGION"  = var.cloud_run_region
    "_CLOUD_RUN_SA"      = var.build_trigger_sa
  }

  service_account = "projects/${var.project_id}/serviceAccounts/${var.build_trigger_sa}"

}

