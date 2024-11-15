

# Use Monitoring Module
module "monitoring" {
  source                = "../../modules/monitoring"
  monitoring_project_id = var.monitoring_project_id
  monitored_projects_id = var.monitored_projects_id
  email_notification    = var.email_notification
}

