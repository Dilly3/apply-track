resource "google_project_service" "cloud_run" {
  project = var.project_id
  service = "run.googleapis.com"

  disable_on_destroy = false
}

resource "google_service_account" "applytrack" {
  project      = var.project_id
  account_id   = "applytrack-runtime"
  display_name = "ApplyTrack runtime identity"
}

resource "google_cloud_run_v2_service" "applytrack" {
  project             = var.project_id
  name                = "applytrack"
  location            = var.region
  deletion_protection = false

  template {
    service_account = google_service_account.applytrack.email

    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.applytrack.repository_id}/applytrack:v1"

      ports {
        container_port = 8080
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "256Mi"
        }

        cpu_idle = true
      }
    }
  }

  depends_on = [
    google_project_service.cloud_run
  ]
}

resource "google_cloud_run_v2_service_iam_member" "public_access" {
  project  = var.project_id
  location = google_cloud_run_v2_service.applytrack.location
  name     = google_cloud_run_v2_service.applytrack.name

  role   = "roles/run.invoker"
  member = "allUsers"
}
