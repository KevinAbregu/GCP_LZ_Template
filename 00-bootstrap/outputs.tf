output "bootstrap" {
  value = module.bootstrap
}

output "configuration_variables" {
  value = {
    org_id               = var.org_id,
    billing_account      = var.billing_account,
    company_abbreviation = var.company_abbreviation,
    default_region       = var.default_region,
    project_prefix       = var.project_prefix
    sa_prefix            = var.sa_prefix
    bucket_prefix        = var.bucket_prefix
  }
}

