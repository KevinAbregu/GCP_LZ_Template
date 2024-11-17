terraform {
  required_version = ">=0.13.0"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">=3.23.0"
    }
  }
  backend "gcs" {
    bucket                      = "[BUCKET_ESSENTIALS]"
    prefix                      = "terraform/state"
    impersonate_service_account = "[SA_ESSENTIALS]"
  }
}

provider "google" {
  impersonate_service_account = "[SA_ESSENTIALS]"
  project                     = var.monitoring_project_id
  scopes = [
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/userinfo.email",
  ]
}


