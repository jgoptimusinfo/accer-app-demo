# Terraform module to create Azure Subnet

This module creates Azure Subnet

## Usage

```hcl

module "AzureBastionSubnet" {
  source = "../modules/network/virtual-subnet"

  vnet_id                = module.example_vnet.id

  subnet = {
    name                                          = "AzureBastionSubnet"
    address_prefixes                              = ["172.16.0.0/24"]
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
  }
}

module "back-end" {
  source = "../modules/network/virtual-subnet"

  vnet_id                = module.example_vnet.id

  service_endpoints = ["Microsoft.Storage"]
  
  subnet = {
    name                                          = "AzureBastionSubnet"
    address_prefixes                              = ["172.16.0.0/24"]
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
  }
}

module "front-end" {
  source = "../modules/network/virtual-subnet"

  vnet_id                = module.example_vnet.id

  subnet = {
    name                                          = "front-end"
    address_prefixes                              = ["172.16.2.0/24"]
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
  }
  
  service_delegation_name     = "Microsoft.DBforMySQL/flexibleServers"
  service_delegation_actions  = [
    "Microsoft.Network/virtualNetworks/subnets/join/action",
    "Microsoft.Network/virtualNetworks/subnets/action"
  ]
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| azurerm | >= 2.41.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.41.0 |

## Modules

No Modules.