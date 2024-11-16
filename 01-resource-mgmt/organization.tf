module "org" {
  count           = (var.organization_policies || var.custom_roles) ? 1 : 0
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/organization?ref=v35.0.0"
  organization_id = local.org_id
  factories_config = {
    org_policies = var.organization_policies ? "org-policies-config/organization/" : null
    custom_roles = var.custom_roles ? "org-custom-roles/" : null
  }
}

