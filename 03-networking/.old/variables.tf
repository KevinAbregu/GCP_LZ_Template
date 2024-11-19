variable "instance_template" {
  type = list(object({
    parent_name          = optional(string, null) # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.
    parent_complete_name = optional(string, null) # Project ID
    complete_name        = optional(string, null)
    name_template        = optional(string, null)
    name_prefix          = optional(string, "") # (Optional) Name prefix for the instance template
    access_config = optional(list(object({      #(Optional) Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet.
      nat_ip       = optional(string, null)
      network_tier = optional(string, null)
    })), []),
    additional_disks = optional(list(object({ # (Optional) List of maps of additional disks.
      disk_name       = optional(string, null)
      device_name     = optional(string, null)
      auto_delete     = optional(bool, null)
      boot            = optional(bool, null)
      disk_size_gb    = optional(number, null)
      disk_type       = optional(string, null)
      disk_labels     = optional(map(string), null)
      source_snapshot = optional(string, null)
    })), []),
    additional_networks = optional(list(object({ # (Optional) Additional network interface details for GCE, if any.		
      network            = optional(string, null)
      subnetwork         = optional(string, null)
      subnetwork_project = optional(string, null)
      network_ip         = optional(string, null)
      nic_type           = optional(string, null)
      stack_type         = optional(string, null)
      queue_count        = optional(number, null)
      access_config = optional(list(object({
        nat_ip       = optional(string, null)
        network_tier = optional(string, null)
      })), []),
      ipv6_access_config = optional(list(object({
        network_tier = optional(string, null)
      })), []),
      alias_ip_range = optional(list(object({
        ip_cidr_range         = optional(string, null)
        subnetwork_range_name = optional(string, null)
      })), []),
    })), []),
    alias_ip_range = optional(object({                         # (Required) An array of alias IP ranges for this network interface. Can only be specified for network interfaces on subnet-mode networks.
      ip_cidr_range         = optional(string, null)           # ip_cidr_range: The IP CIDR range represented by this alias IP range. This IP CIDR range must belong to the specified subnetwork 
      subnetwork_range_name = optional(string, null)           # and cannot contain IP addresses reserved by system or used by other network interfaces. At the time of writing only a netmask (e.g. /24) may be supplied, with a CIDR format resulting in an API error.
    }), null),                                                 #  subnetwork_range_name: The subnetwork secondary range name specifying the secondary range from which to allocate the IP CIDR range for this alias IP range. If left unspecified, the primary range of the subnetwork will be used.
    auto_delete                  = optional(string, null)      # (Optional) Whether or not the boot disk should be auto-deleted	
    automatic_restart            = optional(bool, null)        # (Optional) Specifies whether the instance should be automatically restarted if it is terminated by Compute Engine (not terminated by a user).
    can_ip_forward               = optional(string, null)      # (Optional) Enable IP forwarding, for NAT instances for example
    disk_encryption_key          = optional(string, null)      # (Optional) The id of the encryption key that is stored in Google Cloud KMS to use to encrypt all the disks on this instance
    disk_labels                  = optional(map(string), null) # (Optional) Labels to be assigned to boot disk, provided as a map
    disk_size_gb                 = optional(string, null)      # (Required) Boot disk size in GB
    disk_type                    = optional(string, null)      # (Required) Boot disk type, can be either pd-ssd, local-ssd, or pd-standard
    enable_confidential_vm       = optional(bool, false)       # (Optional) Whether to enable the Confidential VM configuration on the instance. Note that the instance image must support Confidential VMs.
    enable_nested_virtualization = optional(bool, null)        # (Optional) Defines whether the instance should have nested virtualization enabled.
    enable_shielded_vm           = bool                        # (Required) Whether to enable the Shielded VM configuration on the instance. Note that the instance image must support Shielded VMs.
    gpu = optional(object({                                    # (Optional) GPU information. Type and count of GPU to attach to the instance template.
      type  = optional(string, null)
      count = optional(string, null)
    }), null),
    ipv6_access_config = optional(list(object({ # (Optional) Pv6 access configurations. Currently a max of 1 IPv6 access configuration is supported. If not specified, the instance will have no external IPv6 Internet access.
      network_tier = optional(string, null)
    })), []),
    labels               = optional(map(string), null) # (Optional) Labels, provided as a map
    machine_type         = string                      # (Required) Machine type to create, e.g. n1-standard-1	
    maintenance_interval = optional(string, null)      # (Optional) Specifies the frequency of planned maintenance events
    metadata             = optional(map(string), null) # (Optional) Metadata, provided as a map
    min_cpu_platform     = optional(string, null)      # (Optional) Specifies a minimum CPU platform. Applicable values are the friendly names of CPU platforms, such as Intel Haswell or Intel Skylake. 
    network              = optional(string, null)      # (Required) The name or self_link of the network to attach this interface to. Use network attribute for Legacy or Auto subnetted networks and subnetwork for custom subnetted networks.
    network_ip           = optional(string, "")        # (Optional) Private IP address to assign to the instance if desired.	
    nic_type             = optional(string, null)      # (Optional) Valid values are "VIRTIO_NET", "GVNIC" or set to null to accept API default behavior.
    on_host_maintenance  = optional(string, null)      # (Optional) Instance availability Policy
    preemptible          = optional(bool, false)       # (Optional) Allow the instance to be preempted
    project_id           = optional(string, null)      # (Required) The GCP project ID
    region               = string                      # (Required) Region where the instance template should be created.
    resource_policies    = optional(list(string), []), # (Optional) A list of self_links of resource policies to attach to the instance. Modifying this list will cause the instance to recreate. Currently a max of 1 resource policy is supported.
    service_account = object({                         # (Required) Service account to attach to the instance.
      email  = optional(string, "")
      scopes = optional(set(string), [])
    }),
    shielded_instance_config = optional(object({ # (Optional) Not used unless enable_shielded_vm is true. Shielded VM configuration for the instance.	
      enable_secure_boot          = optional(bool, null)
      enable_vtpm                 = optional(bool, null)
      enable_integrity_monitoring = optional(bool, null)
    }), null),
    source_image                     = optional(string, "")        # (Optional) Source disk image. If neither source_image nor source_image_family is specified, defaults to the latest public Rocky Linux 9 optimized for GCP image.
    source_image_family              = optional(string, "")        # (Optional) Source image family. If neither source_image nor source_image_family is specified, defaults to the latest public Rocky Linux 9 optimized for GCP image.
    source_image_project             = optional(string, "")        # (Optional) Project where the source image comes from. The default project contains Rocky Linux images.
    spot                             = optional(bool, false)       # (Optional) Provision a SPOT instance
    spot_instance_termination_action = optional(string, "STOP")    # (Optional) Action to take when Compute Engine preempts a Spot VM.
    stack_type                       = optional(string, null)      # (Optional) The stack type for this network interface to identify whether the IPv6 feature is enabled or not. Values are IPV4_IPV6 or IPV4_ONLY. Default behavior is equivalent to IPV4_ONLY.
    startup_script                   = optional(string, null)      # (Optional) User startup script to run when instances spin up
    subnetwork                       = optional(string, null)      # (Required) The name of the subnetwork to attach this interface to. The subnetwork must exist in the same region this instance will be created in. Either network or subnetwork must be provided.
    subnetwork_project               = optional(string, null)      # (Optional) The ID of the project in which the subnetwork belongs. If it is not provided, the provider project is used.
    tags                             = optional(list(string), []), # (Optional) Network tags, provided as a list
    threads_per_core                 = optional(number, null)      # (Optional) The number of threads per physical core. To disable simultaneous multithreading (SMT) set this to 1.
    total_egress_bandwidth_tier      = optional(string, "DEFAULT") # (Optional) Egress bandwidth tier setting for supported VM families
  }))
  default     = []
  description = "Instance Template creation."
}

