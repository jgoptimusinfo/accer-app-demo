## --------------------------------------------------------
##  locals
## --------------------------------------------------------

locals {
  virtual_hub_id = "/subscriptions/3124b81f-32b6-49f2-98d6-7500ef2a165f/resourceGroups/accern-nwsvcs-prd-eus2-rg/providers/Microsoft.Network/virtualHubs/acn-virtual-hub-prd"
  spoke_prd_aks_vnet_id = "/subscriptions/3124b81f-32b6-49f2-98d6-7500ef2a165f/resourceGroups/accern-nwsvcs-prd-eus2-rg/providers/Microsoft.Network/virtualNetworks/acn-spoke-prd-aks-vnet"
}

## --------------------------------------------------------
##  Network - Virtual hub Connections
## --------------------------------------------------------

# Spoke PRD-AKS to Virtual Hub
 
resource "azurerm_virtual_hub_connection" "spoke_prd_aks_vhub" {
  name                      = "spoke-prd-aks-hub"
  virtual_hub_id            = local.virtual_hub_id
  remote_virtual_network_id = local.spoke_prd_aks_vnet_id
}

 