locals {
  github_deployer_member = "serviceAccount:${google_service_account.github_deployer.email}"
}

# Push and read images in this repository only.
resource "google_artifact_registry_repository_iam_member" "github_writer" {
  project    = "apply-track-028"
  location   = google_artifact_registry_repository.applytrack.location
  repository = google_artifact_registry_repository.applytrack.repository_id

  role   = "roles/artifactregistry.writer"
  member = local.github_deployer_member
}

# Deploy Cloud Run and manage its public invocation policy.
resource "google_project_iam_member" "github_cloud_run_admin" {
  project = "apply-track-028"
  role    = "roles/run.admin"
  member  = local.github_deployer_member
}

# Let GitHub deploy applications that run as this runtime identity.
resource "google_service_account_iam_member" "github_runtime_user" {
  service_account_id = google_service_account.applytrack_runtime.name
  role               = "roles/iam.serviceAccountUser"
  member             = local.github_deployer_member
}

# Allow API usage against this project.
resource "google_project_iam_member" "github_service_usage" {
  project = "apply-track-028"
  role    = "roles/serviceusage.serviceUsageConsumer"
  member  = local.github_deployer_member
}

# Allow application state and lock operations, excluding bootstrap objects.
resource "google_storage_bucket_iam_member" "github_application_state" {
  bucket = google_storage_bucket.terraform_state.name
  role   = "roles/storage.objectAdmin"
  member = local.github_deployer_member

  condition {
    title       = "application-state-only"
    description = "Allow bucket listing and object access under infra/"

    expression = <<-EOT
      resource.name == 'projects/_/buckets/apply-track-028-terraform-state' ||
      resource.name.startsWith('projects/_/buckets/apply-track-028-terraform-state/objects/infra/')
    EOT
  }
}
