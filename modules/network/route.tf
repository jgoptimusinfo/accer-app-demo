#--------------------------
# Route Table 
# -------------------------

# Setting up the route table 
resource "azurerm_route_table" "spoke_route_table" {
  count = length(var.routes) > 0 ? 1 : 0

  name                          = local.route_table_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  bgp_route_propagation_enabled = true

  tags = var.tags
}

# Setup default routes in route table
resource "azurerm_route" "spoke_route" {
  for_each = var.routes

  name                   = each.value.name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.spoke_route_table[0].name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address
}

# Setup route table association with subnets
resource "azurerm_subnet_route_table_association" "route_table_assoc" {
  for_each       = length(var.routes) > 0 ? { for key, value in var.subnets : key => value if key != "GatewaySubnet" } : {}
  subnet_id      = azurerm_subnet.subnet[each.key].id
  route_table_id = azurerm_route_table.spoke_route_table[0].id
}
