policy_id = "603253214894" # TO CHANGE
service_perimeter = {
  perimeter_name              = "test_perimeter_01"       # TO CHANGE 
  description                 = "Description of the perimeter" # TO CHANGE
  restricted_services_dry_run = ["storage.googleapis.com"]
  restricted_services         = ["RESTRICTED-SERVICES"]
  accessible_services_dry_run = ["RESTRICTED-SERVICES"]
  accessible_services         = ["RESTRICTED-SERVICES"]
  enforced_projects_list      = []
}

# Default policies
# authorizing_all_from_project_sources = ["*"] 
# authorizing_all_for_identities = ["user:kabregu@dev.intelligencepartner.com", "group:00vx12272wnmhqt"]  #, "group:02w5ecyt286ft44"] # TO CHANGE

# service_perimeter_folders = ["823403687143"]
projects_resources_out_folders = {
  enforce_list = ["844484619838"], # TO CHANGE
  dry_run_list = ["844484619838"], # TO CHANGE 
}

service_perimeters_access_level = {
  enforce_list = [],
  dry_run_list = [],
}

service_perimeters_ingress_policies_list = [
  {
    enforced = true
    from = {
      ressources  = []
      all_sources = true                                         # CHECK
      identities  = ["user:kabregu@dev.intelligencepartner.com", "group:00vx12272wnmhqt"] #, "group:02w5ecyt286ft44"] # TO CHANGE

    }
    "to" = {
      "resources" = ["*"]
      "operations" = {
        "storage.googleapis.com" = {
          "methods"     = ["*"],
          "permissions" = []
        }

      }
    }
  },
]

service_perimeters_egress_policies_list = []



