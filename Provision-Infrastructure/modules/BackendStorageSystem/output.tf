output "rg_name" {
  description = "The name of the Azure resource group"
  value       = azurerm_resource_group.backend_storage_system_rg.name
}