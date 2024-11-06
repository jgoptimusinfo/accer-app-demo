# Terraform module to create Azure Virtual Network

This module creates Azure Virtual Networkp.

## Usage

```hcl

module "rg_vnet" {
  source = "../modules/resource-group" # Replace with final path on this module

  name     = "rg-${local.suffix}"
  location = var.location
  tags     = var.tags
}

module "vnet" {
  source = "../modules/network/virtual-network"

  name                = "vnet-${local.suffix}"
  address_space       = ["172.16.0.0/16"]
  resource_group_name = module.rg_vnet.name
  location            = module.rg_vnet.location

  tags = var.tags
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| azurerm | >= 3.105.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 2.41.0 |

## Modules

No Modules.