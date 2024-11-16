locals {
  default_services = [
    "serviceusage.googleapis.com",
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "logging.googleapis.com",
    "pubsub.googleapis.com",
    "compute.googleapis.com"
  ]
  _projects = [for i in var.projects : merge(i,
    {
      complete_name                   = i.complete_name != null ? i.complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.name}"
      parent_complete_name            = try(i.parent_complete_name != null ? i.parent_complete_name : "${var.fldr_prefix}-${i.parent_name}", null)
      svpc_service_host_complete_name = try(i.svpc_service_host_complete_name != null ? i.svpc_service_host_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.svpc_service_host_name}", null)
    }
  )]
}
module "project" {
  source           = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/project?ref=v35.0.0"
  for_each         = { for i in local._projects : i.complete_name => i }
  billing_account  = local.billing_account
  name             = each.value.complete_name
  descriptive_name = each.value.descriptive_name != null ? each.value.descriptive_name : each.value.complete_name
  parent           = each.value.parent_complete_name == "ROOT" ? var.parent_root : try(local.complete-folder[each.value.parent_complete_name], each.value.parent_complete_name)
  services         = concat(each.value.services, local.default_services)
  factories_config = {
    org_policies = each.value.org_policies_data_path != null ? "org-policies-config/projects/${each.value.org_policies_data_path}/" : null
  }
  shared_vpc_host_config  = each.value.svpc_host == true ? { enabled = true } : null
  default_service_account = each.value.default_service_account
  labels                  = merge({ project = each.value.complete_name, resource-type = "project" }, each.value.labels)
}

resource "google_compute_shared_vpc_service_project" "shared_vpc_service" {
  for_each        = { for i in local._projects : i.complete_name => i if i.svpc_service_host_complete_name != null }
  host_project    = try(module.project[each.value.svpc_service_host_complete_name].id, each.value.svpc_service_host_complete_name)
  service_project = each.value.complete_name
  depends_on      = [module.project]
}

locals {
  complete-project = { for k, v in module.project : v.name => v.id }
}


