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
  count = length(local.iam_subnets)

  project    = local.iam_subnets[count.index].parent_complete_name
  region     = local.iam_subnets[count.index].region
  subnetwork = local.iam_subnets[count.index].subnet_complete_name
  role       = "roles/compute.networkUser"
  member     = local.iam_subnets[count.index].member
  depends_on = [module.network]
}