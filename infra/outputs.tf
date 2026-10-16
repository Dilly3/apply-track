output "service_url" {
  description = "ApplyTrack HTTPS endpoint"
  value       = google_cloud_run_v2_service.applytrack.uri
}
