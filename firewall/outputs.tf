output "firewall_resources" {
  value = module.firewall.resource.virtual_hub
}

output "firewall_private_ip" {
  value = module.firewall.resource.virtual_hub[0].firewall_resources
}

# output "firewall_public_ip" {
#   value = module.firewall.resource.virtual_hub[0].firewall_resources[0].public_ip_addresses
# }