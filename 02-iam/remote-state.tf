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
  bootstrap_id         = data.terraform_remote_state.bootstrap.outputs.bootstrap.seed_project_id
  org_id               = "organizations/${data.terraform_remote_state.bootstrap.outputs.configuration_variables.org_id}"
  company_abbreviation = try(data.terraform_remote_state.bootstrap.outputs.configuration_variables.company_abbreviation, null)
  project_prefix       = try(data.terraform_remote_state.bootstrap.outputs.configuration_variables.project_prefix, "prj")
  bucket_prefix        = try(data.terraform_remote_state.bootstrap.outputs.configuration_variables.bucket_prefix, "bkt")
  sa_prefix            = try(data.terraform_remote_state.bootstrap.outputs.configuration_variables.sa_prefix, "sa")
  fldr_prefix          = try(data.terraform_remote_state.resource-mgmt.outputs.fldr_prefix, "fldr")
  buckets              = try(data.terraform_remote_state.resource-mgmt.outputs.buckets, {})
  folders              = try(data.terraform_remote_state.resource-mgmt.outputs.folders, {})
  projects             = try(data.terraform_remote_state.resource-mgmt.outputs.projects, {})
  parent_root          = data.terraform_remote_state.resource-mgmt.outputs.parent_root
}

