
## --------------------------------------------------------
##  Network - Main
## --------------------------------------------------------

module "vnet_main_network" {
  source = "../modules/network"

  location            = var.location
  prefix_name         = var.virtual_network_prefix_name
  resource_group_name = module.rg_main_network.name

  address_space = [var.virtual_network_address_space]
  subnets       = var.subnets
  routes        = var.routes

  enable_vpn_gateway = var.enable_vpn_gateway

  tags = var.tags
}

## --------------------------------------------------------
##  NETWORK PEERINGS - Create peering from spoke to transit VNet
## --------------------------------------------------------
/* 
module "source_peering" {
  source = "git::https://git-codecommit.us-east-2.amazonaws.com/v1/repos/az-virtual-network//network-peering"

  peering_src_name = local.spoke_peering_name
  vnet_src_id      = module.network.vnet_id
  vnet_dest_id     = local.transit_vnet_id

  allow_virtual_src_network_access = true
  allow_forwarded_src_traffic      = true
  allow_gateway_src_transit        = false
  use_remote_src_gateway           = false
}

## ----------------------------------------------------------------
## NETWORK PEERINGS - Create peering from transit VNet to spoke 
## need network contributor on remote vnet resource group for this sp
## ----------------------------------------------------------------

module "destination_peering" {
  providers = {
    azurerm = azurerm.connectivity
  }
  source = "git::https://git-codecommit.us-east-2.amazonaws.com/v1/repos/az-virtual-network//network-peering"

  peering_src_name = local.transit_peering_name
  vnet_src_id      = local.transit_vnet_id
  vnet_dest_id     = module.network.vnet_id

  allow_virtual_src_network_access = true
  allow_forwarded_src_traffic      = true
  allow_gateway_src_transit        = true
  use_remote_src_gateway           = false
}
 */