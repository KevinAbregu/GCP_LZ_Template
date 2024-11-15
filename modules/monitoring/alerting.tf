# High use of CPU for VMs (more than 99% of CPU during 30 min)
resource "google_monitoring_alert_policy" "cpu_utilization" {
  project      = var.monitoring_project_id
  display_name = "VM Instance - High CPU Utilization"
  combiner     = "OR"
  conditions {
    display_name = "VM Instance - High CPU Utilization"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "1800s" # 30 min
      filter          = "resource.type = \"gce_instance\" AND metric.type = \"compute.googleapis.com/instance/cpu/utilization\""
      threshold_value = "99" # 99%
      trigger {
        count = "1"
      }
    }
  }

  # For repeated notifications every period of time (1800s = 30 min)
  alert_strategy {
    notification_channel_strategy {
      renotify_interval = "1800s"
      # notification_channel_names = [google_monitoring_notification_channel.email.name]
    }
  }

  # notification_channels = [google_monitoring_notification_channel.email.name] */

  user_labels = {
    # severity = "warning"
  }
}


# High use of Memory for VMs (more than 99% of Memory during 30 min)
resource "google_monitoring_alert_policy" "memory_utilization" {
  project      = var.monitoring_project_id
  display_name = "VM Instance - High Memory Utilization"
  combiner     = "OR"
  conditions {
    display_name = "VM Instance - High Memory Utilization"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "1800s" # 30min
      filter          = "resource.type = \"gce_instance\" AND metric.type = \"agent.googleapis.com/memory/percent_used\" AND metric.labels.state = \"used\""
      threshold_value = "99" # 99%
      trigger {
        count = "1"
      }
    }
  }

  # For repeated notifications every period of time (1800s = 30 min)
  alert_strategy {
    notification_channel_strategy {
      renotify_interval = "1800s"
      #notification_channel_names = [google_monitoring_notification_channel.email.name]
    }
  }

  #notification_channels = [google_monitoring_notification_channel.email.name]

  user_labels = {
    # severity = "warning"
  }
}


# High use of Disks for VMs (more than 90% of Disk use during 30 min)
resource "google_monitoring_alert_policy" "disk_utilization" {
  project      = var.monitoring_project_id
  display_name = "VM Instance - High Disk Utilization"
  combiner     = "OR"
  conditions {
    display_name = "VM Instance - High Disk Utilization"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "1800s" # 30min
      filter          = "resource.type = \"gce_instance\" AND metric.type = \"agent.googleapis.com/disk/percent_used\" AND metric.labels.state = \"used\""
      threshold_value = "90" # 90%
      trigger {
        count = "1"
      }
    }
  }

  # For repeated notifications every period of time (1800s = 30 min)
  alert_strategy {
    notification_channel_strategy {
      #renotify_interval = "1800s"
      #notification_channel_names = [google_monitoring_notification_channel.email.name]
    }
  }

  #notification_channels = [google_monitoring_notification_channel.email.name] 

  user_labels = {
    # severity = "warning"
  }
}



# Low availability of resources in GKE Clusters ??? 
# Alternatives...

# High CPU utilization in containers within a cluster (more than 90% for 5 min)
resource "google_monitoring_alert_policy" "cpu_utilization_cluster" {
  project      = var.monitoring_project_id
  display_name = "GKE Container - High CPU Limit Utilization (_name of the cluster_)"
  combiner     = "OR"
  conditions {
    display_name = "GKE container in _name of the cluster_ cluster has high CPU limit utilization"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "300s" # 5min
      filter          = "resource.type = \"k8s_container\" AND metric.type = \"kubernetes.io/container/cpu/limit_utilization\" AND resource.labels.cluster_name=\"_name of the cluster_\" AND resource.labels.location=\"_name of the cluster_\""
      threshold_value = "90" # 90%
      trigger {
        count = "1"
      }
    }
  }

  # For repeated notifications every period of time (1800s = 30 min)
  alert_strategy {
    notification_channel_strategy {
      renotify_interval = "1800s"
      #notification_channel_names = [google_monitoring_notification_channel.email.name]
    }
  }

  #notification_channels = [google_monitoring_notification_channel.email.name] 

  user_labels = {
    # severity = "warning"
  }
}



