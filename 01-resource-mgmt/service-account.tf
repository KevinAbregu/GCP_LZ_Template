locals {
  organization_numeric_id = split("/", local.org_id)[1]
  _service_accounts = [for i in var.service_accounts : merge(i,
    {
      complete_name        = i.complete_name != null ? i.complete_name : "${local.sa_prefix}-${local.company_abbreviation}-${i.name}"
      parent_complete_name = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      iam_folder_roles     = { for k, v in i.iam_folder_roles : replace(replace(k, "[PREFIX]", "${var.fldr_prefix}-"), "[ROOT]", var.parent_root) => v }
      iam_storage_roles    = { for k, v in i.iam_storage_roles : replace(k, "[PREFIX]", "${local.bucket_prefix}-${local.company_abbreviation}-") => v }
      iam_project_roles    = { for k, v in i.iam_project_roles : replace(k, "[PREFIX]", "${local.project_prefix}-${local.company_abbreviation}-") => v }

    }
  )]
}

module "service-account" {
  source                 = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/iam-service-account?ref=v28.0.0"
  for_each               = { for i in local._service_accounts : "${i.parent_complete_name}@${i.complete_name}" => i }
  project_id             = each.value.parent_complete_name == "BOOTSTRAP" ? local.bootstrap_id : try(module.project[each.value.parent_complete_name].id, each.value.parent_complete_name)
  name                   = each.value.complete_name
  display_name           = each.value.complete_name
  description            = each.value.description
  service_account_create = each.value.service_account_create
  iam_project_roles      = each.value.iam_project_roles
  iam_storage_roles      = { for k, v in each.value.iam_storage_roles : try(module.bucket[k].id, k) => v }
  iam_sa_roles           = each.value.iam_sa_roles
  iam_organization_roles = each.value.iam_organization_roles == [] ? {} : { "${local.organization_numeric_id}" = each.value.iam_organization_roles }
  iam_folder_roles       = { for k, v in each.value.iam_folder_roles : try(local.complete-folder[k], k) => v }
  iam_bindings           = each.value.iam_bindings

}

