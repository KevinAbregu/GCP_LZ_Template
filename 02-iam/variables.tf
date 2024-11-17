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

