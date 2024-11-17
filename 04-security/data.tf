data "google_projects" "default" {
  filter = local.perimeters_parents_folders_query
}

data "google_cloud_identity_group_memberships" "default" {
  for_each = local.perimeters_groups_list
  group    = "groups/${each.key}"
}
#

