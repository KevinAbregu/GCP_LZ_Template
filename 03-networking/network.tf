locals {
  _networks = [for i in var.networks : merge(i,
    {
      subnets : [for k in i.subnets : merge(k,
        {
          subnet_name   = k.subnet_complete_name != null ? k.subnet_complete_name : "${var.subnet_prefix}-${local.company_abbreviation}-${k.subnet_name}"
          subnet_region = k.subnet_region != null ? k.subnet_region : local.default_region
        }
      )]
      parent_complete_name = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      complete_name        = i.complete_name != null ? i.complete_name : "${var.vpc_prefix}-${local.company_abbreviation}-${i.name}"
      secondary_ranges     = { for k, v in i.secondary_ranges : replace(k, "[PREFIX]", "${var.subnet_prefix}-${local.company_abbreviation}-") => v }
    })
  ]
}


module "network" {
  source                                 = "terraform-google-modules/network/google"
  version                                = "~> 8.1"
  for_each                               = { for i in local._networks : "${i.parent_complete_name}@${i.complete_name}" => i }
  project_id                             = each.value.parent_complete_name
  network_name                           = each.value.complete_name
  routing_mode                           = each.value.routing_mode
  subnets                                = each.value.subnets
  secondary_ranges                       = each.value.secondary_ranges
  routes                                 = each.value.routes
  delete_default_internet_gateway_routes = each.value.delete_default_internet_gateway_routes
  description                            = each.value.description
  auto_create_subnetworks                = each.value.auto_create_subnetworks
  mtu                                    = each.value.mtu
  ingress_rules                          = each.value.ingress_rules
  egress_rules                           = each.value.egress_rules


}


