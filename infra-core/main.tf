## --------------------------------------------------------
##  Shared - locals
## --------------------------------------------------------

locals {
  shared_resource_group_name = var.shared_resource_group_name
}

data "azurerm_client_config" "current" {}

## --------------------------------------------------------
##  Shared  - Resource Group
## --------------------------------------------------------

module "rg_main_shared" {
  source = "../modules/resource-group"

  name     = local.shared_resource_group_name
  location = var.location
  tags     = var.tags
}


## --------------------------------------------------------
##  Network - Resource Group
## --------------------------------------------------------
 
module "rg_main_network" {
  source = "../modules/resource-group"

  name     = var.virtual_network_resource_group_name
  location = var.location
  tags     = var.tags
}

## --------------------------------------------------------
##  AKS - Resource Group
## --------------------------------------------------------
 
module "rg_main_aks" {
  source = "../modules/resource-group"

  name     = var.aks_resource_group_name
  location = var.location
  tags     = var.tags
}
