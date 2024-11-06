# Azure Keyvault Access policy Setting Module

This Terraform module is designed to create and manage Azure Keyvault Settings. It allows you to configure keyvault settings.

## Usage

Below is an example of how to use this module to configure KeyVault for an Azure resource.



```terraform

variable "keyvault_config" {
  description = "Configuration for Keyvault"
  type = object({
    name                          = string
    sku_name                      = string
    soft_delete_retention_days    = number
    purge_protection_enabled      = bool
    public_network_access_enabled = bool
  })
}

keyvault_config = {
  name                          = "msi-cf-sbx-eus2-kv"
  sku_name                      = "standard"
  soft_delete_retention_days    = 7 # 90
  purge_protection_enabled      = false
  public_network_access_enabled = true
}

module "keyvault_main" {
  source = "../modules/keyvault"

  location            = var.location
  resource_group_name = module.rg_main_shared.name

  name                          = var.keyvault_config.name
  sku_name                      = var.keyvault_config.sku_name
  soft_delete_retention_days    = var.keyvault_config.soft_delete_retention_days
  purge_protection_enabled      = var.keyvault_config.purge_protection_enabled
  public_network_access_enabled = var.keyvault_config.public_network_access_enabled

  enabled_for_deployment          = false
  enabled_for_disk_encryption     = false
  enabled_for_template_deployment = false

  tags = var.tags
}
```