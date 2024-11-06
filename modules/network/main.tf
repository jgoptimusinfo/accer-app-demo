## --------------------------------------------------------
##  LOCALS
## --------------------------------------------------------

locals {
  prefix = var.prefix_name
  suffix = var.suffix_name

  vnet_code        = "vnet"
  subnet_code      = "snet"
  route_table_code = "rt"

  vnet_name        = "${local.prefix}-${local.vnet_code}${local.suffix}"
  route_table_name = "${local.prefix}-${local.route_table_code}${local.suffix}"
  vnet_id          = azurerm_virtual_network.vnet.id

  vnet_resource_group_name = split("/", local.vnet_id)[4]
}