# High memory utilization in containers within a cluster (more than 90% for 1 min)
resource "google_monitoring_alert_policy" "memory_utilization_cluster" {
  project      = var.monitoring_project_id
  display_name = "GKE Container - High Memory Limit Utilization (_name of the cluster_ cluster)"
  combiner     = "OR"
  conditions {
    display_name = "GKE container in _name of the cluster_ cluster has high memory limit utilization"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "60s" # 1min
      filter          = "resource.type = \"k8s_container\" AND metric.type = \"kubernetes.io/container/memory/limit_utilization\" AND resource.labels.cluster_name=\"_name of the cluster_\" AND resource.labels.location=\"_name of the cluster_\""
      threshold_value = "90" # 90%
      trigger {
        count = "1"
      }
    }
  }

  # For repeated notifications every period of time (1800s = 30 min)
  alert_strategy {
    notification_channel_strategy {
      renotify_interval = "1800s"
      # notification_channel_names = [google_monitoring_notification_channel.email.name]
    }
  }

  # notification_channels = [google_monitoring_notification_channel.email.name] 

  user_labels = {
    # severity = "warning"
  }
}



# In the event of failure scheduling a pod
resource "google_monitoring_alert_policy" "pod_scheduling_failure" {
  project      = var.monitoring_project_id
  display_name = "GKE Pod - FailedScheduling Log Event"
  combiner     = "OR"
  conditions {
    display_name = "GKE Pod - FailedScheduling Log Event (_name of the cluster_)"
    condition_matched_log {
      filter = "resource.type=\"k8s_pod\" AND resource.labels.cluster_name=\"_name of the cluster_\" AND jsonPayload.reason=\"FailedScheduling\""
    }
  }

  # For repeated notifications every period of time (1800s = 30 min)
  alert_strategy {
    # Notification rate limit is required for alert policies with a LogMatch condition
    notification_rate_limit { # 
      period = "300s"         # One notification per 5 min
    }
  }

  # notification_channels = [google_monitoring_notification_channel.email.name] 

  user_labels = {
    # severity = "warning"
  }
}



# Low available space in Cloud SQL Database ???
# Alternative ... 

resource "google_monitoring_alert_policy" "sql_failed" {
  project      = var.monitoring_project_id
  display_name = "CloudSQL - Instance in Failed State"
  combiner     = "OR"
  conditions {
    display_name = "Cloud SQL Database - Instance state"
    condition_threshold {
      comparison      = "COMPARISON_GT"
      duration        = "0s"
      filter          = "resource.type = \"cloudsql_database\" AND metric.type = \"cloudsql.googleapis.com/database/instance_state\" AND metric.labels.state = \"FAILED\""
      threshold_value = 1
      trigger {
        count = "1"
      }
    }
  }

  # For repeated notifications every period of time (1800s = 30 min)
  alert_strategy {
    notification_channel_strategy {
      renotify_interval = "1800s"
      # notification_channel_names = [google_monitoring_notification_channel.email.name]
    }
  }

  # notification_channels = [google_monitoring_notification_channel.email.name] 

  user_labels = {
    # severity = "warning"
  }
}


# High bandwidth use in Cloud VPN 
resource "google_monitoring_alert_policy" "vpn_bw" {
  project      = var.monitoring_project_id
  display_name = "CloudVPN - High VPN tunnel bps"
  combiner     = "OR"
  conditions {
    display_name = "CloudVPN - Tunnel traffic"
    condition_monitoring_query_language {
      query = join("", [
        "fetch vpn_gateway",
        "| {metric 'vpn.googleapis.com/network/sent_bytes_count'",
        "; metric 'vpn.googleapis.com/network/received_bytes_count'}",
        "| align rate (30s)",
        "| group_by [metric.tunnel_name]",
        "| outer_join 0,0",
        "| value val(0) + val(1)",
      "| condition val() > 262.5 \"MBy/s\""]) # 70% of 3 Gbps = 262.5 MBbs
      duration = "300s"                       # trigger alert if condition lasts more than 5 min
      trigger {
        count = "1"
      }
    }
  }


  # For repeated notifications every period of time (1800s = 30 min)
  alert_strategy {
    notification_channel_strategy {
      renotify_interval = "1800s"
      # notification_channel_names = [google_monitoring_notification_channel.email.name]
    }
  }

  # notification_channels = [google_monitoring_notification_channel.email.name] 

  user_labels = {
    # severity = "warning"
  }
}


