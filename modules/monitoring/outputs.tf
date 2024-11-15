# Monitoring project ID
output "monitoring_project_id" {
  value = var.monitoring_project_id
}

# Dashboard resource ID
output "resource_id" {
  description = "The resource id for the dashboard"
  value = [for dashboard in values(google_monitoring_dashboard.dashboard) : dashboard.id]
}

# Dashboard URL destination
output "console_link" {
  description = "The destination console URL for the dashboard"
  value       = {
    for key, dashboard in google_monitoring_dashboard.dashboard:
      key => join("", ["https://console.cloud.google.com/monitoring/dashboards/custom/",
                          element(split("/", dashboard.id), 3),
                          "?project=",
                          var.monitoring_project_id])
      
  }
}