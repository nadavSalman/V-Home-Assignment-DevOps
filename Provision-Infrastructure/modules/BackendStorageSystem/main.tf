resource "azurerm_resource_group" "backend_storage_system_rg" {
  name     = var.rg_name
  location = "eastus"
}