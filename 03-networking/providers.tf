terraform {
  required_version = ">=0.13.0"

  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
  backend "gcs" {
    bucket                      = "bkt-kevinlz02-networking"
    prefix                      = "terraform/networking/state"
    impersonate_service_account = "sa-kevinlz02-networking@g-prj-kevinlz02-bootstrap.iam.gserviceaccount.com"

  }
}

provider "google" {
  impersonate_service_account = "sa-kevinlz02-networking@g-prj-kevinlz02-bootstrap.iam.gserviceaccount.com"
}

provider "google-beta" {
  impersonate_service_account = "sa-kevinlz02-networking@g-prj-kevinlz02-bootstrap.iam.gserviceaccount.com"
}

locals {
  bootstrap_bucket            = "bkt-kevinlz02-bootstrap"
  impersonate_service_account = "sa-kevinlz02-networking@g-prj-kevinlz02-bootstrap.iam.gserviceaccount.com"

}

