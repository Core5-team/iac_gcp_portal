resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region
  project  = var.project_id

  template {
    spec {
      service_account_name = var.run_sa_email
      containers {
        image = var.image
        resources {
          limits = {
            cpu    = "1"
            memory = "512Mi"
          }
        }
        ports {
          container_port = 8080
        }
        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.key
            value = env.value
          }
        }
      }
      container_concurrency = 80
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "20"
        "run.googleapis.com/client-name"   = "terraform"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

resource "google_cloud_run_service_iam_member" "invoker" {
  project  = var.project_id
  location = var.region
  service  = google_cloud_run_service.default.name
  role     = "roles/run.invoker"
  member   = contains(var.allowed_invokers, "allUsers") ? "allUsers" : (length(var.allowed_invokers) > 0 ? var.allowed_invokers[0] : "serviceAccount:${var.run_sa_email}")
}

output "url" {
  value = google_cloud_run_service.default.status[0].url
}

output "name" {
  value = google_cloud_run_service.default.name
}

resource "google_project_service" "run_api" {
  project = var.project_id
  service = "run.googleapis.com"
}
