terraform {
  backend "gcs" {
    bucket = "apply-track-028-terraform-state"
    prefix = "bootstrap"
  }
}
