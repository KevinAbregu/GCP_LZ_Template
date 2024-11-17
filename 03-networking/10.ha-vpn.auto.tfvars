## Examples
# ha_vpn = [
#   {
#     parent_name = "cs-net-hub"
#     name        = "01"
#     peer_external_gateway = {
#       name            = "gw-01"
#       redundancy_type = "SINGLE_IP_INTERNALLY_REDUNDANT"
#       interfaces = [
#         {
#           id         = 0
#           ip_address = "8.8.8.8"
#         },
#       ]
#     }
#     network_name = "hub"
#     router_name  = "vpn-01"
#     tunnels = {

#       remote-0 = {
#         bgp_peer = {
#           address = "169.254.1.1"
#           asn     = 64513
#         }
#         bgp_session_name                = "bgp-peer-0"
#         bgp_session_range               = "169.254.1.2/30"
#         ike_version                     = 2
#         peer_external_gateway_interface = 0
#         vpn_gateway_interface           = 0
#         shared_secret                   = "mySecret"
#       }

#       remote-1 = {
#         bgp_peer = {
#           address = "169.254.2.1"
#           asn     = 64513
#         }
#         bgp_session_name                = "bgp-peer-1"
#         bgp_session_range               = "169.254.2.2/30"
#         ike_version                     = 2
#         peer_external_gateway_interface = 0
#         vpn_gateway_interface           = 1
#         shared_secret                   = "mySecret"
#       }
#     }
#   },
# ]