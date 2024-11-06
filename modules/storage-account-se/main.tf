## --------------------------------------
##  LOCAL VARIABLES
## --------------------------------------

locals {
  tags = var.tags
}

## --------------------------------------
##  STORAGE ACCOUNT
## --------------------------------------

resource "azurerm_storage_account" "st" {

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location

  account_kind             = var.account_kind
  account_tier             = var.account_tier
  access_tier              = var.access_tier
  account_replication_type = var.account_replication_type

  large_file_share_enabled      = var.large_file_share_enabled
  public_network_access_enabled = var.public_network_access_enabled

  min_tls_version            = "TLS1_2"
  shared_access_key_enabled  = true
  https_traffic_only_enabled = true

  dynamic "network_rules" {
    for_each = var.network_rules == null ? [] : [1]
    content {
      default_action             = "Deny"
      bypass                     = var.network_rules.bypass
      ip_rules                   = var.network_rules.ip_rules
      virtual_network_subnet_ids = var.network_rules.subnet_ids
    }
  }

  identity {
    type         = var.identity_ids != null ? "SystemAssigned, UserAssigned" : "SystemAssigned"
    identity_ids = var.identity_ids
  }

  tags = local.tags
}

resource "azurerm_storage_management_policy" "this" {
  count = var.retention_policy_enabled == false ? 0 : 1

  storage_account_id = azurerm_storage_account.st.id

  rule {
    name    = "retention_rule"
    enabled = true
    filters {
      blob_types = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_creation_greater_than = var.delete_after_days_since_creation_greater_than
      }
    }
  }
}