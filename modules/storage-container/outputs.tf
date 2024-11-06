output "id" {
  value       = azurerm_storage_container.this.resource_manager_id
  description = "The ID of the Container."
}

output "storage_name" {
  value       = azurerm_storage_container.this.storage_account_name
  description = "The storage account name associate with."
}

output "resource_manager_id" {
  value       = azurerm_storage_container.this.resource_manager_id
  description = "The resource_manager_id of the Container."
}