#--------------------
# output
#--------------------

output "vnet_peering_src_id" {
  description = "Virtual network src peering id"
  value       = azurerm_virtual_network_peering.peering_src.id
}

output "vnet_peering_src_name" {
  description = "Virtual network src peering name"
  value       = azurerm_virtual_network_peering.peering_src.name
}