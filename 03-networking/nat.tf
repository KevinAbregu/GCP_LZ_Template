locals {
  _nats = [for i in var.nats : merge(i,
    {
      parent_complete_name = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      router_complete_name = i.router_complete_name != null ? i.router_complete_name : "${var.router_prefix}-${local.company_abbreviation}-${i.router_name}"
      complete_name        = i.complete_name != null ? i.complete_name : "${var.nat_prefix}-${local.company_abbreviation}-${i.name}"
      region               = i.region != null ? i.region : local.default_region
    }
  )]
}
module "cloud-nat" {
  source                              = "terraform-google-modules/cloud-nat/google"
  version                             = "~> 5.3"
  for_each                            = {for i in local._nats: "${i.parent_complete_name}@${i.complete_name}" => i}
  project_id                          = each.value.parent_complete_name
  name                                = each.value.complete_name
  region                              = each.value.region
  icmp_idle_timeout_sec               = each.value.icmp_idle_timeout_sec
  min_ports_per_vm                    = each.value.min_ports_per_vm
  max_ports_per_vm                    = each.value.max_ports_per_vm
  nat_ips                             = each.value.nat_ips
  router                              = each.value.router_complete_name
  source_subnetwork_ip_ranges_to_nat  = each.value.source_subnetwork_ip_ranges_to_nat
  tcp_established_idle_timeout_sec    = each.value.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = each.value.tcp_transitory_idle_timeout_sec
  tcp_time_wait_timeout_sec           = each.value.tcp_time_wait_timeout_sec
  udp_idle_timeout_sec                = each.value.udp_idle_timeout_sec
  subnetworks                         = each.value.subnetworks
  log_config_enable                   = each.value.log_config_enable
  log_config_filter                   = each.value.log_config_filter
  enable_dynamic_port_allocation      = each.value.enable_dynamic_port_allocation
  enable_endpoint_independent_mapping = each.value.enable_endpoint_independent_mapping
  depends_on = [
    module.cloud_router,
    module.address
  ]

}
