variable "vpc_prefix" {
  type        = string
  description = "VPC prefix following naming convention"
  default     = "vpc"
}

variable "subnet_prefix" {
  type        = string
  description = "Subnet prefix following naming convention"
  default     = "snet"
}

variable "router_prefix" {
  type        = string
  description = "Router prefix following naming convention"
  default     = "cr"
}

variable "nat_prefix" {
  type        = string
  description = "Nat prefix following naming convention"
  default     = "nat"
}

variable "vpn_prefix" {
  type        = string
  description = "VPN prefix following naming convention"
  default     = "vpn"
}

variable "dns_prefix" {
  type        = string
  description = "DNS prefix following naming convention"
  default     = "dns"
}

variable "instance_template_prefix" {
  type        = string
  description = "Instance Template prefix following naming convention"
  default     = "instance-template"
}

variable "mig_prefix" {
  type        = string
  description = "MIG prefix following naming convention"
  default     = "mig"
}


variable "networks" {
  type = list(object(
    {
      parent_name          = optional(string, null),        # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.
      parent_complete_name = optional(string, null),        # Project ID.
      name                 = optional(string, null),        # (When complete_name is not specified) Completed with '[VPC_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.
      complete_name        = optional(string, null),        # VPC Name.
      routing_mode         = optional(string, "GLOBAL")     # The network routing mode (default 'GLOBAL')
      subnets = list(object({                               # list of subnets being created
        subnet_name                      = optional(string) # (When subnet_complete_name is not specified) Completed with '[SUBNET_PREFIX]-[COMPANY_ABBREVIATION]-[SUBNET_NAME]'.
        subnet_complete_name             = optional(string) # Subnet Name
        subnet_ip                        = string
        subnet_region                    = optional(string)
        subnet_private_access            = optional(string, "false")
        subnet_private_ipv6_access       = optional(string) # Possible values "EXTERNAL", "INTERNAL"
        subnet_flow_logs                 = optional(string)
        subnet_flow_logs_interval        = optional(string)
        subnet_flow_logs_sampling        = optional(string)
        subnet_flow_logs_metadata        = optional(string)
        subnet_flow_logs_filter          = optional(string)
        subnet_flow_logs_metadata_fields = optional(list(string))
        description                      = optional(string)
        purpose                          = optional(string) # Possible values "PRIVATE_RFC_1918", "REGIONAL_MANAGED_PROXY", "GLOBAL_MANAGED_PROXY", "PRIVATE_SERVICE_CONNECT", "PRIVATE_NAT"
        role                             = optional(string) # Possible values "ACTIVE" , "BACKUP". Only used when purpose is REGIONAL_MANAGED_PROXY
        stack_type                       = optional(string)
        ipv6_access_type                 = optional(string)
      }))
      secondary_ranges                       = optional(map(list(object({ range_name = string, ip_cidr_range = string }))), {}) # { range_name = SUBNET_NAME, ip_cidr_range = secondary range}
      routes                                 = optional(list(map(string)), [])                                                  # List of routes being created in this VPC
      delete_default_internet_gateway_routes = optional(bool, false)                                                            # If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted
      description                            = optional(string, "Managed by Terraform")
      auto_create_subnetworks                = optional(bool, false) # When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources.
      mtu                                    = optional(number, 0)   # The network MTU (If set to 0, meaning MTU is unset - defaults to '1460'). Recommended values: 1460 (default for historic reasons), 1500 (Internet default), or 8896 (for Jumbo packets). Allowed are all values in the range 1300 to 8896, inclusively.
      ingress_rules = optional(list(object({                         # List of ingress rules. This will be ignored if variable 'rules' is non-empty
        name                    = string                             # Firewall Name
        description             = optional(string, null)
        disabled                = optional(bool, null)
        priority                = optional(number, null)
        destination_ranges      = optional(list(string), [])
        source_ranges           = optional(list(string), [])
        source_tags             = optional(list(string))
        source_service_accounts = optional(list(string))
        target_tags             = optional(list(string))
        target_service_accounts = optional(list(string))

        allow = optional(list(object({ # Allow conditions
          protocol = string            # Possible values: "TCP", "UDP", "ICMP", "ESP", "AH", "SCTP", "IPIP", "ALL" or a number.
          ports    = optional(list(string))
        })), [])
        deny = optional(list(object({ # Deny conditions
          protocol = string           # Possible values: "TCP", "UDP", "ICMP", "ESP", "AH", "SCTP", "IPIP", "ALL" or a number.
          ports    = optional(list(string))
        })), [])
        log_config = optional(object({
          metadata = string
        }))
      })), [])
      egress_rules = optional(list(object({ # List of egress rules. This will be ignored if variable 'rules' is non-empty
        name                    = string    # Firewall Name
        description             = optional(string, null)
        disabled                = optional(bool, null)
        priority                = optional(number, null)
        destination_ranges      = optional(list(string), [])
        source_ranges           = optional(list(string), [])
        source_tags             = optional(list(string))
        source_service_accounts = optional(list(string))
        target_tags             = optional(list(string))
        target_service_accounts = optional(list(string))

        allow = optional(list(object({ # Allow conditions
          protocol = string            # Possible values: "TCP", "UDP", "ICMP", "ESP", "AH", "SCTP", "IPIP", "ALL" or a number.
          ports    = optional(list(string))
        })), [])
        deny = optional(list(object({ # Deny conditions
          protocol = string           # Possible values: "TCP", "UDP", "ICMP", "ESP", "AH", "SCTP", "IPIP", "ALL" or a number.
          ports    = optional(list(string))
        })), [])
        log_config = optional(object({
          metadata = string
        }))
      })), [])
    }
  ))
  default     = []
  description = "VPC creation, including Subnets, Routes and Firewall"
}

