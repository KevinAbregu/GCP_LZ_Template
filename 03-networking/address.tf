

locals {
  _address = [for i in var.address : merge(i,
    {
      parent_complete_name = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      subnet_complete_name = i.subnet_complete_name != null ? i.subnet_complete_name : try("${var.subnet_prefix}-${local.company_abbreviation}-${i.subnet_name}", null)
      region               = i.region != null ? i.region : local.default_region #
    }
  )]
}


module "address" {
  source             = "terraform-google-modules/address/google"
  version            = "~> 4.1"
  for_each           = { for i in local._address : "${i.parent_complete_name}|${i.address_type}|${i.subnet_complete_name != null ? i.subnet_complete_name : ""}" => i }
  project_id         = each.value.parent_complete_name
  subnetwork         = each.value.subnet_complete_name != null ? "projects/${each.value.parent_complete_name}/regions/${each.value.region}/subnetworks/${each.value.subnet_complete_name}" : null
  region             = each.value.region
  dns_project        = each.value.dns_project
  dns_domain         = each.value.dns_domain
  dns_managed_zone   = each.value.dns_managed_zone
  dns_reverse_zone   = each.value.dns_reverse_zone
  names              = each.value.names
  addresses          = each.value.addresses
  address_type       = each.value.address_type
  dns_record_type    = each.value.dns_record_type
  dns_short_names    = each.value.dns_short_names
  dns_ttl            = each.value.dns_ttl
  enable_cloud_dns   = each.value.enable_cloud_dns
  enable_reverse_dns = each.value.enable_reverse_dns
  global             = each.value.global
  ip_version         = each.value.ip_version
  purpose            = each.value.purpose
  prefix_length      = each.value.prefix_length
  network_tier       = each.value.network_tier

  depends_on = [module.network]

}

