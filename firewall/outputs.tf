
output "firewall_resources" {
  value = module.firewall.resource.virtual_hub[*]
}