variable "peerings" {
  type = list(object({
    local_network_name          = optional(string, null) # (When local_network_complete_name is not specified) Completed with '[VPC_PREFIX]-[COMPANY_ABBREVIATION]-[LOCAL_NETWORK_NAME]'.
    local_network_complete_name = optional(string, null) # Local VPC network name.
    peer_network_name           = optional(string, null) # (When peer_network_complete_name is not specified) Completed with '[VPC_PREFIX]-[COMPANY_ABBREVIATION]-[PEER_NETWORK_NAME]'.
    peer_network_complete_name  = optional(string, null) # Peer VPC network name.
    local_project_name          = optional(string, null) # (When local_project_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[LOCAL_PROJECT_NAME]'.
    local_project_complete_name = optional(string, null) # Local Project ID
    peer_project_name           = optional(string, null) # (When peer_project_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PEER_PROJECT_NAME]'.
    peer_project_complete_name  = optional(string, null) # Peer Project ID.

    export_peer_custom_routes                 = optional(bool, true) # Export custom routes to local network from peer network.
    export_local_custom_routes                = optional(bool, true) # Export custom routes to peer network from local network.
    export_peer_subnet_routes_with_public_ip  = optional(bool, true) # Export custom routes to local network from peer network
    export_local_subnet_routes_with_public_ip = optional(bool, true) # Export custom routes to peer network from local network
    stack_type                                = optional(string, "IPV4_ONLY")
  }))
  default     = []
  description = "Peering between VPCs indicated."

}

variable "iam_subnets" {
  type = list(object({
    parent_name          = optional(string, null), # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.
    parent_complete_name = optional(string, null), # Project ID
    subnet_name          = optional(string, null), # (When subnet_complete_name is not specified) Completed with '[SUBNET_PREFIX]-[COMPANY_ABBREVIATION]-[SUBNET_NAME]'.
    subnet_complete_name = optional(string, null), # Subnet name
    member               = string                  # Identities that will be granted the role. Possible values: "allUsers", "allAuthenticatedUsers", "user:{emailid}", "serviceAccount:{emailid}", "group:{emailid}"
    region               = optional(string, null)
  }))
  default     = []
  description = "Role of Compute Network User to the members indicated"
}

