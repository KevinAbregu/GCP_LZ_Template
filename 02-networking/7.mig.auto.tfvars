mig = [
  {
    parent_name       = "cs-net-hub"
    mig_name          = "dns-mig"
    hostname          = "dns-mig"
    instance_template = "instance-template-dns-server"
    target_size       = 1
    region            = "europe-west4"
    health_check_name = "healcheck-dns"
    health_check = {
      type                = "tcp"
      initial_delay_sec   = 30
      check_interval_sec  = 30
      healthy_threshold   = 1
      timeout_sec         = 1
      unhealthy_threshold = 5
      proxy_header        = "NONE"
      port                = 53
      host                = "10.150.0.26"
      enable_logging      = false
    }

    update_policy = [{
      type                           = "PROACTIVE"
      minimal_action                 = "REPLACE"
      most_disruptive_allowed_action = "REPLACE"
      max_surge_fixed                = 0
      max_unavailable_fixed          = 3
      min_ready_sec                  = 50
      replacement_method             = "RECREATE"
      instance_redistribution_type   = "NONE"
    }]
    stateful_ips = [{
      interface_name = "nic0"
      delete_rule    = "NEVER"
      is_external    = false
    }]
  }
]
