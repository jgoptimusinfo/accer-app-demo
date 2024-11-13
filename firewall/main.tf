## --------------------------------------------------------
##  locals
## --------------------------------------------------------

locals { 
  firewall_resource_group_name = "accern-nwsvcs-prd-eus2-rg"
  virtual_hub_id = "/subscriptions/3124b81f-32b6-49f2-98d6-7500ef2a165f/resourceGroups/accern-nwsvcs-prd-eus2-rg/providers/Microsoft.Network/virtualHubs/acn-virtual-hub-prd"
}

## --------------------------------------------------------
##  Azure Firewall - Policy
## --------------------------------------------------------

module "firewall_policy" {
  
  source             = "Azure/avm-res-network-firewallpolicy/azurerm"
  version            = "0.3.2"

  enable_telemetry    = false
  name                = "acn-vwan-hub-fw-pol01"
  location            = var.location
  resource_group_name = local.firewall_resource_group_name
  
  tags = var.tags
}

module "rule_collection_group" {

  source             = "Azure/avm-res-network-firewallpolicy/azurerm//modules/rule_collection_groups"
  version            = "0.3.2"

  firewall_policy_rule_collection_group_firewall_policy_id = module.firewall_policy.resource.id
  firewall_policy_rule_collection_group_name               = "acn-vwan-hub-fw-pol01-rules"
  firewall_policy_rule_collection_group_priority           = 400
  firewall_policy_rule_collection_group_network_rule_collection = [
    {
      action   = "Allow"
      name     = "NetworkRuleCollection"
      priority = 400
      rule = [
        {
          name                  = "OutboundToInternet"
          description           = "Allow traffic outbound to the Internet"
          destination_addresses = ["*"] # ["0.0.0.0/0"]
          destination_ports     = ["*"] # ["443"]
          source_addresses      = ["*"] # ["10.0.0.0/24"]
          protocols             = ["TCP", "UDP", "ICMP"] # ["TCP"]
        }
      ]
    }
  ]
  firewall_policy_rule_collection_group_application_rule_collection = [
    {
      action   = "Allow"
      name     = "ApplicationRuleCollection"
      priority = 600
      rule = [
        {
          name             = "AllowAll"
          description      = "Allow traffic to Microsoft.com"
          source_addresses = ["10.0.0.0/24"]
          protocols = [
            {
              port = 443
              type = "Https"
            }
          ]
          destination_fqdns = ["microsoft.com"]
        }
      ]
    }
  ]
  firewall_policy_rule_collection_group_nat_rule_collection = [
    {
      action   = "Dnat"
      name     = "NatRuleCollection"
      priority = 100
      rule = [
        {
          name                  = "DNATRule"
          description           = "DNAT rule for inbound https traffic"
          translated_address    = "172.16.1.5"
          translated_port       = 443
          source_addresses      = ["*"]
          destination_addresses = ["*"]
          destination_ports     = ["443"]
          protocols             = ["TCP"]
        }
      ]
    }
  ]
}

## --------------------------------------------------------
##  Azure Firewall
## --------------------------------------------------------

module "firewall" {
  
  source  = "Azure/avm-res-network-azurefirewall/azurerm"
  version = "0.3.0"
  enable_telemetry   = false

  name                = "acn-vwan-fw01"
  location            = var.location
  resource_group_name = local.firewall_resource_group_name
  
  firewall_sku_tier   = "Standard"
  firewall_sku_name   = "AZFW_Hub"
  firewall_zones      = ["1"] #["1", "2", "3"]
  firewall_virtual_hub = {
    virtual_hub_id  = local.virtual_hub_id
    public_ip_count = 2
  }
  firewall_policy_id = module.firewall_policy.resource.id

  tags = var.tags
}

## --------------------------------------------------------
##  Azure Firewall - OLD Code
## --------------------------------------------------------

/* 
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