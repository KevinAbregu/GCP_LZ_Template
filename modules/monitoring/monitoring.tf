# Add monitored projects to the monitoring project
resource "google_monitoring_monitored_project" "projects_monitored" {
  for_each      = toset(var.monitored_projects_id)
  metrics_scope = join("", ["locations/global/metricsScopes/", var.monitoring_project_id])
  name          = each.value
}

# Monitoring dashboards
resource "google_monitoring_dashboard" "dashboard" {
  for_each       = var.dashboard_configs
  project        = var.monitoring_project_id
  dashboard_json = file("${path.module}/dashboards/${each.value}")

}