variable "mig" {

  type = list(object({
    parent_name          = optional(string, null), # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.
    parent_complete_name = optional(string, null), # Project ID
    complete_name        = optional(string, null),
    mig_name             = optional(string, ""),   # (Optional) Managed instance group name. When variable is empty, name will be derived from var.hostname.	
    autoscaler_name      = optional(string, null), # (Optional) Autoscaler name. When variable is empty, name will be derived from var.hostname.
    autoscaling_cpu = optional(list(object({       # (Optional) Autoscaling, cpu utilization policy block as single element array.
      target            = optional(string)
      predictive_method = optional(string)
    })), null),
    autoscaling_enabled = optional(string, "false"),         # (Optional) Creates an autoscaler for the managed instance group
    autoscaling_lb      = optional(list(map(number)), null), # (Optional) Autoscaling, load balancing utilization policy block as single element array.
    autoscaling_metric = optional(list(object({              # (Optional) Autoscaling, metric policy block as single element array.
      name   = optional(string)
      target = optional(number)
      type   = optional(string)
    })), null),
    autoscaling_mode = optional(string, null),       # (Optional) Operating mode of the autoscaling policy. If omitted, the default value is ON.
    autoscaling_scale_in_control = optional(object({ # (Optional) Autoscaling, scale-in control block.
      fixed_replicas   = optional(number, null)
      percent_replicas = optional(number, null)
      time_window_sec  = optional(number, null)
    }), {}),
    cooldown_period                  = optional(number, null),       # (Optional) The number of seconds that the autoscaler should wait before it starts collecting information from a new instance.
    distribution_policy_target_shape = optional(string, null),       # (Optional) MIG target distribution shape (EVEN, BALANCED, ANY, ANY_SINGLE_ZONE)
    distribution_policy_zones        = optional(list(string), null), # (Optional) The distribution policy, i.e. which zone(s) should instances be create in. Default is all zones in given region.
    health_check = optional(object({                                 # (Optional) Health check to determine whether instances are responsive and able to do work
      type                = optional(string, null)
      initial_delay_sec   = optional(number, null)
      check_interval_sec  = optional(number, null)
      healthy_threshold   = optional(number, null)
      timeout_sec         = optional(number, null)
      unhealthy_threshold = optional(number, null)
      response            = optional(string, null)
      proxy_header        = optional(string, null)
      port                = optional(number, null)
      request             = optional(string, null)
      request_path        = optional(string, null)
      host                = optional(string, null)
      enable_logging      = optional(bool, null)
    }), {}),
    health_check_name = optional(string, null),      # (Optional: mandatory if a healcheck is defined) Health check name. When variable is empty, name will be derived from var.hostname.	
    hostname          = optional(string, ""),        # (Optional) Hostname prefix for instances	
    instance_template = string                       # (Required) Instance template self_link used to create compute instances
    labels            = optional(map(string), null), # (Optional) Labels, provided as a map
    max_replicas      = optional(number, null),      # (Optional) The maximum number of instances that the autoscaler can scale up to. This is required when creating or updating an autoscaler. The maximum number of replicas should not be lower than minimal number of replicas.	
    mig_timeouts = optional(object({                 # (Optional) Times for creation, deleting and updating the MIG resources. Can be helpful when using wait_for_instances to allow a longer VM startup time.	
      create = optional(string, null)
      delete = optional(string, null)
      update = optional(string, null)
    }), {}),
    min_replicas = optional(number, null), # (Optional) The minimum number of replicas that the autoscaler can scale down to. This cannot be less than 0.	
    named_ports = optional(list(object({   # (Optional) Named name and named port.
      name = optional(string)
      port = optional(number)
    })), []),
    project_id = optional(string, null),       # (Required) The GCP project ID
    region     = string,                       # (Required) The GCP region where the managed instance group resides.
    scaling_schedules = optional(list(object({ # (Optional) Autoscaling, scaling schedule block.
      disabled              = optional(bool)
      duration_sec          = optional(number)
      min_required_replicas = optional(number)
      name                  = optional(string)
      schedule              = optional(string)
      time_zone             = optional(string)
    })), null),

    stateful_disks = optional(list(object({ # (Optional) Disks created on the instances that will be preserved on instance delete.
      device_name = optional(string)
      delete_rule = optional(string)
    })), []),


    stateful_ips = optional(list(object({ # (Optional) Statful IPs created on the instances that will be preserved on instance delete.
      interface_name = optional(string)
      delete_rule    = optional(string)
      is_external    = optional(bool)
    })), null),

    target_pools = optional(list(string), null), # (Optional) The target load balancing pools to assign this group to.
    target_size  = optional(number, null),       # (Optional) The target number of running instances for this managed instance group. This value should always be explicitly set unless this resource is attached to an autoscaler, in which case it should never be set.	
    update_policy = optional(list(object({       # (Required if stateful attributes are defined) The rolling update policy.
      max_surge_fixed                = optional(number, null)
      instance_redistribution_type   = optional(string, null)
      max_surge_percent              = optional(number, null)
      max_unavailable_fixed          = optional(number, null)
      max_unavailable_percent        = optional(number, null)
      min_ready_sec                  = optional(number, null)
      replacement_method             = optional(string, null)
      minimal_action                 = optional(string, null)
      type                           = optional(string, null)
      most_disruptive_allowed_action = optional(string, null)
    })), []),
    wait_for_instances = optional(string, null), # (Optional) Whether to wait for all instances to be created/updated before returning. Note that if this is set to true and the operation does not succeed, Terraform will continue trying until it times out.	
  }))

  default     = []
  description = "Mig creation."
}
