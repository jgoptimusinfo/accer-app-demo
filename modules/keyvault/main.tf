## --------------------------------------
##  LOCAL VARIABLES
## --------------------------------------

locals {
  tags = var.tags
}

## --------------------------------------
##  KEY VAULT
## --------------------------------------

data "azurerm_client_config" "current" {}

data "azuread_group" "g_sec_kv_admins" {
  count = var.kv_admins_ad_group == null ? 0 : 1

  display_name = var.kv_admins_ad_group
}

data "azuread_group" "g_sec_kv_readers" {
  count = var.kv_readers_ad_group == null ? 0 : 1

  display_name = var.kv_readers_ad_group
}

resource "azurerm_key_vault" "kv" {

  location            = var.location
  resource_group_name = var.resource_group_name

  name                       = var.name
  sku_name                   = var.sku_name
  soft_delete_retention_days = var.soft_delete_retention_days

  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  purge_protection_enabled        = var.purge_protection_enabled
  enable_rbac_authorization       = false
  public_network_access_enabled   = var.public_network_access_enabled

  tenant_id = data.azurerm_client_config.current.tenant_id

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [var.network_acls] : []
    content {
      default_action             = "Deny"
      ip_rules                   = var.network_acls.ip_rules
      virtual_network_subnet_ids = var.network_acls.virtual_network_subnet_ids
      bypass                     = var.network_acls.bybass
    }
  }

  tags = local.tags
}

resource "azurerm_key_vault_access_policy" "kv_sp" {
  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "GetRotationPolicy", "SetRotationPolicy", "Rotate"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
}

resource "azurerm_key_vault_access_policy" "kv_admins" {
  count = var.kv_admins_ad_group == null ? 0 : 1

  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_group.g_sec_kv_admins[0].object_id

  key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "GetRotationPolicy", "SetRotationPolicy", "Rotate"]
  secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
  certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
}

resource "azurerm_key_vault_access_policy" "kv_readers" {
  count = var.kv_readers_ad_group == null ? 0 : 1

  key_vault_id = azurerm_key_vault.kv.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azuread_group.g_sec_kv_readers[0].object_id

  key_permissions         = ["Get", "List"]
  secret_permissions      = ["Get", "List"]
  certificate_permissions = ["Get", "List"]
}
