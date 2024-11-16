locals {
  _folders = {
    for k, v in var.folders : k => [
      for i in v : merge(i, {
        complete_name        = i.complete_name != null ? i.complete_name : "${var.fldr_prefix}-${i.name}"
        parent_complete_name = try(i.parent_complete_name != null ? i.parent_complete_name : "${var.fldr_prefix}-${i.parent_name}", null)
        }
      )
    ]
  }

  level1 = flatten([for k, v in local._folders : flatten(v) if k == "level1"])
  level2 = flatten([for k, v in local._folders : flatten(v) if k == "level2"])
  level3 = flatten([for k, v in local._folders : flatten(v) if k == "level3"])

}


module "folder-01" {
  source   = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/folder?ref=v35.0.0"
  for_each = { for v in local.level1 : "level1/${v.complete_name}" => v }
  parent   = var.parent_root
  name     = each.value.complete_name
  factories_config = {
    org_policies = each.value.org_policies_data_path != null ? "org-policies-config/folders/${each.value.org_policies_data_path}/" : null
  }
  tag_bindings = each.value.tag_bindings
  depends_on = [ module.org ]

}

module "folder-02" {
  source   = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/folder?ref=v35.0.0"
  for_each = { for v in local.level2 : v.aux_tf_key != null ? "level2/${v.aux_tf_key}-${v.complete_name}" : "level2/${v.complete_name}" => v }
  parent   = module.folder-01["level1/${each.value.parent_complete_name}"].folder.id
  name     = each.value.complete_name
  factories_config = {
    org_policies = each.value.org_policies_data_path != null ? "org-policies-config/folders/${each.value.org_policies_data_path}/" : null
  }
  tag_bindings = each.value.tag_bindings 

}

module "folder-03" {
  source   = "github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/folder?ref=v35.0.0"
  for_each = { for v in local.level3 : v.aux_tf_key != null ? "level3/${v.aux_tf_key}-${v.complete_name}" : "level3/${v.complete_name}" => v }
  parent   = module.folder-02["level2/${each.value.parent_complete_name}"].folder.id
  name     = each.value.complete_name
  factories_config = {
    org_policies = each.value.org_policies_data_path != null ? "org-policies-config/folders/${each.value.org_policies_data_path}/" : null
  }
  tag_bindings = each.value.tag_bindings
}

locals {
  _complete_folder = merge(module.folder-01, module.folder-02, module.folder-03)
  complete-folder  = { for k, v in local._complete_folder : split("/", k)[1] => v.folder.id }
}
