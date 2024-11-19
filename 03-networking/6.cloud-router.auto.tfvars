## Examples
routers = [
  {
    name         = "nat-01"
    parent_name  = "cs-net-hub"
    network_name = "hub"
    bgp = {
      asn = "65530"
    }
  },
  {
    name         = "vpn-01"
    parent_name  = "cs-net-hub"
    network_name = "hub"
    bgp = {
      asn = "65531"
    }
  }
]