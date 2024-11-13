/* 
output "firewall_resources" {
  value = module.firewall.resource.virtual_hub[*]
}

output "firewall_resources_private_ip" {
  value = module.firewall.resource.virtual_hub[*].private_ip_address
}

output "firewall_resources_public_ip_one" {
  value = module.firewall.resource.virtual_hub[*].public_ip_addresses[0]
}

output "firewall_resources_public_ip_two" {
  value = module.firewall.resource.virtual_hub[*].public_ip_addresses[1]
} */