module "org" {
  count                  = var.organization_policies == true ? 1 : 0
  source                 = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/organization?ref=v28.0.0"
  organization_id        = local.org_id
  org_policies_data_path = "org-policies-config/organization/"
}