variable "routers" {
  type = list(object({
    parent_name           = optional(string, null), # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.
    parent_complete_name  = optional(string, null), # Project ID.
    name                  = optional(string, null), # (When complete_name is not specified) Completed with '[ROUTER_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.
    complete_name         = optional(string, null), # Router Name.
    network_name          = optional(string, null)  # (When network_complete_name is not specified) Completed with '[VPC_PREFIX]-[COMPANY_ABBREVIATION]-[NETWORK_NAME]'.
    network_complete_name = optional(string, null)  # VPC name.
    region                = optional(string, null)
    description           = optional(string, "Managed by Terraform")
    bgp = optional(object({
      asn               = string
      advertise_mode    = optional(string, "CUSTOM")
      advertised_groups = optional(list(string))
      advertised_ip_ranges = optional(list(object({
        range       = string
        description = optional(string)
      })), [])
      keepalive_interval = optional(number)
    }), null)
  }))
  default     = []
  description = "Cloud Routers creation."
}

variable "nats" {
  type = list(object({
    parent_name                        = optional(string, null), # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.
    parent_complete_name               = optional(string, null), # Project ID
    name                               = optional(string, null), # (When complete_name is not specified) Completed with '[NAT_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.
    complete_name                      = optional(string, null), # NAT name
    region                             = optional(string, null),
    icmp_idle_timeout_sec              = optional(string, "30"),
    min_ports_per_vm                   = optional(string, "64"),
    max_ports_per_vm                   = optional(string, null),
    nat_ips                            = optional(list(string), []),
    router_name                        = optional(string, null),                            # (When router_complete_name is not specified) Completed with '[ROUTER_PREFIX]-[COMPANY_ABBREVIATION]-[ROUTER_NAME]'.
    router_complete_name               = optional(string, null),                            # Router name
    source_subnetwork_ip_ranges_to_nat = optional(string, "ALL_SUBNETWORKS_ALL_IP_RANGES"), # Possible values: "ALL_SUBNETWORKS_ALL_IP_RANGES", "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES", "LIST_OF_SUBNETWORKS"
    tcp_established_idle_timeout_sec   = optional(string, "1200"),
    tcp_transitory_idle_timeout_sec    = optional(string, "30"),
    tcp_time_wait_timeout_sec          = optional(string, "120"),
    udp_idle_timeout_sec               = optional(string, "30"),
    subnetworks = optional(list(object({ # Specifies one or more subnetwork NAT configurations
      name                     = string,
      source_ip_ranges_to_nat  = list(string)
      secondary_ip_range_names = list(string)
    })), [])
    log_config_enable                   = optional(bool, false),
    log_config_filter                   = optional(string, "ALL"),
    enable_dynamic_port_allocation      = optional(bool, false),
    enable_endpoint_independent_mapping = optional(bool, false)
  }))
  default     = []
  description = "NAT creation."
}

variable "ha_vpn" {
  type = list(object({
    parent_name          = optional(string, null), # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.
    parent_complete_name = optional(string, null), # Project ID
    name                 = optional(string, null), # (When complete_name is not specified) Completed with '[VPN_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.
    complete_name        = optional(string, null), # VPN name
    peer_external_gateway = optional(object({      # Configuration of an external VPN gateway to which this VPN is connected.
      name            = optional(string)           # Gateway name
      redundancy_type = optional(string)           # Possible values: "FOUR_IPS_REDUNDANCY", "SINGLE_IP_INTERNALLY_REDUNDANT", "TWO_IPS_REDUNDANCY"
      interfaces = list(object({
        id         = number
        ip_address = string
      }))
    }), null),
    peer_gcp_gateway      = optional(string, null) # Self Link URL of the peer side HA GCP VPN gateway to which this VPN tunnel is connected.
    stack_type            = optional(string, null) # The IP stack type will apply to all the tunnels associated with this VPN gateway.
    network_name          = optional(string, null) # (When network_complete_name is not specified) Completed with '[VPC_PREFIX]-[COMPANY_ABBREVIATION]-[NETWORK_NAME]'.
    network_complete_name = optional(string, null) # VPN name
    region                = optional(string, null)
    route_priority        = optional(number, 1000)
    keepalive_interval    = optional(number, 20)
    router_name           = optional(string, null), # (When router_complete_name is not specified) Completed with '[ROUTER_PREFIX]-[COMPANY_ABBREVIATION]-[ROUTER_NAME]'.
    router_complete_name  = optional(string, null), # Router Name
    tunnels = optional(map(object({                 # VPN tunnel configurations, bgp_peer_options is usually null.
      bgp_peer = object({
        address = string
        asn     = number
      })
      bgp_session_name = optional(string)
      bgp_peer_options = optional(object({
        ip_address          = optional(string)
        advertise_groups    = optional(list(string))
        advertise_ip_ranges = optional(map(string))
        advertise_mode      = optional(string)
        route_priority      = optional(number)
      }))
      bgp_session_range               = optional(string)
      ike_version                     = optional(number)
      vpn_gateway_interface           = optional(number)
      peer_external_gateway_self_link = optional(string, null)
      peer_external_gateway_interface = optional(number)
      shared_secret                   = optional(string, "")
    })), {})
    vpn_gateway_self_link            = optional(string, null)
    create_vpn_gateway               = optional(bool, true)
    labels                           = optional(map(string), {})
    external_vpn_gateway_description = optional(string)
  }))
  default     = []
  description = "HA-VPN creation."
}

