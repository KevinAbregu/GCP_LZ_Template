

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
  source  = "terraform-google-modules/address/google"
  version = "~> 3.2"

  count      = length(local._address)
  project_id = local._address[count.index].parent_complete_name
  subnetwork = local._address[count.index].subnet_complete_name != null ? "projects/${local._address[count.index].parent_complete_name}/regions/${local._address[count.index].region}/subnetworks/${local._address[count.index].subnet_complete_name}" : null

  region             = local._address[count.index].region
  dns_project        = local._address[count.index].dns_project
  dns_domain         = local._address[count.index].dns_domain
  dns_managed_zone   = local._address[count.index].dns_managed_zone
  dns_reverse_zone   = local._address[count.index].dns_reverse_zone
  names              = local._address[count.index].names
  addresses          = local._address[count.index].addresses
  address_type       = local._address[count.index].address_type
  dns_record_type    = local._address[count.index].dns_record_type
  dns_short_names    = local._address[count.index].dns_short_names
  dns_ttl            = local._address[count.index].dns_ttl
  enable_cloud_dns   = local._address[count.index].enable_cloud_dns
  enable_reverse_dns = local._address[count.index].enable_reverse_dns
  global             = local._address[count.index].global
  ip_version         = local._address[count.index].ip_version
  purpose            = local._address[count.index].purpose
  prefix_length      = local._address[count.index].prefix_length
  network_tier       = local._address[count.index].network_tier

  depends_on = [module.network]

}

