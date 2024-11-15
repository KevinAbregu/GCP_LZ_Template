terraform {
  required_version = ">= 1.3.5"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.52.0"
    }
  }
  # backend "gcs" {
  #   bucket                      = "bkt-lz-bootstrap-euwest1"
  #   prefix                      = "terraform/security/state"
  #   impersonate_service_account = "sa-lz-bootstrap@prd-admin-bootstrap.iam.gserviceaccount.com"

  # }

}

provider "google" {
  impersonate_service_account = "sa-security-vpc-sc-test@kevin-test-terraform-deploy.iam.gserviceaccount.com"
  scopes = [
    "https://www.googleapis.com/auth/cloud-identity.groups.readonly",
    "https://www.googleapis.com/auth/cloud-identity.groups",
    "https://www.googleapis.com/auth/cloud-identity",
    "https://www.googleapis.com/auth/cloud-platform",
    "https://www.googleapis.com/auth/groups"
  ]

}
provider "google-beta" {
  impersonate_service_account = "sa-security-vpc-sc-test@kevin-test-terraform-deploy.iam.gserviceaccount.com"
  scopes = [
    "https://www.googleapis.com/auth/cloud-identity.groups.readonly",
    "https://www.googleapis.com/auth/cloud-identity.groups",
    "https://www.googleapis.com/auth/cloud-identity",
    "https://www.googleapis.com/auth/cloud-platform",
  ]
}

