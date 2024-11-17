output "vpcs" {
  value = [for k, v in module.network : v.network_id]
}

output "subnets" {
  value = flatten([for k, v in module.network : v.subnets_ids])
}

output "peering" {
  value = [for k, v in module.peering : { local_network_peering : v.local_network_peering.id, peer_network_peering : v.peer_network_peering.id }]
}

output "iam_network_user" {
  value = [for k, v in google_compute_subnetwork_iam_member.networkuser : { member : v.member, subnetwork : v.subnetwork }]
}

output "cloud_router" {
  value = [for k, v in module.cloud_router : { router : v.router.id, network : v.router.network }]
}

output "cloud_nat" {
  value = module.cloud-nat
}

output "ha_vpn" {
  value     = module.ha_vpn
  sensitive = true
}

output "vpn" {
  value     = module.vpn
  sensitive = true
}

output "dns" {
  value = [for k, v in module.dns : v]
}

output "address" {
  value = [for k in tolist(module.address) : { "addresses" : k.addresses, "names" : k.names, "self_links" : k.self_links }]
}

