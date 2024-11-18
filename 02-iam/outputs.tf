output "service_accounts" {
  value = [for k, v in module.service-account: v.service_account.member]
}