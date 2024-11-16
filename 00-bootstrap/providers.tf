terraform {
  required_version = ">=0.13.0"
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
  backend "gcs" {
    bucket                      = "bkt-kevinlz01-bootstrap"
    prefix                      = "terraform/bootstrap/state"
    impersonate_service_account = "sa-kevinlz01-bootstrap@g-prj-kevinlz01-bootstrap.iam.gserviceaccount.com"
  }
}

provider "google" {
  impersonate_service_account = "sa-kevinlz01-bootstrap@g-prj-kevinlz01-bootstrap.iam.gserviceaccount.com"
}
provider "google-beta" {
  impersonate_service_account = "sa-kevinlz01-bootstrap@g-prj-kevinlz01-bootstrap.iam.gserviceaccount.com"
}

