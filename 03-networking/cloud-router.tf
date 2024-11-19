locals {
  routers = [for i in var.routers : merge(i,
    {
      parent_complete_name  = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      complete_name         = i.complete_name != null ? i.complete_name : "${var.router_prefix}-${local.company_abbreviation}-${i.name}"
      network_complete_name = i.network_complete_name != null ? i.network_complete_name : "${var.vpc_prefix}-${local.company_abbreviation}-${i.network_name}"
      region                = i.region != null ? i.region : local.default_region
    }
  )]
}

module "cloud_router" {
  source      = "terraform-google-modules/cloud-router/google"
  version     = "~> 6.2"
  for_each    = { for i in local.routers : "${i.parent_complete_name}@${i.complete_name}" => i }
  name        = each.value.complete_name
  project     = each.value.parent_complete_name
  region      = each.value.region
  network     = try(module.network["${each.value.parent_complete_name}@${each.value.network_complete_name}"].network_id, each.value.network_complete_name)
  description = each.value.description
  bgp         = each.value.bgp
}
