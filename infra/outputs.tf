output "repository_url" {
  description = "Docker repository address used when tagging images"

  value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.applytrack.repository_id}"
}

output "service_url" {
  description = "ApplyTrack Cloud Run HTTPS endpoint"
  value       = google_cloud_run_v2_service.applytrack.uri
}
