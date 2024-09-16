resource "azurerm_resource_group" "demo" {
  name     = var.rg-name
  location = "eastus"
}