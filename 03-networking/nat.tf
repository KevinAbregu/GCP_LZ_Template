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
  version                             = "~> 5.0"
  count                               = length(local._nats)
  project_id                          = local._nats[count.index].parent_complete_name
  name                                = local._nats[count.index].complete_name
  region                              = local._nats[count.index].region
  icmp_idle_timeout_sec               = local._nats[count.index].icmp_idle_timeout_sec
  min_ports_per_vm                    = local._nats[count.index].min_ports_per_vm
  max_ports_per_vm                    = local._nats[count.index].max_ports_per_vm
  nat_ips                             = local._nats[count.index].nat_ips
  router                              = local._nats[count.index].router_complete_name
  source_subnetwork_ip_ranges_to_nat  = local._nats[count.index].source_subnetwork_ip_ranges_to_nat
  tcp_established_idle_timeout_sec    = local._nats[count.index].tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec     = local._nats[count.index].tcp_transitory_idle_timeout_sec
  tcp_time_wait_timeout_sec           = local._nats[count.index].tcp_time_wait_timeout_sec
  udp_idle_timeout_sec                = local._nats[count.index].udp_idle_timeout_sec
  subnetworks                         = local._nats[count.index].subnetworks
  log_config_enable                   = local._nats[count.index].log_config_enable
  log_config_filter                   = local._nats[count.index].log_config_filter
  enable_dynamic_port_allocation      = local._nats[count.index].enable_dynamic_port_allocation
  enable_endpoint_independent_mapping = local._nats[count.index].enable_endpoint_independent_mapping
  depends_on = [
    module.cloud_router,
    module.address
  ]

}
