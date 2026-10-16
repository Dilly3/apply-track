terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 6.0, < 8.0"
    }
  }
}

provider "google" {
  project = "apply-track-028"
  region  = "us-central1"
}

resource "google_storage_bucket" "terraform_state" {
  project                     = "apply-track-028"
  name                        = "apply-track-028-terraform-state"
  location                    = "us-central1"
  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"
  force_destroy               = false

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

output "state_bucket_name" {
  value = google_storage_bucket.terraform_state.name
}