variable "address" {
  type = list(object({
    parent_name          = optional(string, null),          # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.
    parent_complete_name = optional(string, null),          # Project ID
    subnet_name          = optional(string, null),          # (When subnet_complete_name is not specified) Completed with '[SUBNET_PREFIX]-[COMPANY_ABBREVIATION]-[SUBNET_NAME]'.
    subnet_complete_name = optional(string, null),          # The subnet which contains the address. For public addresses use the empty string.
    dns_project          = optional(string, "")             # The project where DNS A records will be configured.
    dns_domain           = optional(string, "")             # The domain to append to dns short names when registaring in Cloud DNS.
    dns_managed_zone     = optional(string, "")             # The name of the managed zone to create records within. This managed zone must exist in the host project.
    dns_reverse_zone     = optional(string, "")             # The name of the managed zone to create PTR records within. This managed zone must exist in the host project.
    names                = optional(list(string), [])       # A list of IP address resource names to create. This is the GCP resource name and not the associated hostname of the IP address.
    addresses            = optional(list(string), [])       # A list of IP addresses to create. GCP will reserve unreserved addresses if given the value "".
    address_type         = optional(string, "INTERNAL")     # The type of address to reserve, either "INTERNAL" or "EXTERNAL".
    dns_record_type      = optional(string, "A")            # The type of records to create in the managed zone.  (e.g. \"A\")
    dns_short_names      = optional(list(string), [])       # A list of DNS shor names to register within Cloud DNS.
    dns_ttl              = optional(number, 300)            # The DNS TTL in seconds in seconds for records created in Cloud DNS.
    enable_cloud_dns     = optional(bool, false)            # If a value is set, register records in Cloud DNS.
    enable_reverse_dns   = optional(bool, false)            # If a value is set, register reverse DNS PTR records in Cloud DNS in the managed zone specified by dns_reverse_zone
    global               = optional(bool, false)            # The scope in which the address should live. If set to true, the IP address will be globally scoped. Defaults to false, i.e. regionally scoped.
    ip_version           = optional(string, "IPV4")         # The IP Version that will be used by this address.("IPV4","IPV6")
    region               = optional(string, null)           # The region to create the address in.
    purpose              = optional(string, "GCE_ENDPOINT") #The purpose of the resource(GCE_ENDPOINT, SHARED_LOADBALANCER_VIP, VPC_PEERING).
    prefix_length        = optional(number, 16)             # The prefix length of the IP range.
    network_tier         = optional(string, "PREMIUM")      # The networking tier used for configuring this address.("PREMIUM")
  }))
  default     = []
  description = "Address creation"
}


