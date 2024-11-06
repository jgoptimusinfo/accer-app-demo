# Azure Storage Account Terraform Module

This Terraform module provisions an Azure Storage Account with optional network rules, private link, and management policies.

## Usage

```hcl
module "rg_nonprod_storage_backup" {
  source = "../modules/resource-group"

  name     = "${var.application_name}-${var.environment}-storage-01"
  location = var.location

  tags = var.tags
}


module "storage_account" {
  source = "../modules/storage-account-se"

  name                = "storagenonprod9872"
  rg_name             = module.rg_app.name
  location            = var.location

  account_kind             = "StorageV2"
  account_tier             = "Standard"
  access_tier              = "Hot"
  account_replication_type = "LRS"

  large_file_share_enabled      = true
  public_network_access_enabled = true

  identity = {
    type         = "SystemAssigned"
    identity_ids = []
  }

  network_rules = {
    bypass     = ["Metrics", "Logging", "AzureServices"]
    ip_rules   = ["186.22.13.8"]
    subnet_ids = [module.snet_backend.id]
  }

  retention_policy_enabled   = false

  tags = var.tags
}

## Variables

| Name                        | Type         | Description                                                                 |
|-----------------------------|--------------|-----------------------------------------------------------------------------|
| `location`                  | `string`     | Specifies the supported Azure location where the resource exists            |
| `tags`                      | `map(string)`| Tags                                                                        |
| `rg_name`                   | `string`     | The name of the resource group in which to create the storage account       |
| `name`                      | `string`     | Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed |
| `account_kind`              | `string`     | Defines the Kind of account. Valid options are `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage` and `StorageV2` |
| `account_tier`              | `string`     | Defines the Tier to use for this storage account. Valid options are `Standard` and `Premium` |
| `access_tier`               | `string`     | Defines the access tier for `BlobStorage`, `FileStorage` and `StorageV2` accounts. Valid options are `Hot` and `Cool` |
| `account_replication_type`  | `string`     | Defines the type of replication to use for this storage account. Valid options are `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS` and `RAGZRS` |
| `large_file_share_enabled`  | `bool`       | Is Large File Share Enabled                                                 |
| `public_network_access_enabled` | `bool`   | Whether the public network access is enabled                                |
| `network_rules`             | `object`     | Network rules restricting access to the storage account                     |
| `identity`                  | `object`     | An identity block supports                                                  |
| `retention_policy_enabled`  | `bool`       | Enable Blob Storage Account Retention Policy                                |

## Outputs

| Name         | Description |
|--------------|-------------|
| `id`         | The ID of the storage account |
| `name`       | The name of the storage account |
| `access_key` | The primary access key for the storage account |
