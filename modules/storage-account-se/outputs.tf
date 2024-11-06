output "id" {
  value       = azurerm_storage_account.st.id
  description = "id"
}

output "name" {
  value       = azurerm_storage_account.st.name
  description = "name"
}

output "access_key" {
  value       = azurerm_storage_account.st.primary_access_key
  description = "key"
}

output "principal_id" {
  value       = flatten(azurerm_storage_account.st.identity.*.principal_id)
  description = "The Principal ID for the Service Principal associated with the Managed Service Identity of this Storage account"

}