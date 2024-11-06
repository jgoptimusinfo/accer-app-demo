#--------------------------
# Azure Subnets
# -------------------------

resource "azurerm_subnet" "subnet" {
  for_each                                      = var.subnets
  name                                          = each.value.name != "GatewaySubnet" ? "${local.prefix}-${local.subnet_code}-${each.value.name}" : each.value.name
  resource_group_name                           = local.vnet_resource_group_name
  virtual_network_name                          = local.vnet_name
  address_prefixes                              = each.value.address_prefixes
  private_endpoint_network_policies             = each.value.private_endpoint_network_policies
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled

  service_endpoints           = each.value.service_endpoints
  service_endpoint_policy_ids = each.value.service_endpoint_policy_ids

  dynamic "delegation" {
    for_each = each.value.service_delegation_name == null ? [] : [1]
    content {
      name = "delegation"
      service_delegation {
        name    = each.value.service_delegation_name
        actions = each.value.service_delegation_actions
      }
    }
  }
}