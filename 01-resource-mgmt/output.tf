
output "buckets" {
  value = [for k, v in module.bucket : v.id]
}

output "projects" {
  value = [for k, v in module.project : v.id]
}

output "folders" {
  value = local.complete-folder
}

output "fldr_prefix" {
  value = var.fldr_prefix
}

output "parent_root" {
  value = var.parent_root
}