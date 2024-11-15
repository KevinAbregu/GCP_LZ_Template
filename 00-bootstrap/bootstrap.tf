module "bootstrap" {
  source = "../modules/terraform-google-bootstrap-master"

  org_id                = var.org_id
  billing_account       = var.billing_account
  group_org_admins      = var.group_org_admins
  default_region        = var.default_region
  project_id            = var.project_id == null ? format("%s-%s-%s", var.project_prefix, var.company_abbreviation, "bootstrap") : var.project_id
  state_bucket_name     = var.state_bucket_name == null ? format("%s-%s-%s", var.bucket_prefix, var.company_abbreviation, "bootstrap") : var.state_bucket_name
  tf_service_account_id = var.tf_service_account_id == null ? format("%s-%s-%s", var.sa_prefix, var.company_abbreviation, "bootstrap") : var.tf_service_account_id

  tf_service_account_name = var.tf_service_account_name
  parent_folder           = var.parent_folder
  activate_apis           = var.activate_apis
  project_labels          = var.project_labels
  sa_enable_impersonation = var.sa_enable_impersonation
  sa_org_iam_permissions  = var.sa_org_iam_permissions
  folder_id               = var.folder_id
  force_destroy           = var.force_destroy
  grant_billing_user      = var.grant_billing_user
  random_suffix           = var.random_suffix

}
