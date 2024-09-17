resource "azurerm_resource_group" "k8s_rg" {
  name     = var.rg_name
  location = "eastus"
}

# Reference to the current subscription.  Used when creating role assignments
data "azurerm_subscription" "current" {}

output "subscription_id" {
  value       = data.azurerm_subscription.current.subscription_id
  description = "The ID of the current Azure subscription."
}

resource "random_pet" "rg" {
  length = 1
  prefix = var.name
}
