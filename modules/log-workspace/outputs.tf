output "id" {
  value = azurerm_log_analytics_workspace.law.id
}

output "name" {
  value = azurerm_log_analytics_workspace.law.name
}

output "primary_shared_key" {
  value = azurerm_log_analytics_workspace.law.primary_shared_key
}

output "location" {
  value = azurerm_log_analytics_workspace.law.location
}

output "resource_group_name" {
  value = azurerm_log_analytics_workspace.law.resource_group_name
}

output "solution_plan_name_id_map" {
  description = "Map of law_solution full names to law_solution ids"
  value       = zipmap(values(azurerm_log_analytics_solution.law_solution)[*].solution_name, values(azurerm_log_analytics_solution.law_solution)[*].id)
}