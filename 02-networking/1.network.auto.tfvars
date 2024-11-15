## Examples
networks = [
  {
    name        = "hub"
    parent_name = "cs-net-hub"
    subnets = [
      {
        subnet_name           = "hub-principal"
        subnet_ip             = "10.0.0.0/24"
        subnet_private_access = "true"

      },
      {
        subnet_name = "hub-proxy-only"
        subnet_ip   = "10.0.1.0/24"
        purpose     = "REGIONAL_MANAGED_PROXY"
        role        = "ACTIVE"
        # ipv6_access_type = "INTERNAL" #
      }
    ]
    secondary_ranges = {
      "[PREFIX]hub-principal" = [
        {
          range_name    = "subnet-01-secondary-01"
          ip_cidr_range = "192.168.64.0/24"
        },
      ]
    }
    ingress_rules = [
      {
        name          = "allow-ingress-http-ssh-icmp"
        description   = "Allow SSH"
        priority      = 1000
        source_ranges = ["0.0.0.0/0"]
        allow = [
          {
            protocol = "TCP",
            ports    = ["22", "80", "8080"]
          },
          {
            protocol = "ICMP"
          }
        ]
      },
    ]
  },
  {
    name        = "pro"
    parent_name = "cs-net-pro"
    subnets = [
      {
        subnet_name           = "pro-principal"
        subnet_ip             = "10.0.2.0/24"
        subnet_private_access = "true"

      },
      {
        subnet_name           = "pro-principal-02"
        subnet_ip             = "10.0.10.0/24"
        subnet_private_access = "true"

      },
      {
        subnet_name = "pro-proxy-only"
        subnet_ip   = "10.0.3.0/24"
        purpose     = "REGIONAL_MANAGED_PROXY"
        role        = "ACTIVE"
        # ipv6_access_type = "INTERNAL" #
      }
    ]
    ingress_rules = [
      {
        name          = "allow-ingress-http-ssh-icmp"
        description   = "Allow SSH"
        priority      = 1000
        source_ranges = ["0.0.0.0/0"]
        allow = [
          {
            protocol = "TCP",
            ports    = ["22", "80", "8080"]
          },
          {
            protocol = "ICMP"
          }
        ]
      },
    ]
  },
  {
    name        = "pre"
    parent_name = "cs-net-pre"
    subnets = [
      {
        subnet_name           = "pre-principal"
        subnet_ip             = "10.0.4.0/24"
        subnet_private_access = "true"
      },
      {
        subnet_name = "pre-proxy-only"
        subnet_ip   = "10.0.5.0/24"
        purpose     = "REGIONAL_MANAGED_PROXY"
        role        = "ACTIVE"
        # ipv6_access_type = "INTERNAL" #
      }
    ]
    ingress_rules = [
      {
        name          = "allow-ingress-http-ssh-icmp"
        description   = "Allow SSH"
        priority      = 1000
        source_ranges = ["0.0.0.0/0"]
        allow = [
          {
            protocol = "TCP",
            ports    = ["22", "80", "8080"]
          },
          {
            protocol = "ICMP"
          }
        ]
      },
    ]
  },
  {
    name        = "dev"
    parent_name = "cs-net-dev"
    subnets = [
      {
        subnet_name           = "dev-principal"
        subnet_ip             = "10.0.6.0/24"
        subnet_private_access = "true"
      },
      {
        subnet_name = "dev-proxy-only"
        subnet_ip   = "10.0.7.0/24"
        purpose     = "REGIONAL_MANAGED_PROXY"
        role        = "ACTIVE"
        # ipv6_access_type = "INTERNAL" #
      }
    ]
    ingress_rules = [
      {
        name          = "allow-ingress-http-ssh-icmp"
        description   = "Allow SSH"
        priority      = 1000
        source_ranges = ["0.0.0.0/0"]
        allow = [
          {
            protocol = "TCP",
            ports    = ["22", "80", "8080"]
          },
          {
            protocol = "ICMP"
          }
        ]
      },
    ]
  }
]