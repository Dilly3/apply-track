resource "google_cloud_run_v2_service" "applytrack" {
  project             = var.project_id
  name                = "applytrack"
  location            = var.region
  deletion_protection = false

  template {
    service_account = "applytrack-runtime@apply-track-028.iam.gserviceaccount.com"

    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }

    containers {
      image = var.image

      ports {
        container_port = 8080
      }

      env {
        name  = "GIN_MODE"
        value = "release"
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
}

resource "google_cloud_run_v2_service_iam_member" "public_access" {
  project  = var.project_id
  location = google_cloud_run_v2_service.applytrack.location
  name     = google_cloud_run_v2_service.applytrack.name

  role   = "roles/run.invoker"
  member = "allUsers"
}
