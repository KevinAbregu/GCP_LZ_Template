locals {
  iam_subnets = [for i in var.iam_subnets : merge(i,
    {
      parent_complete_name = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      subnet_complete_name = i.subnet_complete_name != null ? i.subnet_complete_name : "${var.subnet_prefix}-${local.company_abbreviation}-${i.subnet_name}"
      region               = i.region != null ? i.region : local.default_region
    }
  )]
}

resource "google_compute_subnetwork_iam_member" "networkuser" {
  for_each = {for i in local.iam_subnets: "${i.parent_complete_name}|${i.subnet_complete_name}|${i.member}"=> i}
  project    = each.value.parent_complete_name
  region     = each.value.region
  subnetwork = each.value.subnet_complete_name
  role       = "roles/compute.networkUser"
  member     = each.value.member
  depends_on = [module.network]
}
