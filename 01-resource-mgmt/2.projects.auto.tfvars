projects = [

  {
    name        = "cs-net-hub"
    parent_name = "cs-net"
    svpc_host   = true
    labels      = { type = "networking", environment = "hub" }
  },
  {
    name        = "cs-net-pro"
    parent_name = "cs-net"
    svpc_host   = true
    labels      = { type = "networking", environment = "pro" }
  },
#   {
#     name        = "cs-net-pre"
#     parent_name = "cs-net"
#     svpc_host   = true
#     labels      = { type = "networking", environment = "pre" }
#   },
#   {
#     name        = "cs-net-dev"
#     parent_name = "cs-net"
#     svpc_host   = true
#     labels      = { type = "networking", environment = "dev" }
#   },
  {
    name                   = "pro"
    parent_name            = "apps"
    svpc_service_host_name = "cs-net-pro"
    labels                 = { type = "service-project", environment = "pro" }
  },
#   {
#     name                   = "pre"
#     parent_name            = "apps"
#     svpc_service_host_name = "cs-net-pre"

#     labels = { type = "service-project", environment = "pre" }
#   },
#   {
#     name                   = "dev"
#     parent_name            = "apps"
#     svpc_service_host_name = "cs-net-dev"
#     labels                 = { type = "service-project", environment = "dev" }
#   },
#   {
#     name        = "cs-ops"
#     parent_name = "cs-devops"
#     labels      = { type = "devops" }
#   },
  {
    name                 = "billing"
    labels               = { type = "billing" }
    parent_complete_name = "ROOT"
  },
#   {
#     name                 = "audit"
#     labels               = { type = "audit" }
#     parent_complete_name = "ROOT"
#   },
#   {
#     name                 = "monitoring"
#     labels               = { type = "monitoring" }
#     parent_complete_name = "ROOT"
#     services             = ["monitoring.googleapis.com"]
#   }

]