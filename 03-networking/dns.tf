locals {
  _dns = [for i in var.dns : merge(i,
    {
      parent_complete_name               = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      complete_name                      = i.complete_name != null ? i.complete_name : "${var.dns_prefix}-${local.company_abbreviation}-${i.name}"
      private_visibility_config_networks = [for k in i.private_visibility_config_networks : merge(k, { complete_project = k.project != null || k.complete_project != null ? k.project != null ? "${local.project_prefix}-${local.company_abbreviation}-${k.project}" : k.complete_project : null })]
      
    }
  )]
  dns = [for i in local._dns : merge(i,
    {
      private_visibility_config_networks = [for k in i.private_visibility_config_networks : k.complete_project != null ? try(module.network["${k.complete_project}@${var.vpc_prefix}-${local.company_abbreviation}-${k.vpc}"].network_id, module.network["${k.complete_project}@${k.vpc}"].network_id) : k.vpc]
      test = [for k, v in merge([
        for f in try(fileset("dns/${i.parent_complete_name}/${i.complete_name}", "*.yaml"), []) :
        yamldecode(file("dns/${i.parent_complete_name}/${i.complete_name}/${f}"))
      ]...): v]
    }
  )]
}




module "dns" {
  source   = "terraform-google-modules/cloud-dns/google"
  version  = "5.3.0"
  for_each = { for i in local.dns : "${i.parent_complete_name}@${i.complete_name}" => i }
  name                               = each.value.complete_name
  project_id                         = each.value.parent_complete_name
  domain                             = each.value.domain
  private_visibility_config_networks = each.value.private_visibility_config_networks
  target_name_server_addresses       = each.value.target_name_server_addresses
  target_network                     = each.value.target_network
  description                        = each.value.description
  type                               = each.value.type
  dnssec_config                      = each.value.dnssec_config
  labels                             = each.value.labels
  default_key_specs_key              = each.value.default_key_specs_key
  default_key_specs_zone             = each.value.default_key_specs_zone
  force_destroy                      = each.value.force_destroy
  service_namespace_url              = each.value.service_namespace_url
  recordsets                         = concat(each.value.recordsets, tolist(each.value.test))
  enable_logging                     = each.value.enable_logging
}