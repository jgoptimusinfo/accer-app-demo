# Introduction 
TODO: Give a short introduction of your project. Let this section explain the objectives or the motivation behind this project. 

# Build and Test
TODO: Describe and show how to build your code and run the tests. 

# Pre-requisites
- Create a Azure DNS zone for Private Endpoint

```hcl
module "resource_group_storage" {
  source = "../modules/resource-group"

  name     = "rg-storage"
  location = var.location
  tags     = var.tags
}

resource "azurerm_private_dns_zone" "st_zone" {
  name                = "privatelink.file.core.windows.net"
  resource_group_name = module.resource_group_storage.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "network_link_st_zone" {
  name                  = "storage_file_vnet_link"
  resource_group_name   = module.resource_group_storage.name
  private_dns_zone_name = azurerm_private_dns_zone.st_zone.name
  virtual_network_id    = azurerm_virtual_network.vnet_core.id
}

´´´
# Example

```hcl

module "resource_group_storage" {
  source = "../modules/resource-group"

  name     = "rg-storage"
  location = var.location
  tags     = var.tags
}

module "storage_account" {
  source = "../modules/storage-private"
  
  resource_group_name     = module.resource_group_storage.name
  location                = module.resource_group_storage.location

  name                  = "jg873asd123hhsd"
  private_dns_zone_name = azurerm_private_dns_zone.st_zone.name
  subnet_id             = azurerm_subnet.private_endpoint.id 
  
  network_rules = {
    bypass     = ["AzureServices"],
    subnet_ids = []
    ip_rules   = []
  }
  
  tags                  = var.tags
}

````