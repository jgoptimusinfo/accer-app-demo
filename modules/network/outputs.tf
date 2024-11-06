#--------------------------
# Virtula Network Outputs
# -------------------------

output "vnet_id" {
  description = "The id of the created virtual network"
  value       = azurerm_virtual_network.vnet.id
}

output "vnet_name" {
  description = "The name of the created virtual network"
  value       = azurerm_virtual_network.vnet.name
}

#--------------------------
# Subnets Outputs
# -------------------------

output "subnet_ids" {
  description = "List of ids of the created subnet(s)"
  value       = values(azurerm_subnet.subnet)[*].id
}

output "subnet_name_id_map" {
  description = "Map of subnet full names to subnet ids"
  value       = zipmap(values(azurerm_subnet.subnet)[*].name, values(azurerm_subnet.subnet)[*].id)
}

output "subnet_shortname_id_map" {
  description = "Map of subnet short names to subnet ids"
  value       = zipmap(keys(var.subnets)[*], values(azurerm_subnet.subnet)[*].id)
}

#--------------------------
# VPN Gateway Outputs
# -------------------------

output "vpn_gateway_id" {
  description = "The resource ID of the virtual network gateway"
  value       = try(module.vpn-gateway[0].vpn_gateway_id, null)
}

output "vpn_gateway_public_ip" {
  description = "The public IP of the virtual network gateway"
  value       = try(module.vpn-gateway[0].vpn_gateway_public_ip, null)
}

output "vpn_gateway_public_ip_fqdn" {
  description = "Fully qualified domain name of the virtual network gateway"
  value       = try(module.vpn-gateway[0].vpn_gateway_public_ip_fqdn, null)
}
