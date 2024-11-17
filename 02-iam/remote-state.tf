data "terraform_remote_state" "bootstrap" {
  backend = "gcs"
  config = {
    bucket                      = local.bootstrap_bucket
    prefix                      = "terraform/bootstrap/state"
    impersonate_service_account = local.impersonate_service_account

  }
}

data "terraform_remote_state" "resource-mgmt" {
  backend = "gcs"
  config = {
    bucket                      = local.bootstrap_bucket
    prefix                      = "terraform/resource-mgmt/state"
    impersonate_service_account = local.impersonate_service_account

  }
}

locals {
  org_id               = "organizations/${data.terraform_remote_state.bootstrap.outputs.configuration_variables.org_id}"
  company_abbreviation = data.terraform_remote_state.bootstrap.outputs.configuration_variables.company_abbreviation
  project_prefix       = data.terraform_remote_state.bootstrap.outputs.configuration_variables.project_prefix
  bucket_prefix        = data.terraform_remote_state.bootstrap.outputs.configuration_variables.bucket_prefix
  sa_prefix            = data.terraform_remote_state.bootstrap.outputs.configuration_variables.sa_prefix
  buckets = data.terraform_remote_state.bootstrap.outputs.buckets
  folders = data.terraform_remote_state.bootstrap.outputs.folders
  projects = data.terraform_remote_state.bootstrap.outputs.projects
  fldr_prefix = data.terraform_remote_state.bootstrap.outputs.fldr_prefix
  parent_root = data.terraform_remote_state.bootstrap.outputs.parent_root
}