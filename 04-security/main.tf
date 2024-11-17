module "regular_service_perimeter" {
  source                          = "../modules/regular_service_perimeter"
  policy                          = var.policy_id
  perimeter_name                  = var.service_perimeter.perimeter_name
  description                     = var.service_perimeter.description
  restricted_services             = local.perimeters_restricted_services_enforced_list
  resources                       = local.perimeters_resources_list.enforce_list
  access_levels                   = var.service_perimeters_access_level.enforce_list
  restricted_services_dry_run     = local.perimeters_restricted_services_dry_run_list
  resources_dry_run               = local.perimeters_resources_list.dry_run_list
  access_levels_dry_run           = var.service_perimeters_access_level.dry_run_list
  vpc_accessible_services         = local.perimeters_accessible_services_list.enforce_list
  vpc_accessible_services_dry_run = local.perimeters_accessible_services_list.dry_run_list
  ingress_policies                = local.service_perimeters_in_policies_list.enforce_list
  ingress_policies_dry_run        = local.service_perimeters_in_policies_list.dry_run_list
  egress_policies                 = local.service_perimeters_eg_policies_list.enforce_list
  egress_policies_dry_run         = local.service_perimeters_eg_policies_list.dry_run_list
}
