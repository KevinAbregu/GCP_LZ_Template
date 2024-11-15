locals {
  instance_template = [for i in var.instance_template : merge(i,
    {
      parent_complete_name = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      complete_name        = i.complete_name != null ? i.complete_name : "${var.instance_template_prefix}-${local.company_abbreviation}-${i.name_template}"
    }
  )]
}


module "instance_template" {
  source  = "terraform-google-modules/vm/google//modules/instance_template"
  version = "11.1.0"

  for_each = { for i in local.instance_template : "${i.parent_complete_name}@${i.complete_name}" => i }

  name_prefix                      = each.value.name_prefix
  project_id                       = each.value.parent_complete_name
  additional_disks                 = each.value.additional_disks
  additional_networks              = each.value.additional_networks
  alias_ip_range                   = each.value.alias_ip_range
  auto_delete                      = each.value.auto_delete
  automatic_restart                = each.value.automatic_restart
  can_ip_forward                   = each.value.can_ip_forward
  disk_encryption_key              = each.value.disk_encryption_key
  disk_labels                      = each.value.disk_labels
  disk_size_gb                     = each.value.disk_size_gb
  disk_type                        = each.value.disk_type
  enable_confidential_vm           = each.value.enable_confidential_vm
  enable_nested_virtualization     = each.value.enable_nested_virtualization
  enable_shielded_vm               = each.value.enable_shielded_vm
  gpu                              = each.value.gpu
  ipv6_access_config               = each.value.ipv6_access_config
  labels                           = each.value.labels
  machine_type                     = each.value.machine_type
  maintenance_interval             = each.value.maintenance_interval
  metadata                         = each.value.metadata
  min_cpu_platform                 = each.value.min_cpu_platform
  network                          = each.value.network
  network_ip                       = each.value.network_ip
  nic_type                         = each.value.nic_type
  on_host_maintenance              = each.value.on_host_maintenance
  preemptible                      = each.value.preemptible
  region                           = each.value.region
  resource_policies                = each.value.resource_policies
  service_account                  = each.value.service_account
  shielded_instance_config         = each.value.shielded_instance_config
  source_image                     = each.value.source_image
  source_image_family              = each.value.source_image_family
  source_image_project             = each.value.source_image_project
  spot                             = each.value.spot
  spot_instance_termination_action = each.value.spot_instance_termination_action
  stack_type                       = each.value.stack_type
  startup_script                   = each.value.startup_script
  subnetwork                       = each.value.subnetwork
  subnetwork_project               = each.value.subnetwork_project
  tags                             = each.value.tags
  threads_per_core                 = each.value.threads_per_core
  total_egress_bandwidth_tier      = each.value.total_egress_bandwidth_tier
}