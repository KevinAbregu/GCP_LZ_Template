/******************************************
  Main variables
*******************************************/
variable "org_id" {
  description = "GCP Organization ID"
  type        = string
  default = "XXXX"
}

variable "billing_account" {
  description = "The ID of the billing account to associate projects with."
  type        = string
}

variable "group_org_admins" {
  description = "Google Group for GCP Organization Administrators"
  type        = string
}

variable "default_region" {
  description = "Default region to create resources where applicable."
  type        = string
}


variable "company_abbreviation" {
  description = "Company Abbreviation to add for resources created where applicable"
  type        = string
}
variable "project_prefix" {
  description = "Project Prefix to add for projects created where applicable"
  type        = string
  default     = "g-prj"
}
variable "bucket_prefix" {
  description = "Bucket Prefix to add for buckets created where applicable"
  type        = string
  default     = "bkt"
}
variable "sa_prefix" {
  description = "Service Account Prefix to add for service accounts created where applicable"
  type        = string
  default     = "sa"
}


/******************************************
  Optional variables
*******************************************/

variable "project_id" {
  description = "Custom project ID to use for project created. (if not specified => '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-bootstrap' is created)"
  type        = string
  default     = null
}

variable "tf_service_account_name" {
  description = "Display name of service account for terraform in seed project."
  type        = string
  default     = "CFT Organization Terraform Account"
}

variable "state_bucket_name" {
  description = "Custom state bucket name (if not specified => '[BUCKET_PREFIX]-[COMPANY_ABBREVIATION]-bootstrap' is created)"
  type        = string
  default     = null
}

variable "tf_service_account_id" {
  description = "ID of service account for terraform in seed project (if not specified => '[SA_PREFIX]-[COMPANY_ABBREVIATION]-bootstrap' is created)"
  type        = string
  default     = null
}

variable "parent_folder" {
  description = "GCP parent folder ID in the form folders/{id}"
  default     = ""
  type        = string
}

variable "activate_apis" {
  description = "List of APIs to enable in the seed project."
  type        = list(string)
  default = [
    "serviceusage.googleapis.com",
    "servicenetworking.googleapis.com",
    "compute.googleapis.com",
    "logging.googleapis.com",
    "bigquery.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudbilling.googleapis.com",
    "iam.googleapis.com",
    "admin.googleapis.com",
    "appengine.googleapis.com",
    "storage-api.googleapis.com",
    "monitoring.googleapis.com",
    "orgpolicy.googleapis.com",
    "cloudbuild.googleapis.com",
  ]
}

variable "project_labels" {
  description = "Labels to apply to the project."
  type        = map(string)
  default     = { "environment" : "bootstrap" }
}

variable "sa_enable_impersonation" {
  description = "Allow org_admins group to impersonate service account & enable APIs required."
  type        = bool
  default     = true
}

variable "sa_org_iam_permissions" {
  description = "List of permissions granted to Terraform service account across the GCP organization/Root Folder."
  type        = list(string)
  default = [
    "roles/billing.user",
    "roles/compute.networkAdmin",
    "roles/compute.xpnAdmin",
    "roles/iam.securityAdmin",
    "roles/iam.serviceAccountAdmin",
    "roles/logging.admin",
    "roles/orgpolicy.policyAdmin",
    "roles/resourcemanager.folderAdmin",
    "roles/resourcemanager.organizationAdmin",
    "roles/iam.denyAdmin",
    "roles/resourcemanager.projectCreator",
    "roles/accesscontextmanager.policyAdmin",
    "roles/storage.admin",
    "roles/iam.organizationRoleAdmin"
  ]
}


variable "folder_id" {
  description = "The ID of a folder to host this project"
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "If supplied, the state bucket will be deleted even while containing objects."
  type        = bool
  default     = false
}

variable "grant_billing_user" {
  description = "Grant roles/billing.user role to CFT service account"
  type        = bool
  default     = false
}

variable "random_suffix" {
  description = "Appends a 4 character random suffix to project ID and GCS bucket name."
  type        = bool
  default     = false
}