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


## --------------------------------------------------------
##  Network - Main
## --------------------------------------------------------

module "vnet_spoke_aks" {
  source = "../modules/network"

  location            = var.location
  prefix_name         = "acn-spoke-aks"
  resource_group_name = module.rg_main_network.name

  address_space = ["10.200.1.0/24"]
  subnets       = {
      appgw_snet = {
        name                                          = "appgw"
        address_prefixes                              = ["10.200.1.0/25"]
        private_endpoint_network_policies             = "Disabled"
        private_link_service_network_policies_enabled = true
      },
      aks_snet = {
        name                                          = "aks"
        address_prefixes                              = ["10.200.1.128/25"]
        private_endpoint_network_policies             = "Disabled"
        private_link_service_network_policies_enabled = true
      }
  }

  routes        = {}
  enable_vpn_gateway = false

  tags = var.tags
}