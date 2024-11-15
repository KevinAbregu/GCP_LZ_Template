<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bootstrap"></a> [bootstrap](#module\_bootstrap) | ../modules/terraform-google-bootstrap-master | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_billing_account"></a> [billing\_account](#input\_billing\_account) | The ID of the billing account to associate projects with. | `string` | n/a | yes |
| <a name="input_company_abbreviation"></a> [company\_abbreviation](#input\_company\_abbreviation) | Company Abbreviation to add for resources created where applicable | `string` | n/a | yes |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region to create resources where applicable. | `string` | n/a | yes |
| <a name="input_group_org_admins"></a> [group\_org\_admins](#input\_group\_org\_admins) | Google Group for GCP Organization Administrators | `string` | n/a | yes |
| <a name="input_org_id"></a> [org\_id](#input\_org\_id) | GCP Organization ID | `string` | n/a | yes |
| <a name="input_activate_apis"></a> [activate\_apis](#input\_activate\_apis) | List of APIs to enable in the seed project. | `list(string)` | <pre>[<br>  "serviceusage.googleapis.com",<br>  "servicenetworking.googleapis.com",<br>  "compute.googleapis.com",<br>  "logging.googleapis.com",<br>  "bigquery.googleapis.com",<br>  "cloudresourcemanager.googleapis.com",<br>  "cloudbilling.googleapis.com",<br>  "iam.googleapis.com",<br>  "admin.googleapis.com",<br>  "appengine.googleapis.com",<br>  "storage-api.googleapis.com",<br>  "monitoring.googleapis.com"<br>]</pre> | no |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | Bucket Prefix to add for buckets created where applicable | `string` | `"bkt"` | no |
| <a name="input_folder_id"></a> [folder\_id](#input\_folder\_id) | The ID of a folder to host this project | `string` | `""` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | If supplied, the state bucket will be deleted even while containing objects. | `bool` | `false` | no |
| <a name="input_grant_billing_user"></a> [grant\_billing\_user](#input\_grant\_billing\_user) | Grant roles/billing.user role to CFT service account | `bool` | `false` | no |
| <a name="input_parent_folder"></a> [parent\_folder](#input\_parent\_folder) | GCP parent folder ID in the form folders/{id} | `string` | `""` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | Custom project ID to use for project created. (if not specified => '[PROJECT\_PREFIX]-[COMPANY\_ABBREVIATION]-bootstrap' is created) | `string` | `null` | no |
| <a name="input_project_labels"></a> [project\_labels](#input\_project\_labels) | Labels to apply to the project. | `map(string)` | <pre>{<br>  "environment": "bootstrap"<br>}</pre> | no |
| <a name="input_project_prefix"></a> [project\_prefix](#input\_project\_prefix) | Project Prefix to add for projects created where applicable | `string` | `"g-prj"` | no |
| <a name="input_random_suffix"></a> [random\_suffix](#input\_random\_suffix) | Appends a 4 character random suffix to project ID and GCS bucket name. | `bool` | `false` | no |
| <a name="input_sa_enable_impersonation"></a> [sa\_enable\_impersonation](#input\_sa\_enable\_impersonation) | Allow org\_admins group to impersonate service account & enable APIs required. | `bool` | `true` | no |
| <a name="input_sa_org_iam_permissions"></a> [sa\_org\_iam\_permissions](#input\_sa\_org\_iam\_permissions) | List of permissions granted to Terraform service account across the GCP organization/Root Folder. | `list(string)` | <pre>[<br>  "roles/billing.user",<br>  "roles/compute.networkAdmin",<br>  "roles/compute.xpnAdmin",<br>  "roles/iam.securityAdmin",<br>  "roles/iam.serviceAccountAdmin",<br>  "roles/logging.admin",<br>  "roles/orgpolicy.policyAdmin",<br>  "roles/resourcemanager.folderAdmin",<br>  "roles/resourcemanager.organizationAdmin",<br>  "roles/iam.denyAdmin",<br>  "roles/resourcemanager.projectCreator",<br>  "roles/accesscontextmanager.policyAdmin",<br>  "roles/storage.admin"<br>]</pre> | no |
| <a name="input_sa_prefix"></a> [sa\_prefix](#input\_sa\_prefix) | Service Account Prefix to add for service accounts created where applicable | `string` | `"sa"` | no |
| <a name="input_state_bucket_name"></a> [state\_bucket\_name](#input\_state\_bucket\_name) | Custom state bucket name (if not specified => '[BUCKET\_PREFIX]-[COMPANY\_ABBREVIATION]-bootstrap' is created) | `string` | `null` | no |
| <a name="input_tf_service_account_id"></a> [tf\_service\_account\_id](#input\_tf\_service\_account\_id) | ID of service account for terraform in seed project (if not specified => '[SA\_PREFIX]-[COMPANY\_ABBREVIATION]-bootstrap' is created) | `string` | `null` | no |
| <a name="input_tf_service_account_name"></a> [tf\_service\_account\_name](#input\_tf\_service\_account\_name) | Display name of service account for terraform in seed project. | `string` | `"CFT Organization Terraform Account"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bootstrap"></a> [bootstrap](#output\_bootstrap) | n/a |
| <a name="output_configuration_variables"></a> [configuration\_variables](#output\_configuration\_variables) | n/a |
<!-- END_TF_DOCS -->