variable "dns" {
  type = list(object({
    name                 = optional(string, null), # (When complete_name is not specified) Completed with '[DNS_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.
    complete_name        = optional(string, null), # NAT name
    parent_name          = optional(string, null), # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.
    parent_complete_name = optional(string, null), # Project ID
    domain               = string                  # Zone domain, must end with a period.
    private_visibility_config_networks = optional(list(object({
      vpc = string # VPC ID for private visibility. FORMAT: projects/[PROJECT_ID]/global/networks/[VPC_NAME]
      # Option 1. The ID can be manually specified (In that case ignore project variables).
      # Option 2. The ID is built using the VPC name with prefix [VPC_PREFIX-COMPANY_ABBREVIATION-VPC]. Need projects variable.
      # Option 3. The ID is built using the VPC name without prefix. Need projects variable.
      complete_project = optional(string, null),                            # Option 2 or 3. To specify VPC PROJECT completely. 
      project          = optional(string, null)                             # Option 2 or 3. To specify VPC PROJECT completed with prefixes. Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[COMPLETE_PROJECT]'.
    })), [])                                                                # List of VPC self links that can see this zone.
    target_name_server_addresses = optional(list(map(any)), [])             # List of target name servers for forwarding zone.
    target_network               = optional(string, "")                     # Peering network.
    description                  = optional(string, "Managed by Terraform") # zone description (shown in console)
    type                         = optional(string, "private")              # Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering', 'reverse_lookup' and 'service_directory'.
    dnssec_config                = optional(any, {})                        # Object containing : kind, non_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details
    labels                       = optional(map(any), {})                   # A set of key/value label pairs to assign to this ManagedZone
    default_key_specs_key        = optional(any, {})                        # Object containing default key signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details
    default_key_specs_zone       = optional(any, {})                        # Object containing default zone signing specifications : algorithm, key_length, key_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details
    force_destroy                = optional(bool, false)                    # Set this true to delete all records in the zone.
    service_namespace_url        = optional(string, "The fully qualified or partial URL of the service directory namespace that should be associated with the zone. This should be formatted like https://servicedirectory.googleapis.com/v1/projects/{project}/locations/{location}/namespaces/{namespace_id} or simply projects/{project}/locations/{location}/namespaces/{namespace_id}.")
    recordsets = optional( # List of DNS record objects to manage, in the standard terraform dns structure.
      list(object({
        name    = string
        type    = string
        ttl     = number
        records = optional(list(string), null)
        routing_policy = optional(object({
          wrr = optional(list(object({
            weight  = number
            records = list(string)
          })), [])
          geo = optional(list(object({
            location = string
            records  = list(string)
          })), [])
        }))
    })), [])
    enable_logging = optional(bool, false) # Enable query logging for this ManagedZone
  }))
  default     = []
  description = "NAT creation."
}

variable "vpn" {
  type = list(object({
    parent_name             = optional(string, null),      # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.
    parent_complete_name    = optional(string, null),      # Project ID
    name                    = optional(string, null),      # (When complete_name is not specified) Completed with '[VPN_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.
    complete_name           = optional(string, null),      # VPN name
    project_id              = optional(string, "")         # (Required) The ID of the project where this VPC will be created.
    region                  = optional(string, "")         # (Required) The region in which you want to create the VPN gateway.
    network                 = optional(string, "")         # (When network_complete_name is not specified) Completed with '[VPC_PREFIX]-[COMPANY_ABBREVIATION]-[NETWORK_NAME]'.
    network_complete_name   = optional(string, null)       # The name of VPC being created.  
    peer_ips                = optional(list(string), [])   # (Required) IP address of remote-peer/gateway.
    vpn_gw_ip               = optional(string)             # (Optional) Please enter the public IP address of the VPN Gateway, if you have already one. Do not set this variable to autocreate one
    cr_name                 = optional(string)             # (optional) The name of cloud router for BGP routing
    tunnel_name_prefix      = optional(string)             # (optional) The optional custom name of VPN tunnel being created
    remote_traffic_selector = optional(list(string), null) # (optional) Remote traffic selector to use when establishing the VPN tunnel with peer VPN gateway.Value should be list of CIDR formatted strings and ranges should be disjoint.
    local_traffic_selector  = optional(list(string), null) #(otpional) Local traffic selector to use when establishing the VPN tunnel with peer VPN gateway. Value should be list of CIDR formatted strings and ranges should be disjoint.
    shared_secret           = optional(string, null)       # (optional) Please enter the shared secret/pre-shared key
    route_priority          = optional(number, 100)        # (optional) Route priority number
  }))
  default     = []
  description = "VPN creation."

}