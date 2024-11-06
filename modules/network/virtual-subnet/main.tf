#--------------------
# Local declarations
#--------------------

locals {
  vnet_resource_group_name = split("/", var.vnet_id)[4]
  vnet_name                = split("/", var.vnet_id)[8]
}

#--------------------------
# Azure Subnets
# -------------------------

resource "azurerm_subnet" "subnet" {

  name                                          = var.subnet.name
  resource_group_name                           = local.vnet_resource_group_name
  virtual_network_name                          = local.vnet_name
  address_prefixes                              = var.subnet.address_prefixes
  private_endpoint_network_policies             = var.subnet.private_endpoint_network_policies
  private_link_service_network_policies_enabled = var.subnet.private_link_service_network_policies_enabled

  service_endpoints           = var.service_endpoints
  service_endpoint_policy_ids = var.service_endpoint_policy_ids

  dynamic "delegation" {
    for_each = var.service_delegation_name == null ? [] : [1]
    content {
      name = "delegation"
      service_delegation {
        name    = var.service_delegation_name
        actions = var.service_delegation_actions
      }
    }
  }
}

resource "azurerm_subnet_route_table_association" "asc_rt" {
  count = var.default_route_table_asociate == true ? 1 : 0

  subnet_id      = azurerm_subnet.subnet.id
  route_table_id = var.default_route_table_id
}