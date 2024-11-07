
## --------------------------------------------------------
##  Storage - main
## --------------------------------------------------------
/* 
module "storage_main" {
  source = "../modules/storage-account-se"

  location            = var.location
  resource_group_name = module.rg_main_shared.name
  name                = var.storage_account_config.name

  account_replication_type      = var.storage_account_config.account_replication_type
  large_file_share_enabled      = var.storage_account_config.large_file_share_enabled
  public_network_access_enabled = var.storage_account_config.public_network_access_enabled
  account_tier                  = var.storage_account_config.account_tier
  account_kind                  = var.storage_account_config.account_kind
  access_tier                   = var.storage_account_config.access_tier

  tags = var.tags
}  */