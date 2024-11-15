locals {
  mig = [for i in var.mig : merge(i,
    {
      parent_complete_name = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      complete_name        = i.complete_name != null ? i.complete_name : "${var.mig_prefix}-${local.company_abbreviation}-${i.mig_name}"
    }
  )]
}


module "mig" {
  source  = "terraform-google-modules/vm/google//modules/mig"
  version = "11.1.0"

  for_each                         = { for i in local.mig : "${i.parent_complete_name}@${i.complete_name}" => i }
  autoscaler_name                  = each.value.autoscaler_name
  autoscaling_cpu                  = each.value.autoscaling_cpu
  autoscaling_enabled              = each.value.autoscaling_enabled
  autoscaling_lb                   = each.value.autoscaling_lb
  autoscaling_metric               = each.value.autoscaling_metric
  autoscaling_mode                 = each.value.autoscaling_mode
  autoscaling_scale_in_control     = each.value.autoscaling_scale_in_control
  cooldown_period                  = each.value.cooldown_period
  distribution_policy_target_shape = each.value.distribution_policy_target_shape
  distribution_policy_zones        = each.value.distribution_policy_zones
  health_check                     = each.value.health_check
  health_check_name                = each.value.health_check_name
  hostname                         = each.value.hostname
  instance_template                = module.instance_template["${each.value.parent_complete_name}@${var.instance_template_prefix}-${local.company_abbreviation}-${each.value.instance_template}"].self_link
  labels                           = each.value.labels
  max_replicas                     = each.value.max_replicas
  mig_name                         = each.value.mig_name
  mig_timeouts                     = each.value.mig_timeouts
  min_replicas                     = each.value.min_replicas
  named_ports                      = each.value.named_ports
  project_id                       = each.value.parent_complete_name
  region                           = each.value.region
  scaling_schedules                = each.value.scaling_schedules
  stateful_disks                   = each.value.stateful_disks
  stateful_ips                     = each.value.stateful_ips
  target_pools                     = each.value.target_pools
  target_size                      = each.value.target_size
  update_policy                    = each.value.update_policy
  wait_for_instances               = each.value.wait_for_instances

}