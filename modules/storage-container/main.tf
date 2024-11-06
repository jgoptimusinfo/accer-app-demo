#--------------------
# Local declarations
#--------------------

locals {
}

#-------------------
# Data declarations
#-------------------


#-----------------------
# Azure Storage Resource
# ----------------------

resource "azurerm_storage_container" "this" {
  name                  = var.name
  storage_account_name  = var.storage_account_name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "role_contributor" {
  scope                = azurerm_storage_container.this.resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.principal_id
}

resource "azurerm_role_assignment" "role_reader" {
  scope                = azurerm_storage_container.this.resource_manager_id
  role_definition_name = "Reader"
  principal_id         = var.principal_id
}
/* 
resource "azurerm_storage_management_policy" "this" {
  storage_account_id = join("/", slice(split("/", azurerm_storage_container.this.resource_manager_id), 0, 9))

  rule {
    name    = "retention_rule"
    enabled = true
    filters {
      blob_types   = ["blockBlob"]
    }
    actions {
      base_blob {
        delete_after_days_since_creation_greater_than = 1
      }
    }
  }
} */