resource "azurerm_virtual_wan" "virtual_wan" {
  name                = "example-virtualwan"
  resource_group_name = module.rg_main_network.name
  location            = module.rg_main_network.location
}

resource "azurerm_virtual_hub" "virtual_hub" {
  name                = "example-virtualhub"
  resource_group_name = module.rg_main_network.name
  location            = module.rg_main_network.location
  virtual_wan_id      = azurerm_virtual_wan.virtual_wan.id
  address_prefix      = "10.200.0.0/22"
}