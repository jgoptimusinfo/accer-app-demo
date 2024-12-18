output "sql_server_fqdn" {
  description = "Fully Qualified Domain Name (FQDN) of the Azure SQL Database created."
  value       = azurerm_mssql_server.server.fully_qualified_domain_name
}

output "sql_server_location" {
  description = "Location of the Azure SQL Database created."
  value       = azurerm_mssql_server.server.location
}

output "sql_server_name" {
  description = "Server name of the Azure SQL Database created."
  value       = azurerm_mssql_server.server.name
}

output "sql_server_version" {
  description = "Version the Azure SQL Database created."
  value       = azurerm_mssql_server.server.version
}