## --------------------------------------------------------
##  locals
## --------------------------------------------------------
/* 
locals { 
  firewall_resource_group_name = "accern-nwsvcs-prd-eus2-rg"
  virtual_hub_id = "/subscriptions/3124b81f-32b6-49f2-98d6-7500ef2a165f/resourceGroups/accern-nwsvcs-prd-eus2-rg/providers/Microsoft.Network/virtualHubs/acn-virtual-hub-prd"
}

## --------------------------------------------------------
##  Azure Firewall - Policy
## --------------------------------------------------------

resource "azurerm_firewall_policy" "fw_pol01" {
  name                = "acn-vwan-hub-fw-pol01"
  resource_group_name = local.firewall_resource_group_name
  location            = var.location
}

## --------------------------------------------------------
##  Azure Firewall
## --------------------------------------------------------

resource "azurerm_firewall" "virtual_wan_fw01" {
  name                = "acn-vwan-fw01"
  location            = var.location
  resource_group_name = local.firewall_resource_group_name
  sku_tier            = "Premium"
  sku_name            = "AZFW_Hub"
  firewall_policy_id  = azurerm_firewall_policy.fw_pol01.id
  virtual_hub {
    virtual_hub_id = local.virtual_hub_id
    public_ip_count = 2
  }
}

## --------------------------------------------------------
##  Azure Firewall - Roting intent
## --------------------------------------------------------

resource "azurerm_virtual_hub_routing_intent" "fw_routing_intent" {
  name           = "acn-vwan-hub-routingintent"
  virtual_hub_id = local.virtual_hub_id

  routing_policy {
    name         = "InternetTrafficPolicy"
    destinations = ["Internet"]
    next_hop     = azurerm_firewall.virtual_wan_fw01.id
  }
}

## --------------------------------------------------------
##  Azure Firewall - Policy - Rule Collection Group
## --------------------------------------------------------

resource "azurerm_firewall_policy_rule_collection_group" "policy_rule_01" {
  name               = "acn-vwan-hub-fw-pol01-rules"
  firewall_policy_id = azurerm_firewall_policy.fw_pol01.id
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


  */