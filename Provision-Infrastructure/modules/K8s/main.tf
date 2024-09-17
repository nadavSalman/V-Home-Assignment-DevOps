resource "azurerm_resource_group" "k8s_rg" {
  name     = var.rg_name
  location = "eastus"
}

# Reference to the current subscription.  Used when creating role assignments
data "azurerm_subscription" "current" {}


resource "random_pet" "rg" {
  length = 1
  prefix = var.name
}
