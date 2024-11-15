# Fetch outputs from the monitoring module
output "project_id" {
  description = "Monitoring project ID"
  value = var.monitoring_project_id
}

output "resource_id" {
  description = "The resource id for the dashboard"
  value = module.monitoring.resource_id
}

output "console_link" {
  description = "The destination console URL for the dashboard."
  value = module.monitoring.console_link
}


