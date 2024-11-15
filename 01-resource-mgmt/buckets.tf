locals {
  _buckets = [for i in var.buckets : merge(i,
    {
      complete_name        = i.complete_name != null ? i.complete_name : "${local.bucket_prefix}-${local.company_abbreviation}-${i.name}"
      parent_complete_name = i.parent_complete_name != null ? i.parent_complete_name : "${local.project_prefix}-${local.company_abbreviation}-${i.parent_name}"
      location             = i.location != null ? i.location : local.default_region
    }
  )]
}
module "bucket" {
  source          = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/gcs?ref=v28.0.0"
  for_each        = { for i in local._buckets : i.complete_name => i }
  project_id      = each.value.parent_complete_name == "BOOTSTRAP" ? local.bootstrap_id : try(module.project[each.value.parent_complete_name].id, each.value.parent_complete_name)
  name            = each.value.complete_name
  lifecycle_rules = each.value.lifecycle_rules
  versioning      = each.value.versioning
  storage_class   = each.value.storage_class
  location        = each.value.location
  force_destroy   = each.value.force_destroy
  labels = merge({
    project       = each.value.parent_complete_name == "BOOTSTRAP" ? local.bootstrap_id : try(module.project[each.value.parent_complete_name].id, each.value.parent_complete_name),
    resource-type = "bucket"
  }, each.value.labels)

}

