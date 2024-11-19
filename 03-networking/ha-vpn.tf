locals {
  ha_vpn = [for i in var.ha_vpn : merge(i,
    {
      parent_complete_name  = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      router_complete_name  = i.router_complete_name != null ? i.router_complete_name : "${var.router_prefix}-${local.company_abbreviation}-${i.router_name}"
      network_complete_name = i.network_complete_name != null ? i.network_complete_name : "${var.vpc_prefix}-${local.company_abbreviation}-${i.network_name}"
      complete_name         = i.complete_name != null ? i.complete_name : "${var.vpn_prefix}-${local.company_abbreviation}-${i.name}"
      region                = i.region != null ? i.region : local.default_region
    }
  )]
}

module "ha_vpn" {
  source                           = "terraform-google-modules/vpn/google//modules/vpn_ha"
  version                          = "~> 4.2"
  for_each                         = { for i in local.ha_vpn : "${i.parent_complete_name}@${i.complete_name}" => i }
  peer_external_gateway            = each.value.peer_external_gateway
  peer_gcp_gateway                 = each.value.peer_gcp_gateway
  name                             = each.value.complete_name
  stack_type                       = each.value.stack_type
  network                          = try(module.network["${each.value.parent_complete_name}@${each.value.network_complete_name}"].network_id, each.value.network_complete_name)
  project_id                       = each.value.parent_complete_name
  region                           = each.value.region
  route_priority                   = each.value.route_priority
  keepalive_interval               = each.value.keepalive_interval
  router_name                      = each.value.router_complete_name
  tunnels                          = each.value.tunnels
  vpn_gateway_self_link            = each.value.vpn_gateway_self_link
  create_vpn_gateway               = each.value.create_vpn_gateway
  labels                           = each.value.labels
  external_vpn_gateway_description = each.value.external_vpn_gateway_description
  depends_on                       = [module.cloud_router]
}
