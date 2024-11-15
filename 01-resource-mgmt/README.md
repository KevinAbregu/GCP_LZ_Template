<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bucket"></a> [bucket](#module\_bucket) | github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/gcs | v28.0.0 |
| <a name="module_folder-01"></a> [folder-01](#module\_folder-01) | github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/folder | v28.0.0 |
| <a name="module_folder-02"></a> [folder-02](#module\_folder-02) | github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/folder | v28.0.0 |
| <a name="module_folder-03"></a> [folder-03](#module\_folder-03) | github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/folder | v28.0.0 |
| <a name="module_org"></a> [org](#module\_org) | github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/organization | v28.0.0 |
| <a name="module_project"></a> [project](#module\_project) | github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/project | v28.0.0 |
| <a name="module_service-account"></a> [service-account](#module\_service-account) | github.com/GoogleCloudPlatform/cloud-foundation-fabric//modules/iam-service-account | v28.0.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_shared_vpc_service_project.shared_vpc_service](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_shared_vpc_service_project) | resource |
| [terraform_remote_state.bootstrap](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/data-sources/remote_state) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_parent_root"></a> [parent\_root](#input\_parent\_root) | Root Folder/Organization ID from where resources will be created. | `string` | n/a | yes |
| <a name="input_buckets"></a> [buckets](#input\_buckets) | Buckets Configuration | <pre>list(object(<br>    {<br>      name                 = optional(string, null),      # (When complete_name is not specified) Completed with '[BUCKET_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.<br>      complete_name        = optional(string, null),      # Bucket Name.<br>      parent_name          = optional(string, null),      # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.<br>      parent_complete_name = optional(string, null),      # Project ID.<br>      location             = optional(string, null)       # Bucket location.<br>      storage_class        = optional(string, "STANDARD") # Storage Class (Default: STANDARD).<br>      versioning           = optional(bool, false)        # (Default: False).<br>      labels               = optional(map(string), {})<br>      force_destroy        = optional(bool, false)<br>      lifecycle_rules = optional(map(object({<br>        action = object({ # Storage class to change when conditions is fulfilled.<br>          type          = string<br>          storage_class = optional(string)<br>        })<br>        condition = object({ # Conditions to accomplish<br>          age                        = optional(number)<br>          created_before             = optional(string)<br>          custom_time_before         = optional(string)<br>          days_since_custom_time     = optional(number)<br>          days_since_noncurrent_time = optional(number)<br>          matches_prefix             = optional(list(string))<br>          matches_storage_class      = optional(list(string)) # STANDARD, MULTI_REGIONAL, REGIONAL, NEARLINE, COLDLINE, ARCHIVE, DURABLE_REDUCED_AVAILABILITY<br>          matches_suffix             = optional(list(string))<br>          noncurrent_time_before     = optional(string)<br>          num_newer_versions         = optional(number)<br>          with_state                 = optional(string) # "LIVE", "ARCHIVED", "ANY"<br>        })<br>      })), {})<br>  }))</pre> | `[]` | no |
| <a name="input_fldr_prefix"></a> [fldr\_prefix](#input\_fldr\_prefix) | Folder prefix to add for folders created where applicable. | `string` | `"g-fldr"` | no |
| <a name="input_folders"></a> [folders](#input\_folders) | Folders configuration | <pre>map(list(object(<br>    {<br>      name                   = optional(string, null) # (When complete_name is not specified). Completed with '[FLDR_PREFIX]-[NAME]'.<br>      complete_name          = optional(string, null) # Folder complete name.<br>      parent_complete_name   = optional(string, null) # Parent Folder Name.<br>      parent_name            = optional(string, null) # (When parent_complete_name is not specified). Completed with '[FLDR_PREFIX]-[NAME]'.<br>      org_policies_data_path = optional(string, null) # Indicates a folder path with organization policies in yaml files. Inside 'org-policies-config/folders/[PATH]'.<br>      aux_tf_key             = optional(string, null) # Variable used when there's a folder name coincidence to differenciate between them.<br>    }))<br>  )</pre> | `{}` | no |
| <a name="input_organization_policies"></a> [organization\_policies](#input\_organization\_policies) | Organization policies that  must be activated at org level. Its configuration is 'org-policies-config/organization/*.yaml' | `bool` | `false` | no |
| <a name="input_projects"></a> [projects](#input\_projects) | Projects configuration | <pre>list(object(<br>    {<br>      complete_name                   = optional(string, null)      # Project ID.<br>      name                            = optional(string, null)      # (When complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.<br>      descriptive_name                = optional(string, null)      # Display Project Name. If not specified it is as Project ID.<br>      parent_name                     = optional(string, null)      # (When parent_complete_name is not specified) Completed with => '[FLDR_PREFIX]-[PARENT_NAME]'.<br>      parent_complete_name            = optional(string, null)      # Parent Folder Name.<br>      services                        = optional(list(string), []), # APIs that are activated.<br>      prefix                          = optional(string, null),     # Prefix to include in the name.<br>      svpc_host                       = optional(bool, false),      # If true, this project is a host project.<br>      svpc_service_host_name          = optional(string, null),     # (When svpc_service_host_complete_name is not specified AND this project is a service project) Host Project ID completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.<br>      svpc_service_host_complete_name = optional(string, null),     # This project is a service project of the Hos t Project ID indicated in this variable.<br>      org_policies_data_path          = optional(string, null)      # Indicates a folder path with organization policies in yaml files. Inside org-policies-config/projects/[PATH]<br>      default_service_account         = optional(string, "disable") # Indicates default service account initial state (default disable).<br>      labels                          = optional(map(string), {})   # Labels to include in the project.<br><br>    })<br>  )</pre> | `[]` | no |
| <a name="input_service_accounts"></a> [service\_accounts](#input\_service\_accounts) | Service Account Configuration | <pre>list(object({<br>    name                   = optional(string, null),                   # (When complete_name is not specified) Completed with '[SA_PREFIX]-[COMPANY_ABBREVIATION]-[NAME]'.<br>    complete_name          = optional(string, null),                   # Service Account ID<br>    parent_name            = optional(string, null),                   # (When parent_complete_name is not specified) Completed with '[PROJECT_PREFIX]-[COMPANY_ABBREVIATION]-[PARENT_NAME]'.<br>    parent_complete_name   = optional(string, null),                   # Project ID.<br>    description            = optional(string, "Managed by Terraform"), # (default: Managed by Terraform)<br>    service_account_create = optional(bool, true)<br>    # On Folder, Storage and Project roles, if you are using prefix to autocomplete names and ids<br>    # then you write on each ID "[PREFIX]NAME" and it will be autocompleted with prefixes used on each element.            <br>    iam_project_roles      = optional(map(list(string)), {}) # IAM Project Roles for SA. Format {"PROJECT_ID" => [ROLES_LIST]}<br>    iam_storage_roles      = optional(map(list(string)), {}) # IAM Storage Roles for SA. Format {"BUCKET_ID" => [ROLES_LIST]}<br>    iam_sa_roles           = optional(map(list(string)), {}) # IAM SA Roles for SA. Format {"SA_ID" => [ROLES_LIST]}<br>    iam_folder_roles       = optional(map(list(string)), {}) # IAM Folder Roles for SA. Format {"FOLDER_ID" => [ROLES_LIST]}<br>    iam_organization_roles = optional(list(string), [])      # IAM Organization Roles for SA. Format [ROLES_LIST]<br>    iam_bindings = optional(map(object({                     # IAM Roles on SA for other members. Format {"ROL" => {role = "ROL", members = [LIST_MEMBERS]} <br>      members = list(string)                                 # Each member starts with user, group or serviceAccount<br>      role    = string<br>      condition = optional(object({<br>        expression  = string<br>        title       = string<br>        description = optional(string)<br>      }))<br>    })), {})<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_buckets"></a> [buckets](#output\_buckets) | n/a |
| <a name="output_folders"></a> [folders](#output\_folders) | n/a |
| <a name="output_projects"></a> [projects](#output\_projects) | n/a |
| <a name="output_service-accounts"></a> [service-accounts](#output\_service-accounts) | n/a |
<!-- END_TF_DOCS -->