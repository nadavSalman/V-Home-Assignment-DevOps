resource "azurerm_resource_group" "k8s_rg" {
  name     = var.rg_name
  location = "eastus"
}