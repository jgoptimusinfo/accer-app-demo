
## --------------------------------------------------------
##  Virtual WAN - Resource Testings
## --------------------------------------------------------

 
module "vnet_spoke_aks" {
  source = "../modules/network"

  location            = var.location
  prefix_name         = "acn-spoke-aks"
  resource_group_name = module.rg_main_network.name

  address_space = ["172.16.1.0/24"]
  subnets       = {
      appgw_snet = {
        name                                          = "appgw"
        address_prefixes                              = ["172.16.1.0/25"]
        private_endpoint_network_policies             = "Disabled"
        private_link_service_network_policies_enabled = true
      },
      aks_snet = {
        name                                          = "aks"
        address_prefixes                              = ["172.16.1.128/25"]
        private_endpoint_network_policies             = "Disabled"
        private_link_service_network_policies_enabled = true
      }
  }

  routes        = {}
  enable_vpn_gateway = false

  tags = var.tags
}

## --------------------------------------------------------
##  Virtual WAN
## --------------------------------------------------------

resource "azurerm_virtual_wan" "virtual_wan" {
  name                = "acn-virtual-wan-prd"
  resource_group_name = module.rg_main_network.name
  location            = module.rg_main_network.location
}

resource "azurerm_virtual_hub" "virtual_hub" {
  name                = "acn-virtual-hub-prd"
  resource_group_name = module.rg_main_network.name
  location            = module.rg_main_network.location
  virtual_wan_id      = azurerm_virtual_wan.virtual_wan.id
  address_prefix      = "10.200.0.0/22"
}


resource "azurerm_virtual_hub_connection" "spoke_aks_vhub" {
  name                      = "spoke-aks-vhub"
  virtual_hub_id            = azurerm_virtual_hub.virtual_hub.id
  remote_virtual_network_id = module.vnet_spoke_aks.vnet_id
}

/*

## --------------------------------------------------------
##  Azure Firewall
## --------------------------------------------------------

resource "azurerm_firewall" "virtual_wan_fw01" {
  name                = "acn-vwan-fw01"
  location            = var.location
  resource_group_name = module.rg_main_network.name
  sku_tier            = "Premium"
  sku_name            = "AZFW_Hub"
  firewall_policy_id  = azurerm_firewall_policy.fw-pol01.id
  virtual_hub {
    virtual_hub_id = azurerm_virtual_hub.virtual_hub.id
    public_ip_count = 1
  }
}


## --------------------------------------------------------
##  Azure Firewall - Policy
## --------------------------------------------------------

resource "azurerm_firewall_policy" "fw-pol01" {
  name                = "fw-pol01"
  resource_group_name = module.rg_main_network.name
  location            = var.location
}

## --------------------------------------------------------
##  Azure Firewall - Policy - Rule Collection Group
## --------------------------------------------------------

resource "azurerm_firewall_policy_rule_collection_group" "region1-policy1" {
  name               = "fw-pol01-rules"
  firewall_policy_id = azurerm_firewall_policy.fw-pol01.id
  priority           = 100
  network_rule_collection {
    name     = "network_rules1"
    priority = 100
    action   = "Allow"
    rule {
      name                  = "network_rule_collection1_rule1"
      protocols             = ["TCP", "UDP", "ICMP"]
      source_addresses      = ["*"]
      destination_addresses = ["*"]
      destination_ports     = ["*"]
    }
  }
}

## --------------------------------------------------------
##  Azure Firewall - Roting intent
## --------------------------------------------------------

resource "azurerm_virtual_hub_routing_intent" "fw_routing_intent" {
  name           = "acn-routingintent"
  virtual_hub_id = azurerm_virtual_hub.virtual_hub.id

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.virtual_wan_fw01.id
  }
} */