terraform {
  required_version = ">=0.13.0"
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
  # backend "gcs" {
  #   bucket                      = "bkt-demo0001-bootstrap"
  #   prefix                      = "terraform/bootstrap/state"
  #   impersonate_service_account = "sa-demo0001-bootstrap@g-prj-demo0001-bootstrap.iam.gserviceaccount.com"

  # }
}

provider "google" {
  # impersonate_service_account = "sa-demo0001-bootstrap@g-prj-demo0001-bootstrap.iam.gserviceaccount.com"
}
provider "google-beta" {
  # impersonate_service_account = "sa-demo0001-bootstrap@g-prj-demo0001-bootstrap.iam.gserviceaccount.com"
}

