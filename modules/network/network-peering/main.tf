#--------------------
# Local declarations
#--------------------

locals {
  vnet_src_parts               = split("/", var.vnet_src_id)
  vnet_src_name                = element(local.vnet_src_parts, 8)
  vnet_src_resource_group_name = element(local.vnet_src_parts, 4)
}

#--------------------
# Peerings resources
#--------------------

resource "azurerm_virtual_network_peering" "peering_src" {

  name                         = var.peering_src_name
  resource_group_name          = local.vnet_src_resource_group_name
  virtual_network_name         = local.vnet_src_name
  remote_virtual_network_id    = var.vnet_dest_id
  allow_virtual_network_access = var.allow_virtual_src_network_access
  allow_forwarded_traffic      = var.allow_forwarded_src_traffic
  allow_gateway_transit        = var.allow_gateway_src_transit
  use_remote_gateways          = var.use_remote_src_gateway
}
