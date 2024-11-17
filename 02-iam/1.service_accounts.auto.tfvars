service_accounts = [

  {
    name                 = "networking"
    parent_complete_name = "BOOTSTRAP"
    iam_folder_roles = {
      "[PREFIX]cs-net" = ["roles/compute.xpnAdmin", "roles/compute.networkAdmin", "roles/dns.admin", "roles/compute.networkUser", "roles/resourcemanager.folderAdmin", "roles/compute.admin"],
    }
    iam_storage_roles = {

      "[PREFIX]networking" = ["roles/storage.objectCreator", "roles/storage.legacyBucketWriter", "roles/storage.legacyBucketReader", "roles/storage.objectUser"],
      "[PREFIX]bootstrap"  = ["roles/storage.objectViewer"],

    }
    iam_bindings = {
      "roles/iam.serviceAccountTokenCreator" = {
        role    = "roles/iam.serviceAccountTokenCreator"
        members = ["user:usuario1@kevin-abregu.online"]
      }
    }
  },
  {
    name                   = "security"
    parent_complete_name   = "BOOTSTRAP"
    iam_organization_roles = ["roles/accesscontextmanager.policyAdmin", "roles/compute.securityAdmin"]
    iam_storage_roles = {
      "[PREFIX]security" = ["roles/storage.objectCreator", "roles/storage.legacyBucketWriter", "roles/storage.legacyBucketReader", "roles/storage.objectUser"],
    }
    iam_bindings = {
      "roles/iam.serviceAccountTokenCreator" = {
        role    = "roles/iam.serviceAccountTokenCreator"
        members = ["user:usuario1@kevin-abregu.online"]
      }
    }
  },
  {
    name                 = "sp-pro"
    parent_complete_name = "BOOTSTRAP"
    iam_storage_roles = {
      "[PREFIX]sp-pro" = ["roles/storage.objectCreator", "roles/storage.legacyBucketWriter", "roles/storage.legacyBucketReader", "roles/storage.objectUser"],
    }
    iam_bindings = {
      "roles/iam.serviceAccountTokenCreator" = {
        role    = "roles/iam.serviceAccountTokenCreator"
        members = ["user:usuario1@kevin-abregu.online"]
      }
    }
    iam_project_roles = {
      "[PREFIX]pro" = [
        "roles/owner",
        "roles/logging.logWriter",
        "roles/iam.serviceAccountUser",
      ],
    }
  },
#   {
#     name                 = "sp-pre"
#     parent_complete_name = "BOOTSTRAP"
#     iam_storage_roles = {
#       "[PREFIX]sp-pre" = ["roles/storage.objectCreator", "roles/storage.legacyBucketWriter", "roles/storage.legacyBucketReader", "roles/storage.objectUser"],
#     }
#     iam_bindings = {
#       "roles/iam.serviceAccountTokenCreator" = {
#         role    = "roles/iam.serviceAccountTokenCreator"
#         members = ["user:kabregu@dev.intelligencepartner.com"]
#       }
#     }
#     iam_project_roles = {
#       "[PREFIX]pre" = [
#         "roles/owner",
#         "roles/logging.logWriter",
#         "roles/iam.serviceAccountUser",
#       ],
#     }
#   },
#   {
#     name                 = "sp-dev"
#     parent_complete_name = "BOOTSTRAP"
#     iam_storage_roles = {
#       "[PREFIX]sp-dev" = ["roles/storage.objectCreator", "roles/storage.legacyBucketWriter", "roles/storage.legacyBucketReader", "roles/storage.objectUser"],
#     }
#     iam_bindings = {
#       "roles/iam.serviceAccountTokenCreator" = {
#         role    = "roles/iam.serviceAccountTokenCreator"
#         members = ["user:kabregu@dev.intelligencepartner.com"]
#       }
#     }
#     iam_project_roles = {
#       "[PREFIX]dev" = [
#         "roles/owner",
#         "roles/logging.logWriter",
#         "roles/iam.serviceAccountUser",
#       ],
#     }
#   },
  {
    name                 = "monitoring"
    parent_complete_name = "BOOTSTRAP"
    iam_organization_roles = ["roles/monitoring.admin", "roles/logging.admin"]
    iam_storage_roles = {

      "[PREFIX]monitoring" = ["roles/storage.objectCreator", "roles/storage.legacyBucketWriter", "roles/storage.legacyBucketReader", "roles/storage.objectUser"],
      "[PREFIX]bootstrap"  = ["roles/storage.objectViewer"],

    }
    iam_bindings = {
      "roles/iam.serviceAccountTokenCreator" = {
        role    = "roles/iam.serviceAccountTokenCreator"
        members = ["user:usuario1@kevin-abregu.online"]
      }
    }
  }
]


