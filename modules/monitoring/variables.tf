variable "monitoring_project_id" {
  description = "ID of the monitoring project"
  type        = string
} 

variable "monitored_projects_id" {
  description = "Monitored projects ID"
  type        = list(string)
}


# Dashboards configuration
variable "dashboard_configs" {
  description = "Configuration of dashboards"
  type        = map(string)
  default     = {
    # Compute Engine Dashboards
    dashboard1 = "gce-autoscaler-monitoring.json"
    dashboard2 = "gce-reservations-monitoring.json"
    dashboard3 = "gce-vm-instance-monitoring.json"
    dashboard4 = "gce-vm-lifecycle-dashboard.json"

    # Kubernetes Dashboards
    dashboard5 = "gke-active-idle-clusters.json"
    dashboard6 = "gke-cluster-monitoring.json"
    dashboard7 = "gke-compute-resources-cluster-view.json"
    dashboard8 = "gke-compute-resources-node-view.json"
    dashboard9 = "gke-compute-resources-workload-view.json"
    dashboard10 = "gke-nodes-pods-cluster-view.json"
    dashboard11 = "gke-optimization-signals.json"
    dashboard12 = "gke-workloads-at-risk.json"

    # Storage Dashboards
    dashboard13 = "bigtable-monitoring.json" 
    dashboard14 = "cloud-storage-monitoring.json"
    dashboard15 = "cloudsql-monitoring.json" 
    dashboard16 = "cloudsql-mysql-monitoring.json" 
    dashboard17 = "cloudsql-postgre-monitoring.json" 
    dashboard18 = "datastore-monitoring.json" 
    dashboard19 = "firestore-monitoring.json" 
    dashboard20 = "memcache-monitoring.json" 
    dashboard21 = "redis-ops-monitoring.json" 
    dashboard22 = "redis-stats-monitoring.json" 
    dashboard23 = "spanner-monitoring.json" 

    # Load Balancer Dashboards
    dashboard24 = "https-loadbalancer-monitoring.json"
    dashboard25 = "https-lb-backend-services-monitoring.json"
    dashboard26 = "network-tcp-loadbalancer-monitoring.json"
    dashboard27 = "network-udp-loadbalancer-monitoring.json"
    dashboard28 = "tcp-ssl-loadbalancer-monitoring.json"

    # Cloud SQL Dashboards
    dashboard29 = "cloudsql-general.json"
    dashboard30 = "cloudsql-replication.json"
    dashboard31 = "cloudsql-transactions.json"

    # Example dashboard: GCE and GCS
    dashboard32 = "test-gce-gcs-dashboard.json"
   
  }
}

variable "email_notification" {
  description = "Email address for alerting notifications"
  type        = string
}