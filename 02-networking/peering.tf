locals {
  _peering = [for i in var.peerings : merge(i, {
    peer_network_complete_name = i.peer_network_complete_name != null ? i.peer_network_complete_name : "${var.vpc_prefix}-${local.company_abbreviation}-${i.peer_network_name}"
    peer_project_complete_name = i.peer_project_complete_name != null ? i.peer_project_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.peer_project_name}"

    local_network_complete_name = i.local_network_complete_name != null ? i.local_network_complete_name : "${var.vpc_prefix}-${local.company_abbreviation}-${i.local_network_name}"
    local_project_complete_name = i.local_project_complete_name != null ? i.local_project_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.local_project_name}"
  })]
}

module "peering" {
  source  = "terraform-google-modules/network/google//modules/network-peering"
  version = "~> 8.1"
  count   = length(local._peering)

  local_network                             = try(module.network["${local._peering[count.index].local_project_complete_name}@${local._peering[count.index].local_network_complete_name}"].network_id, local._peering[count.index].local_network_complete_name)
  peer_network                              = try(module.network["${local._peering[count.index].peer_project_complete_name}@${local._peering[count.index].peer_network_complete_name}"].network_id, local._peering[count.index].peer_network_complete_name)
  export_peer_custom_routes                 = local._peering[count.index].export_peer_custom_routes
  export_local_custom_routes                = local._peering[count.index].export_local_custom_routes
  export_peer_subnet_routes_with_public_ip  = local._peering[count.index].export_peer_subnet_routes_with_public_ip
  export_local_subnet_routes_with_public_ip = local._peering[count.index].export_local_subnet_routes_with_public_ip
  stack_type                                = local._peering[count.index].stack_type


}