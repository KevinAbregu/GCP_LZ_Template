variable "service_perimeter" {
  description = "The object used for the SC perimeter declaration."
  type = object({
    perimeter_name              = string
    description                 = string
    restricted_services_dry_run = list(string) # possible values [ALL_SERVICES], [] or list of services
    restricted_services         = list(string) # possible values [ALL_SERVICES], [], list of services [RESTRICTED_SERVICES] to inherite from restricted_services_dry_run value
    accessible_services_dry_run = list(string) # possible values [ALL_SERVICES], [], list of services [RESTRICTED_SERVICES]
    accessible_services         = list(string) # possible values [ALL_SERVICES], [], list of services [RESTRICTED_SERVICES]
    enforced_projects_list      = list(string) # [] or [ALL] [List of project IDs] project numbers to include in enforced perimeters
  })
}

variable "service_perimeter_folders" {
  description = "Folders numbers that contain service perimeter's projects"
  type        = list(string)
  default     = []
}

variable "service_perimeters_access_level" {
  description = "The access levels list for the SC perimeter"
  type = object({
    enforce_list = list(string),
    dry_run_list = list(string),
  })
}

variable "authorizing_all_from_project_sources" {
  description = "projects numbers list to build default ingress policy.often used to grant from runners projects"
  type        = list(string)
  default     = []
}

variable "authorizing_all_for_identities" {
  description = "project numbers list to build default ingress policy. often used to grant from to TF SAC"
  type        = list(string)
  default     = []
}

variable "policy_id" {
  type        = string
  description = "Policy ID is only used when a policy already exists"
}

variable "service_perimeters_ingress_policies_list" {
  description = "ingress rules list for the SC perimeter"
  type = list(object({
    enforced = optional(bool, false)
    from = object({
      ressources    = list(string)
      all_sources   = optional(bool, false)
      identities    = list(string)
      identity_type = optional(string)
    })
    to = object({
      resources = list(string)
      operations = map(object({
        methods     = list(string),
        permissions = optional(list(string)),
      }))
    })
  }))
}

variable "service_perimeters_egress_policies_list" {
  description = "egress rules list for the SC perimeter"
  type = list(object({
    enforced = optional(bool, false),
    from = object({
      identity_type = optional(string),
      identities    = list(string),
    })
    to = object({
      resources = list(string)
      operations = map(object({
        methods     = list(string),
        permissions = optional(list(string)),
      }))
    })
  }))
}

variable "projects_resources_out_folders" {
  description = "projects that must be part of the SC perimeter and don't belong to any folder"
  type = object({
    enforce_list = list(string),
    dry_run_list = list(string),
  })
  default = {
    enforce_list = [],
    dry_run_list = [],
  }
}

