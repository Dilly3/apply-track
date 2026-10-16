resource "google_project_service" "github_identity_apis" {
  for_each = toset([
    "iam.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iamcredentials.googleapis.com",
    "sts.googleapis.com",
  ])

  project = "apply-track-028"
  service = each.value

  disable_on_destroy = false
}

resource "google_iam_workload_identity_pool" "github" {
  project                   = "apply-track-028"
  workload_identity_pool_id = "github-actions"
  display_name              = "GitHub Actions"

  depends_on = [
    google_project_service.github_identity_apis
  ]
}

resource "google_iam_workload_identity_pool_provider" "github" {
  project                            = "apply-track-028"
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github"
  display_name                       = "ApplyTrack GitHub"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  attribute_mapping = {
    "google.subject"                = "assertion.sub"
    "attribute.repository_id"       = "assertion.repository_id"
    "attribute.repository_owner_id" = "assertion.repository_owner_id"
    "attribute.ref"                 = "assertion.ref"
    "attribute.event_name"          = "assertion.event_name"
  }

  attribute_condition = <<-EOT
    assertion.repository_id == '1421811338' &&
    assertion.repository_owner_id == '79162206' &&
    assertion.ref == 'refs/heads/main' &&
    assertion.event_name == 'workflow_dispatch'
  EOT
}

resource "google_service_account" "github_deployer" {
  project      = "apply-track-028"
  account_id   = "applytrack-github-deployer"
  display_name = "ApplyTrack GitHub deployment identity"

  depends_on = [
    google_project_service.github_identity_apis
  ]
}

resource "google_service_account_iam_member" "github_federation" {
  service_account_id = google_service_account.github_deployer.name
  role               = "roles/iam.workloadIdentityUser"

  member = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository_id/1421811338"

  depends_on = [
    google_iam_workload_identity_pool_provider.github
  ]
}

output "github_workload_identity_provider" {
  value = google_iam_workload_identity_pool_provider.github.name
}

output "github_deployer_email" {
  value = google_service_account.github_deployer.email
}
