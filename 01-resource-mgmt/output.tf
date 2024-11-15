output "service-accounts" {
  value = [for k, v in module.service-account : v.email]
}

output "buckets" {
  value = [for k, v in module.bucket : v.id]
}

output "projects" {
  value = [for k, v in module.project : v.id]
}

output "folders" {
  value = local.complete-folder
}