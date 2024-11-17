data "terraform_remote_state" "bootstrap" {
  backend = "gcs"
  config = {
    bucket                      = local.bootstrap_bucket
    prefix                      = "terraform/bootstrap/state"
    impersonate_service_account = local.impersonate_service_account

  }
}

locals {
  bootstrap_id         = data.terraform_remote_state.bootstrap.outputs.bootstrap.seed_project_id
  billing_account      = data.terraform_remote_state.bootstrap.outputs.configuration_variables.billing_account
  org_id               = "organizations/${data.terraform_remote_state.bootstrap.outputs.configuration_variables.org_id}"
  company_abbreviation = try(data.terraform_remote_state.bootstrap.outputs.configuration_variables.company_abbreviation, null)
  project_prefix       = try(data.terraform_remote_state.bootstrap.outputs.configuration_variables.project_prefix, "prj")
  bucket_prefix        = try(data.terraform_remote_state.bootstrap.outputs.configuration_variables.bucket_prefix, "bkt")
  sa_prefix            = try(data.terraform_remote_state.bootstrap.outputs.configuration_variables.sa_prefix, "sa")
  default_region       = data.terraform_remote_state.bootstrap.outputs.configuration_variables.default_region
}