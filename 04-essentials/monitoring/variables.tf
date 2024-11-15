variable "monitoring_project_id" {
  description = "ID of the monitoring project"
  type        = string
}

variable "monitored_projects_id" {
  description = "IDs of the projects to be monitored"
  type        = list(string)
}

variable "email_notification" {
  description = "Email address for alerting notifications"
  type        = string
}