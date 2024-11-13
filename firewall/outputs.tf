output "firewall_resources" {
  value = module.firewall.resource.virtual_hub
}
/* 
output "firewall_policy" {
  value = module.firewall_policy.resource
}

output "firewall_private_ip" {
  value = module.firewall.resource.virtual_hub.private_ip_address
}

output "firewall_public_ip" {
  value = module.firewall.resource.virtual_hub.public_ip_addresses
}

output "firewall_public_ip_1" {
  value = module.firewall.resource.virtual_hub.public_ip_addresses[0]
}

output "firewall_public_ip_2" {
  value = module.firewall.resource.virtual_hub.public_ip_addresses[1]
} */