# High bandwidth use in Cloud Interconnect (ingress)
resource "google_monitoring_alert_policy" "interconnect_ingress_bw" {
  project      = var.monitoring_project_id
  display_name = "Cloud Interconnect - High interconnect ingress"
  combiner     = "OR"
  conditions {
    display_name = "Cloud Interconnect - VLAN attachment ingress usage"
    condition_monitoring_query_language {
      query = join("", [
        "fetch interconnect_attachment",
        "| {metric 'interconnect.googleapis.com/network/attachment/received_bytes_count'",
        "| align rate(30s)",
        "; metric 'interconnect.googleapis.com/network/attachment/capacity'",
        "| group_by 30s, [value_capacity_mean: mean(value.capacity)]}",
        "| ratio",
      "| condition gt(val(), 0.70 '1')"])
      duration = "300s" # trigger alert if condition lasts more than 5 min
      trigger {
        count = "1"
      }
    }
  }

  # For repeated notifications every period of time (1800s = 30 min)
  alert_strategy {
    notification_channel_strategy {
      renotify_interval = "1800s"
      # notification_channel_names = [google_monitoring_notification_channel.email.name]
    }
  }

  # notification_channels = [google_monitoring_notification_channel.email.name] 

  user_labels = {
    # severity = "warning"
  }
}


# High bandwidth use in Cloud Interconnect (egress)
resource "google_monitoring_alert_policy" "interconnect_egress_bw" {
  project      = var.monitoring_project_id
  display_name = "Cloud Interconnect - High interconnect egress"
  combiner     = "OR"
  conditions {
    display_name = "Cloud Interconnect - VLAN attachment egress usage"
    condition_monitoring_query_language {
      query = join("", [
        "fetch interconnect_attachment",
        "| {metric 'interconnect.googleapis.com/network/attachment/sent_bytes_count'",
        "| align rate(30s)",
        "; metric 'interconnect.googleapis.com/network/attachment/capacity'",
        "| group_by 30s, [value_capacity_mean: mean(value.capacity)]}",
        "| ratio",
      "| condition gt(val(), 0.70 '1')"])
      duration = "0s"
      trigger {
        count = "1"
      }
    }
  }

  # For repeated notifications every period of time (1800s = 30 min)
  alert_strategy {
    notification_channel_strategy {
      renotify_interval = "1800s"
      # notification_channel_names = [google_monitoring_notification_channel.email.name]
    }
  }

  # notification_channels = [google_monitoring_notification_channel.email.name] 

  user_labels = {
    # severity = "warning"
  }
}



# Uptime check for HTTP
resource "google_monitoring_uptime_check_config" "http" {
  project = var.monitoring_project_id
  display_name = "http-uptime-check"
  timeout      = "60s"

  http_check {
    path           = "/"  # The page to run the check against
    port           = "80" # The port to the page to run the check against
    request_method = "POST"  # The HTTP request method to use for the check
    content_type   = "URL_ENCODED" # The content tupe to use for the check
    body           = "Zm9vJTI1M0RiYXI=" # The request body associated with the HTTP POST request
  }

  monitored_resource {
    type = "uptime_url" # The monitored resource type
    labels = { # Values for all of the labels listed in the associated monitored resource descriptor.
      project_id = var.monitoring_project_id
      host       = "192.168.1.1"
    }
  }

  # The expected content on the page the check is run against. 
  content_matchers {
    content = "\"example\"" # String content to match
    matcher = "MATCHES_JSON_PATH" # The type of content matcher that will be applied to the server output
    json_path_matcher { #  Information needed to perform a JSONPath content match
      json_path    = "$.path"
      json_matcher = "EXACT_MATCH"
    }
  }

  checker_type = "STATIC_IP_CHECKERS" # The checker type to use for the check
}


# Uptime check for HTTPS
resource "google_monitoring_uptime_check_config" "https" {
  project = var.monitoring_project_id
  display_name = "https-uptime-check"
  timeout = "60s"

  http_check {
    path = "/some-path"
    port = "443"
    use_ssl = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.monitoring_project_id
      host = "192.168.1.1"
    }
  }

  content_matchers {
    content = "example"
    matcher = "MATCHES_JSON_PATH"
    json_path_matcher {
      json_path = "$.path"
      json_matcher = "REGEX_MATCH"
    }
  }
}

# Uptime check for TCP
resource "google_monitoring_uptime_check_config" "tcp_group" {
  project = var.monitoring_project_id
  display_name = "tcp-uptime-check"
  timeout      = "60s"

  tcp_check {
    port = 888
  }

  resource_group {
    resource_type = "INSTANCE"
    group_id      = google_monitoring_group.check.name
  }
}

resource "google_monitoring_group" "check" {
  project = var.monitoring_project_id
  display_name = "uptime-check-group"
  filter       =  "resource.metadata.region=\"europe-southwest1\""
}



# Create notification channel (email)
resource "google_monitoring_notification_channel" "email" {
  project      = var.monitoring_project_id
  display_name = "Test Notification Channel"
  type         = "email"
  labels = {
    email_address = var.email_notification
  }
  force_delete = false
}  
