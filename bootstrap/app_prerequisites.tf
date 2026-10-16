resource "google_project_service" "application_apis" {
  for_each = toset([
    "artifactregistry.googleapis.com",
    "run.googleapis.com",
  ])

  project = "apply-track-028"
  service = each.value

  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "applytrack" {
  project       = "apply-track-028"
  location      = "us-central1"
  repository_id = "applytrack"
  description   = "Docker images for ApplyTrack"
  format        = "DOCKER"

  depends_on = [
    google_project_service.application_apis
  ]
}

resource "google_service_account" "applytrack_runtime" {
  project      = "apply-track-028"
  account_id   = "applytrack-runtime"
  display_name = "ApplyTrack runtime identity"

  depends_on = [
    google_project_service.github_identity_apis
  ]
}

output "repository_url" {
  value = "us-central1-docker.pkg.dev/apply-track-028/${google_artifact_registry_repository.applytrack.repository_id}"
}

output "runtime_service_account_email" {
  value = google_service_account.applytrack_runtime.email
}
