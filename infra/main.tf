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
  project = var.project_id
  region  = var.region
}

resource "google_project_service" "artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"

  disable_on_destroy = false
}

resource "google_artifact_registry_repository" "applytrack" {
  project       = var.project_id
  location      = var.region
  repository_id = "applytrack"
  description   = "Docker images for the ApplyTrack learning project"
  format        = "DOCKER"

  depends_on = [
    google_project_service.artifact_registry
  ]
}
