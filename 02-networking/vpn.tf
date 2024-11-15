locals {
  vpn = [for i in var.vpn : merge(i,
    {
      parent_complete_name = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      #router_complete_name  = i.router_complete_name != null ? i.router_complete_name : "${var.router_prefix}-${local.company_abbreviation}-${i.router_name}"
      network_complete_name = i.network_complete_name != null ? i.network_complete_name : "${var.vpc_prefix}-${local.company_abbreviation}-${i.network_name}"
      complete_name         = i.complete_name != null ? i.complete_name : "${var.vpn_prefix}-${local.company_abbreviation}-${i.name}"
      region                = i.region != null ? i.region : local.default_region
    }
  )]
}

module "vpn" {
  source       = "terraform-google-modules/vpn/google"
  version      = "~> 4.0"
  count        = length(local.vpn)
  gateway_name = local.vpn[count.index].complete_name
  #cr_name       = local.vpn[count.index].cr_name
  project_id              = local.vpn[count.index].parent_complete_name
  region                  = local.vpn[count.index].region
  network                 = try(module.network["${local.vpn[count.index].parent_complete_name}@${local.vpn[count.index].network_complete_name}"].network_id, local.vpn[count.index].network_complete_name)
  peer_ips                = local.vpn[count.index].peer_ips
  vpn_gw_ip               = local.vpn[count.index].vpn_gw_ip
  tunnel_name_prefix      = local.vpn[count.index].tunnel_name_prefix
  remote_traffic_selector = local.vpn[count.index].remote_traffic_selector
  local_traffic_selector  = local.vpn[count.index].local_traffic_selector
  depends_on              = [module.cloud_router]
  shared_secret           = local.vpn[count.index].shared_secret
  remote_subnet           = local.vpn[count.index].remote_traffic_selector
  route_priority          = local.vpn[count.index].route_priority
}
