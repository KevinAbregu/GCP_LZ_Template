locals {
  vpn = [for i in var.vpn : merge(i,
    {
      parent_complete_name  = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      router_complete_name  = i.router_complete_name != null ? i.router_complete_name : i.router_name != null ? "${var.router_prefix}-${local.company_abbreviation}-${i.router_name}": null
      network_complete_name = i.network_complete_name != null ? i.network_complete_name : "${var.vpc_prefix}-${local.company_abbreviation}-${i.network_name}"
      complete_name         = i.complete_name != null ? i.complete_name : "${var.vpn_prefix}-${local.company_abbreviation}-${i.name}"
      region                = i.region != null ? i.region : local.default_region
    }
  )]
}

module "vpn" {
  source                  = "terraform-google-modules/vpn/google"
  version                 = "~> 4.2"
  for_each                = { for i in local.vpn : "${i.parent_complete_name}@${i.complete_name}" => i }
  gateway_name            = each.value.complete_name
  cr_name                 = each.value.router_complete_name
  project_id              = each.value.parent_complete_name
  region                  = each.value.region
  network                 = try(module.network["${each.value.parent_complete_name}@${each.value.network_complete_name}"].network_id, each.value.network_complete_name)
  peer_ips                = each.value.peer_ips
  vpn_gw_ip               = each.value.vpn_gw_ip
  tunnel_name_prefix      = each.value.tunnel_name_prefix
  remote_traffic_selector = each.value.remote_traffic_selector
  local_traffic_selector  = each.value.local_traffic_selector
  shared_secret           = each.value.shared_secret
  remote_subnet           = each.value.remote_traffic_selector
  route_priority          = each.value.route_priority
  depends_on              = [module.cloud_router]

}
