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
  version                          = "~> 4.0"
  count                            = length(local.ha_vpn)
  peer_external_gateway            = local.ha_vpn[count.index].peer_external_gateway
  peer_gcp_gateway                 = local.ha_vpn[count.index].peer_gcp_gateway
  name                             = local.ha_vpn[count.index].complete_name
  stack_type                       = local.ha_vpn[count.index].stack_type
  network                          = try(module.network["${local.ha_vpn[count.index].parent_complete_name}@${local.ha_vpn[count.index].network_complete_name}"].network_id, local.ha_vpn[count.index].network_complete_name)
  project_id                       = local.ha_vpn[count.index].parent_complete_name
  region                           = local.ha_vpn[count.index].region
  route_priority                   = local.ha_vpn[count.index].route_priority
  keepalive_interval               = local.ha_vpn[count.index].keepalive_interval
  router_name                      = local.ha_vpn[count.index].router_complete_name
  tunnels                          = local.ha_vpn[count.index].tunnels
  vpn_gateway_self_link            = local.ha_vpn[count.index].vpn_gateway_self_link
  create_vpn_gateway               = local.ha_vpn[count.index].create_vpn_gateway
  labels                           = local.ha_vpn[count.index].labels
  external_vpn_gateway_description = local.ha_vpn[count.index].external_vpn_gateway_description
  depends_on                       = [module.cloud_router]
}