variable "perimeter_apis_list" {
  description = "All services APIs list "
  type        = list(string)
  default = [
    "accessapproval.googleapis.com",
    "adsdatahub.googleapis.com",
    "aiplatform.googleapis.com",
    "alloydb.googleapis.com",
    "analyticshub.googleapis.com",
    "apigee.googleapis.com",
    "apigeeconnect.googleapis.com",
    "artifactregistry.googleapis.com",
    "assuredworkloads.googleapis.com",
    "automl.googleapis.com",
    "backupdr.googleapis.com",
    "baremetalsolution.googleapis.com",
    "batch.googleapis.com",
    "beyondcorp.googleapis.com",
    "biglake.googleapis.com",
    "bigquery.googleapis.com",
    "bigquerydatapolicy.googleapis.com",
    "bigquerydatatransfer.googleapis.com",
    "bigquerymigration.googleapis.com",
    "bigqueryreservation.googleapis.com",
    "bigtable.googleapis.com",
    "binaryauthorization.googleapis.com",
    "certificatemanager.googleapis.com",
    "cloud.googleapis.com",
    "cloudasset.googleapis.com",
    "cloudbuild.googleapis.com",
    "clouddeploy.googleapis.com",
    "clouderrorreporting.googleapis.com",
    "cloudfunctions.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudprofiler.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "cloudsearch.googleapis.com",
    "cloudsupport.googleapis.com",
    "cloudtasks.googleapis.com",
    "cloudtrace.googleapis.com",
    "composer.googleapis.com",
    "compute.googleapis.com",
    "connectgateway.googleapis.com",
    "connectors.googleapis.com",
    "contactcenterinsights.googleapis.com",
    "container.googleapis.com",
    "containeranalysis.googleapis.com",
    "containerfilesystem.googleapis.com",
    "containerregistry.googleapis.com",
    "containersecurity.googleapis.com",
    "containerthreatdetection.googleapis.com",
    "contentwarehouse.googleapis.com",
    "datacatalog.googleapis.com",
    "dataflow.googleapis.com",
    "datafusion.googleapis.com",
    "datalineage.googleapis.com",
    "datamigration.googleapis.com",
    "datapipelines.googleapis.com",
    "dataplex.googleapis.com",
    "dataproc.googleapis.com",
    "datastream.googleapis.com",
    "dialogflow.googleapis.com",
    "discoveryengine.googleapis.com",
    "dlp.googleapis.com",
    "dns.googleapis.com",
    "documentai.googleapis.com",
    "domains.googleapis.com",
    "essentialcontacts.googleapis.com",
    "eventarc.googleapis.com",
    "file.googleapis.com",
    "financialservices.googleapis.com",
    "firebaseappcheck.googleapis.com",
    "firebasecrashlytics.googleapis.com",
    "firebaserules.googleapis.com",
    "firestore.googleapis.com",
    "gameservices.googleapis.com",
    "gkebackup.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com",
    "gkemulticloud.googleapis.com",
    "gkeonprem.googleapis.com",
    "healthcare.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "iap.googleapis.com",
    "iaptunnel.googleapis.com",
    "identitytoolkit.googleapis.com",
    "ids.googleapis.com",
    "integrations.googleapis.com",
    "kmsinventory.googleapis.com",
    "krmapihosting.googleapis.com",
    "language.googleapis.com",
    "lifesciences.googleapis.com",
    "livestream.googleapis.com",
    "logging.googleapis.com",
    "looker.googleapis.com",
    "managedidentities.googleapis.com",
    "memcache.googleapis.com",
    "meshca.googleapis.com",
    "meshconfig.googleapis.com",
    "metastore.googleapis.com",
    "ml.googleapis.com",
    "monitoring.googleapis.com",
    "netapp.googleapis.com",
    "networkconnectivity.googleapis.com",
    "networkmanagement.googleapis.com",
    "networksecurity.googleapis.com",
    "networkservices.googleapis.com",
    "notebooks.googleapis.com",
    "ondemandscanning.googleapis.com",
    "opsconfigmonitoring.googleapis.com",
    "orgpolicy.googleapis.com",
    "osconfig.googleapis.com",
    "oslogin.googleapis.com",
    "policysimulator.googleapis.com",
    "policytroubleshooter.googleapis.com",
    "privateca.googleapis.com",
    "publicca.googleapis.com",
    "pubsub.googleapis.com",
    "pubsublite.googleapis.com",
    "recaptchaenterprise.googleapis.com",
    "recommender.googleapis.com",
    "redis.googleapis.com",
    "retail.googleapis.com",
    "run.googleapis.com",
    "secretmanager.googleapis.com",
    "securetoken.googleapis.com",
    "servicecontrol.googleapis.com",
    "servicedirectory.googleapis.com",
    "spanner.googleapis.com",
    "speakerid.googleapis.com",
    "speech.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
    "storageinsights.googleapis.com",
    "storagetransfer.googleapis.com",
    "sts.googleapis.com",
    "telecomdatafabric.googleapis.com",
    "texttospeech.googleapis.com",
    "timeseriesinsights.googleapis.com",
    "tpu.googleapis.com",
    "trafficdirector.googleapis.com",
    "transcoder.googleapis.com",
    "translate.googleapis.com",
    "videointelligence.googleapis.com",
    "videostitcher.googleapis.com",
    "vision.googleapis.com",
    "visionai.googleapis.com",
    "visualinspection.googleapis.com",
    "vmmigration.googleapis.com",
    "vpcaccess.googleapis.com",
    "webrisk.googleapis.com",
    "workflows.googleapis.com",
    "workstations.googleapis.com",
  ]
}


