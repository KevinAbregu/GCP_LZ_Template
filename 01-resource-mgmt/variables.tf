variable "parent_root" {
  type        = string
  description = "Root Folder/Organization ID from where resources will be created."
  nullable    = false
}
variable "fldr_prefix" {
  type        = string
  description = "Folder prefix to add for folders created where applicable."
  default     = "g-fldr"
}
variable "folders" {
  type = map(list(object(
    {
      name                   = optional(string, null) # (When complete_name is not specified). Completed with '[FLDR_PREFIX]-[NAME]'.
      complete_name          = optional(string, null) # Folder complete name.
      parent_complete_name   = optional(string, null) # Parent Folder Name.
      parent_name            = optional(string, null) # (When parent_complete_name is not specified). Completed with '[FLDR_PREFIX]-[NAME]'.
      org_policies_data_path = optional(string, null) # Indicates a folder path with organization policies in yaml files. Inside 'org-policies-config/folders/[PATH]'.
      aux_tf_key             = optional(string, null) # Variable used when there's a folder name coincidence to differenciate between them.
      tag_bindings           = optional(map(string), {})

    }))
  )
  description = "Folders configuration "
  default     = {}
}

variable "projects" {
  type = list(object(
    {
      complete_name                   = optional(string, null)      # Project ID.
      name                            = optional(string, null)      # (When complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.
      descriptive_name                = optional(string, null)      # Display Project Name. If not specified it is as Project ID.
      parent_name                     = optional(string, null)      # (When parent_complete_name is not specified) Completed with => '[FLDR_PREFIX]-[PARENT_NAME]'.
      parent_complete_name            = optional(string, null)      # Parent Folder Name. IF "ROOT" it will use parent_root value
      services                        = optional(list(string), []), # APIs that are activated.
      prefix                          = optional(string, null),     # Prefix to include in the name.
      svpc_host                       = optional(bool, false),      # If true, this project is a host project.
      svpc_service_host_name          = optional(string, null),     # (When svpc_service_host_complete_name is not specified AND this project is a service project) Host Project ID completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.
      svpc_service_host_complete_name = optional(string, null),     # This project is a service project of the Hos t Project ID indicated in this variable.
      org_policies_data_path          = optional(string, null)      # Indicates a folder path with organization policies in yaml files. Inside org-policies-config/projects/[PATH]
      default_service_account         = optional(string, "disable") # Indicates default service account initial state (default disable).
      labels                          = optional(map(string), {})   # Labels to include in the project.

    })
  )
  description = "Projects configuration"
  default     = []
}

variable "organization_policies" {
  type        = bool
  default     = false
  description = "Organization policies that  must be activated at org level. Its configuration is 'org-policies-config/organization/*.yaml'"
}

variable "custom_roles" {
  type        = bool
  default     = false
  description = "Creation of custom roles. Its configuration is on 'org-custom-roles/*.yaml'"
}

variable "buckets" {
  type = list(object(
    {
      name                 = optional(string, null),      # (When complete_name is not specified) Completed with '[BUCKET_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.
      complete_name        = optional(string, null),      # Bucket Name.
      parent_name          = optional(string, null),      # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.
      parent_complete_name = optional(string, null),      # Project ID. if "BOOTSTRAP" it will be created on bootstrap project.
      location             = optional(string, null)       # Bucket location.
      storage_class        = optional(string, "STANDARD") # Storage Class (Default: STANDARD).
      versioning           = optional(bool, false)        # (Default: False).
      labels               = optional(map(string), {})
      force_destroy        = optional(bool, false)
      lifecycle_rules = optional(map(object({
        action = object({ # Storage class to change when conditions is fulfilled.
          type          = string
          storage_class = optional(string)
        })
        condition = object({ # Conditions to accomplish
          age                        = optional(number)
          created_before             = optional(string)
          custom_time_before         = optional(string)
          days_since_custom_time     = optional(number)
          days_since_noncurrent_time = optional(number)
          matches_prefix             = optional(list(string))
          matches_storage_class      = optional(list(string)) # STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE, DURABLE_REDUCED_AVAILABILITY
          matches_suffix             = optional(list(string))
          noncurrent_time_before     = optional(string)
          num_newer_versions         = optional(number)
          with_state                 = optional(string) # "LIVE", "ARCHIVED", "ANY"
        })
      })), {})
  }))
  description = "Buckets Configuration"
  default     = []
}

variable "service_accounts" {
  type = list(object({
    name                   = optional(string, null),                   # (When complete_name is not specified) Completed with '[SA_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.
    complete_name          = optional(string, null),                   # Service Account ID
    parent_name            = optional(string, null),                   # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.
    parent_complete_name   = optional(string, null),                   # Project ID. If "BOOTSTRAP" it will be created on bootstrap project.
    description            = optional(string, "Managed by Terraform"), # (default: Managed by Terraform)
    service_account_create = optional(bool, true)
    # On Folder, Storage and Project roles, if you are using prefix to autocomplete names and ids
    # then you write on each ID "[PREFIX]NAME" and it will be autocompleted with prefixes used on each element.            
    iam_project_roles      = optional(map(list(string)), {}) # IAM Project Roles for SA. Format {"PROJECT_ID" => [ROLES_LIST]}. IF PROJECT_ID contains [PREFIX] it will be replaced with PREFIXES.
    iam_storage_roles      = optional(map(list(string)), {}) # IAM Storage Roles for SA. Format {"BUCKET_ID" => [ROLES_LIST]}. IF BUCKET_ID contains [PREFIX] it will be replaced with PREFIXES. If BUCKET_ID = "ROOT" it will use parent_root value
    iam_sa_roles           = optional(map(list(string)), {}) # IAM SA Roles for SA. Format {"SA_ID" => [ROLES_LIST]} 
    iam_folder_roles       = optional(map(list(string)), {}) # IAM Folder Roles for SA. Format {"FOLDER_ID" => [ROLES_LIST]}. IF FOLDER_ID contains [PREFIX] it will be replaced with PREFIXES.
    iam_organization_roles = optional(list(string), [])      # IAM Organization Roles for SA. Format [ROLES_LIST]
    iam_bindings = optional(map(object({                     # IAM Roles on SA for other members. Format {"ROL" => {role = "ROL", members = [LIST_MEMBERS]} 
      members = list(string)                                 # Each member starts with user, group or serviceAccount
      role    = string
      condition = optional(object({
        expression  = string
        title       = string
        description = optional(string)
      }))
    })), {})
  }))
  default     = []
  description = "Service Account Configuration"
}

