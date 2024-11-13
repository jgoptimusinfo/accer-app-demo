output "firewall_resources" {
  value = module.firewall.resource.virtual_hub
}

output "firewall_policy" {
  value = module.firewall_policy.resource
}