output "name" {
  description = "Subnet name."
  value       = azurerm_subnet.subnet.name
}

output "id" {
  description = "Subnet ID."
  value       = azurerm_subnet.subnet.id
}

output "resource_group_name" {
  description = "Resource Group name in which the subnet is created in."
  value       = azurerm_subnet.subnet.resource_group_name
}

output "virtual_network_name" {
  description = "The name of the virtual network in which the subnet is created in."
  value       = azurerm_subnet.subnet.virtual_network_name
}