locals {
  inject_default_policy = length(var.authorizing_all_for_identities) > 0 || length(var.authorizing_all_from_project_sources) > 0
  default_in_policy = {
    from = {
      sources = var.authorizing_all_from_project_sources == tolist(["*"]) ? { access_levels = ["*"], resources = [] } : { access_levels = [], resources = var.authorizing_all_from_project_sources }
      
      identities = setunion([for id in var.authorizing_all_for_identities : id if !startswith(id, "group:")],
        flatten([for id in var.authorizing_all_for_identities :
          [for m in data.google_cloud_identity_group_memberships.default[split(":", id)[1]].memberships :
            [for mm in m.preferred_member_key : format("%s:${mm.id}", strcontains("${mm.id}", "gserviceaccount") ? "serviceAccount" : "user")]
      ] if startswith(id, "group:")]))
    }
    to = {
      "resources" = ["*"]
      "operations" = {
        "*" = {}
      }
    }
  }

  perimeters_groups_list = setunion(
    flatten([for rule in var.service_perimeters_ingress_policies_list : [for id in rule.from.identities : split(":", id)[1] if startswith(id, "group:")]]),
    flatten([for rule in var.service_perimeters_egress_policies_list : [for id in rule.from.identities : split(":", id)[1] if startswith(id, "group:")]]),
    flatten([for id in var.authorizing_all_for_identities : split(":", id)[1] if startswith(id, "group:")])
  )

  perimeters_parents_folders_query = join(" OR ", [for p in var.service_perimeter_folders : "parent.id:${p}"])

  service_perimeters_in_policies_list = {
    dry_run_list = concat([for rule in var.service_perimeters_ingress_policies_list :
      {
        from = {
          sources = rule.from.all_sources == true ? { access_levels = ["*"], resources = [] } : { access_levels = [], resources = rule.from.ressources },
          identities = setunion([for id in rule.from.identities : id if !startswith(id, "group:")],
            flatten([for id in rule.from.identities :
              [for m in data.google_cloud_identity_group_memberships.default[split(":", id)[1]].memberships :
                [for mm in m.preferred_member_key : format("%s:${mm.id}", strcontains("${mm.id}", "gserviceaccount") ? "serviceAccount" : "user")]
            ] if startswith(id, "group:")])
          )
        }
        to = rule.to,
      }
    ], local.inject_default_policy == true ? [local.default_in_policy] : []),

    enforce_list = concat([for rule in var.service_perimeters_ingress_policies_list :
      {
        from = {
          sources = rule.from.all_sources == true ? { access_levels = ["*"], resources = [] } : { access_levels = [], resources = rule.from.ressources },
          identities = setunion([for id in rule.from.identities : id if !startswith(id, "group:")],
            flatten([for id in rule.from.identities :
              [for m in data.google_cloud_identity_group_memberships.default[split(":", id)[1]].memberships :
                [for mm in m.preferred_member_key : format("%s:${mm.id}", strcontains("${mm.id}", "gserviceaccount") ? "serviceAccount" : "user")]
            ] if startswith(id, "group:")])
          )
        }
        to = rule.to,
      } if rule.enforced
    ], local.inject_default_policy == true ? [local.default_in_policy] : []),
  }


  service_perimeters_eg_policies_list = {
    dry_run_list = [for rule in var.service_perimeters_egress_policies_list :
      {
        from = {
          identity_type = rule.from.identity_type
          identities = setunion([for id in rule.from.identities : id if !startswith(id, "group:")],
            flatten([for id in rule.from.identities :
              [for m in data.google_cloud_identity_group_memberships.default[split(":", id)[1]].memberships :
                [for mm in m.preferred_member_key : format("%s:${mm.id}", strcontains("${mm.id}", "gserviceaccount") ? "serviceAccount" : "user")]
            ] if startswith(id, "group:")])
          )
        }
        to = rule.to,
      }
    ],
    enforce_list = [for rule in var.service_perimeters_egress_policies_list :
      {
        from = {
          identity_type = rule.from.identity_type
          identities = setunion([for id in rule.from.identities : id if !startswith(id, "group:")],
            flatten([for id in rule.from.identities :
              [for m in data.google_cloud_identity_group_memberships.default[split(":", id)[1]].memberships :
                [for mm in m.preferred_member_key : format("%s:${mm.id}", strcontains("${mm.id}", "gserviceaccount") ? "serviceAccount" : "user")]
            ] if startswith(id, "group:")])
          )
        }
        to = rule.to,
      } if rule.enforced
    ],
  }


  perimeters_folders_projects_list = (length(var.service_perimeter_folders) > 0 ? (length(var.service_perimeter.enforced_projects_list) >= 1 ?
    (var.service_perimeter.enforced_projects_list[0] == "ALL" ?
      {
        dry_run_list = [for p in data.google_projects.default.projects : p.number],
        enforce_list = [for p in data.google_projects.default.projects : p.number],
      }
      :
      {
        dry_run_list = [for p in data.google_projects.default.projects : p.number],
        enforce_list = var.service_perimeter.enforced_projects_list,
      }
    )
    :
    {
      dry_run_list = [for p in data.google_projects.default.projects : p.number],
      enforce_list = [],
    })
    : {
      dry_run_list = [],
      enforce_list = [],
  })


  perimeters_restricted_services_dry_run_list = (var.service_perimeter.restricted_services_dry_run != null
    && length(var.service_perimeter.restricted_services_dry_run) >= 1
    && var.service_perimeter.restricted_services_dry_run[0] == "ALL_SERVICES" ?
    var.perimeter_apis_list

    :
    var.service_perimeter.restricted_services_dry_run
  )


  perimeters_restricted_services_enforced_list = (var.service_perimeter.restricted_services != null && length(var.service_perimeter.restricted_services) >= 1 ?
    (var.service_perimeter.restricted_services[0] == "ALL_SERVICES" ?
      var.perimeter_apis_list

      : (var.service_perimeter.restricted_services[0] == "RESTRICTED-SERVICES" ?

        local.perimeters_restricted_services_dry_run_list
        :
        var.service_perimeter.restricted_services
      )
    )
    :

    []
  )

  perimeters_accessible_services_list = {
    dry_run_list = var.service_perimeter.accessible_services_dry_run,
    enforce_list = var.service_perimeter.accessible_services,
  }

  perimeters_resources_list = {
    dry_run_list = setunion(local.perimeters_folders_projects_list.dry_run_list,
    var.projects_resources_out_folders.dry_run_list),
    enforce_list = setunion(local.perimeters_folders_projects_list.enforce_list,
    var.projects_resources_out_folders.enforce_list),
  }
}